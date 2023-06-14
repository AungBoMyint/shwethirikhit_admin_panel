import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:pizza/models/object_models/category.dart';

import '../../../models/rbpoint.dart';
import '../../controller/admin_login_controller.dart';
import '../../controller/admin_ui_controller.dart';
import '../../controller/news_controller.dart';
import '../../utils/space.dart';

class SliderPage extends StatelessWidget {
  const SliderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AdminUiController controller = Get.find();
    final NewsController newsController = Get.find();
    final textTheme = Theme.of(context).textTheme;
    final titleTextStyle = textTheme.displayMedium?.copyWith(fontSize: 22);
    final bodyTextStyle = textTheme.displayMedium;
    dropDownBorder() => const OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.black,
        ));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
            child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              //Search
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Search",
                      style: textTheme.displayLarge?.copyWith(
                        fontSize: controller.rbPoint.value!
                            .getOrElse(() => RBPoint.xl())
                            .map(
                                xl: (_) => 16,
                                desktop: (_) => 12,
                                tablet: (_) => 10,
                                mobile: (_) => 8),
                      ),
                    ),
                    verticalSpace(),
                    TextFormField(
                      controller: newsController.searchTextController,
                      onChanged: (v) => newsController.debouncer.run(() {
                        newsController.startSliderSearch();
                      }),
                      decoration: InputDecoration(
                        border: dropDownBorder(),
                        disabledBorder: dropDownBorder(),
                        focusedBorder: dropDownBorder(),
                        enabledBorder: dropDownBorder(),
                        suffixIcon: Icon(Icons.search, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )),

        //Table
        Expanded(
          flex: controller.rbPoint.value!.fold(
            (l) => 0,
            (r) => r.map(
              xl: (_) => 7,
              desktop: (_) => 7,
              tablet: (_) => 8,
              mobile: (_) => 8,
            ),
          ),
          child: Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                verticalSpace(),
                //Head Actions
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: SizedBox(
                    height: 80,
                    child: Row(
                      /*  mainAxisAlignment: MainAxisAlignment.spaceBetween, */
                      children: [
                        //action
                        GestureDetector(
                          onTapDown: (TapDownDetails details) {
                            showPopupMenu(context, details.globalPosition);
                          },
                          child: SizedBox(
                            height: 50,
                            child: Card(
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(
                                  10,
                                ))),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    "Action",
                                    style: textTheme.displayLarge,
                                  ),
                                )),
                          ),
                        ),

                        const Expanded(child: SizedBox()),
                        horizontalSpace(),
                        //Create Item
                        /*  SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              upController.setEditItem(null);
                              /* prController.setSelectedItem(null); */
                              adminUiController.setProductPageType(
                                  ProductPageType.addProduct());
                            },
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                  horizontalSpace(v: 15),
                                  Text(
                                    "Create item",
                                    style: textTheme.displayMedium?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ]),
                          ),
                        ),
                       */
                      ],
                    ),
                  ),
                ),
                //Table
                const Divider(),
                Expanded(child: Obx(() {
                  return FirestoreQueryBuilder<Category>(
                      query: newsController.sliderQuery.value!,
                      pageSize: 15,
                      builder: (context, snapshot, _) {
                        if (snapshot.isFetching) {
                          return const Center(
                            child: SizedBox(
                              height: 50,
                              width: 50,
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        if (snapshot.hasError) {
                          return Text(
                              'Something went wrong! ${snapshot.error}');
                        }

                        if (snapshot.hasData && snapshot.docs.isNotEmpty) {
                          newsController.setSliderSnapshot(snapshot);
                        }

                        return Obx(() {
                          final selectedAll =
                              newsController.sliderSelectedAll.value;
                          final selectedRow = newsController.sliderSelectedRow;
                          return DataTable2(
                            showCheckboxColumn: true,
                            scrollController:
                                newsController.sliderScrollController,
                            columnSpacing: 20,
                            horizontalMargin: 20,
                            minWidth: 600,
                            /* onSelectAll: (v) => newsController.setSli, */
                            columns: [
                              DataColumn2(
                                label: Checkbox(
                                  value: selectedAll,
                                  onChanged: (_) {
                                    if (!selectedAll) {
                                      newsController
                                          .setSliderSelectedAll(snapshot.docs);
                                    } else {
                                      newsController.setSliderSelectedAll(null);
                                    }
                                  },
                                  side: BorderSide(
                                    color: Colors.black,
                                    width: 2,
                                  ),
                                ),
                                fixedWidth: 80,
                              ),
                              DataColumn2(
                                label: Text(
                                  'ID',
                                  style: titleTextStyle,
                                ),
                                fixedWidth: 140,
                              ),
                              DataColumn(
                                label: Text(
                                  'Name',
                                  style: titleTextStyle,
                                ),
                              ),
                              //Out of stock
                              DataColumn2(
                                label: Text(
                                  'Image',
                                  style: titleTextStyle,
                                ),
                                size: ColumnSize.L,
                              ),
                              DataColumn(
                                label: Text(
                                  'Order',
                                  style: titleTextStyle,
                                ),
                              ),
                              DataColumn2(
                                label: Text(
                                  'Actions',
                                  style: titleTextStyle,
                                  textAlign: TextAlign.center,
                                ),
                                fixedWidth: 160,
                              ),
                            ],
                            rows: List.generate(
                              snapshot.docs.length,
                              (index) {
                                final item = snapshot.docs[index].data();
                                return DataRow(
                                  cells: [
                                    DataCell(
                                      Checkbox(
                                        value: selectedRow.contains(item.id),
                                        onChanged: (_) => newsController
                                            .setSliderSelectedRow(item),
                                        side: const BorderSide(
                                          color: Colors.black,
                                          width: 1.5,
                                        ),
                                      ),
                                    ),
                                    DataCell(Padding(
                                      padding: const EdgeInsets.only(right: 45),
                                      child: Text(
                                        item.id,
                                        style: bodyTextStyle,
                                        maxLines: 3,
                                      ),
                                    )),
                                    DataCell(
                                      NameWidget(
                                        text: item.name,
                                        bodyTextStyle: bodyTextStyle,
                                        isChanged:
                                            selectedRow.contains(item.id),
                                        onEditingComplete: () {
                                          debugPrint(
                                              "******On Editing Complete****");
                                          newsController
                                              .setSliderSelectedRow(item);
                                        },
                                      ),
                                    ),
                                    //Out of Stock
                                    DataCell(Image.network(
                                      item.image,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.contain,
                                    )),
                                    DataCell(
                                      NameWidget(
                                        text: "${item.order}",
                                        bodyTextStyle: bodyTextStyle,
                                        isChanged:
                                            selectedRow.contains(item.id),
                                        onEditingComplete: () {
                                          debugPrint(
                                              "******On Editing Complete****");
                                          newsController
                                              .setSliderSelectedRow(item);
                                        },
                                      ),
                                    ),

                                    DataCell(Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          iconSize: 25,
                                          onPressed:
                                              () {} /* =>
                                              prController.deleteItems([item]) */
                                          ,
                                          icon: Icon(
                                            FontAwesomeIcons.trash,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                        IconButton(
                                          iconSize: 25,
                                          onPressed: () {
                                            /*   upController.setEditItem(item);
                                            /* prController.setSelectedItem(item); */
                                            adminUiController
                                                .setProductPageType(
                                                    ProductPageType
                                                        .viewProduct()); */
                                          },
                                          icon: Icon(
                                            FontAwesomeIcons.eye,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                        IconButton(
                                          iconSize: 25,
                                          onPressed: () {
                                            /* upController.setEditItem(item);
                                            /* prController.setSelectedItem(item); */
                                            adminUiController
                                                .setProductPageType(
                                                    ProductPageType
                                                        .editProduct()); */
                                          },
                                          icon: Icon(
                                            FontAwesomeIcons.pen,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    )),
                                  ],
                                );
                              },
                            ),
                          );
                        });
                      });
                })),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class NameWidget extends StatefulWidget {
  const NameWidget({
    super.key,
    required this.text,
    required this.bodyTextStyle,
    required this.isChanged,
    required this.onEditingComplete,
  });

  final String text;
  final TextStyle? bodyTextStyle;
  final isChanged;
  final void Function()? onEditingComplete;

  @override
  State<NameWidget> createState() => _NameWidgetState();
}

class _NameWidgetState extends State<NameWidget> {
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    textEditingController.text = widget.text;
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AdminLoginController alController = Get.find();

    dropDownBorder() => OutlineInputBorder(
            borderSide: BorderSide(
          color: alController.isLightTheme.value
              ? Theme.of(context).dividerColor
              : Colors.grey.shade100,
        ));
    return widget.isChanged
        ? TextFormField(
            autofocus: true,
            style: widget.bodyTextStyle,
            controller: textEditingController,
            onEditingComplete: widget.onEditingComplete,
            decoration: InputDecoration(
              border: InputBorder.none,
              disabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
            ),
          )
        : Text(
            widget.text,
            style: widget.bodyTextStyle,
          );
  }
}

void showPopupMenu(BuildContext context, Offset position) async {
  final NewsController prController = Get.find();
  final textTheme = Theme.of(context).textTheme;
  final RenderBox overlay =
      Overlay.of(context).context.findRenderObject() as RenderBox;
  final RenderBox popupButton = context.findRenderObject() as RenderBox;
  final Offset targetPosition =
      popupButton.localToGlobal(Offset.zero, ancestor: overlay);
  final result = await showMenu(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(20),
      ),
    ),
    position: RelativeRect.fromLTRB(
      position.dx,
      position.dy,
      targetPosition.dx + popupButton.size.width,
      targetPosition.dy + popupButton.size.height,
    ),
    items: [
      PopupMenuItem(
        value: 'delete',
        onTap: () {} /*  => prController.deleteItems(null) */,
        child: Text(
          "Delete",
          style: textTheme.displayMedium?.copyWith(
            color: Colors.green,
          ),
        ),
      ),
    ],
  );
}
