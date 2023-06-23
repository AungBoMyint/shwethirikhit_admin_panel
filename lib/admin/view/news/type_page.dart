import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pizza/models/object_models/category.dart';
import 'package:pizza/models/object_models/type.dart';
import 'package:pizza/service/query.dart';
import 'package:pizza/service/reference.dart';

import '../../../models/object_models/expert.dart';
import '../../../models/rbpoint.dart';
import '../../controller/admin_login_controller.dart';
import '../../controller/admin_ui_controller.dart';
import '../../controller/news_controller.dart';
import '../../utils/func.dart';
import '../../utils/space.dart';
import '../../utils/widgets.dart';
import '../../widgets/news/add_type_form.dart';

class TypePage extends StatelessWidget {
  const TypePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
                      onChanged: (v) => newsController.debouncer.run(() {
                        newsController.startTypeSearch(v);
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

                        Expanded(child: Container()),
                        CreateButton(
                          title: "Create Type",
                          onPressed: () {
                            Get.dialog(
                              Center(
                                child: SizedBox(
                                  height: size.height * 0.3,
                                  width: size.width * 0.5,
                                  child: Material(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 20,
                                        right: 20,
                                        top: 20,
                                        bottom: 10,
                                      ),
                                      child: AddTypeForm(
                                        width: size.width,
                                        newsController: newsController,
                                        dropDownBorder: dropDownBorder(),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              barrierColor: Colors.black.withOpacity(0.2),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                //Table
                const Divider(),
                Expanded(child: Obx(() {
                  return FirestoreQueryBuilder<ItemType>(
                      query: newsController.typeQuery.value!,
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
                          debugPrint("${snapshot.error}");
                          return Text(
                              'Something went wrong! ${snapshot.error}');
                        }

                        if (snapshot.hasData && snapshot.docs.isNotEmpty) {
                          newsController.setTypeSnapshot(snapshot);
                        }

                        return Obx(() {
                          final selectedAll =
                              newsController.typeSelectedAll.value;
                          final selectedRow = newsController.typeSelectedRow;
                          return DataTable2(
                            showCheckboxColumn: true,
                            scrollController:
                                newsController.typeScrollController,
                            columnSpacing: 20,
                            horizontalMargin: 20,
                            minWidth: 600,
                            /* onSelectAll: (v) => newsController.setSli, */
                            columns: [
                              DataColumn2(
                                label: Checkbox(
                                  value: selectedAll,
                                  activeColor: Theme.of(context).primaryColor,
                                  onChanged: (_) {
                                    if (!selectedAll) {
                                      newsController
                                          .setTypeSelectedAll(snapshot.docs);
                                    } else {
                                      newsController.setTypeSelectedAll(null);
                                    }
                                  },
                                  side: BorderSide(
                                    color: Colors.black,
                                    width: 2,
                                  ),
                                ),
                                fixedWidth: 80,
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
                                  'Total Items',
                                  style: titleTextStyle,
                                ),
                                size: ColumnSize.L,
                              ),

                              DataColumn2(
                                label: Text(
                                  'Actions',
                                  style: titleTextStyle,
                                  textAlign: TextAlign.center,
                                ),
                                fixedWidth: 100,
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
                                        activeColor:
                                            Theme.of(context).primaryColor,
                                        value: selectedRow.contains(item.id),
                                        onChanged: (_) => newsController
                                            .setTypeSelectedRow(item),
                                        side: const BorderSide(
                                          color: Colors.black,
                                          width: 1.5,
                                        ),
                                      ),
                                    ),

                                    DataCell(
                                      Text(
                                        item.name,
                                        style: bodyTextStyle,
                                      ),
                                    ),
                                    //Total Items
                                    DataCell(FutureBuilder(
                                        future: expertQuery(item.id).get(),
                                        builder:
                                            (context, AsyncSnapshot snapshot) {
                                          if (snapshot.hasData) {
                                            return Text(
                                              "${snapshot.data.docs.length}",
                                              style: bodyTextStyle,
                                              maxLines: 3,
                                            );
                                          }
                                          return Text(
                                            "0",
                                            style: bodyTextStyle,
                                            maxLines: 3,
                                          );
                                        })),

                                    DataCell(Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          iconSize: 25,
                                          onPressed: () => delete<ItemType>(
                                              homeTypeDocument(item.id),
                                              "Type deleting is successful.",
                                              "Type deleting is failed."),
                                          icon: Icon(
                                            FontAwesomeIcons.trash,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                        IconButton(
                                          iconSize: 25,
                                          onPressed: () {
                                            Get.dialog(
                                              Center(
                                                child: SizedBox(
                                                  height: size.height * 0.3,
                                                  width: size.width * 0.5,
                                                  child: Material(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20)),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        left: 20,
                                                        right: 20,
                                                        top: 20,
                                                        bottom: 10,
                                                      ),
                                                      child: AddTypeForm(
                                                        width: size.width,
                                                        newsController:
                                                            newsController,
                                                        dropDownBorder:
                                                            dropDownBorder(),
                                                        type: item,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              barrierColor:
                                                  Colors.black.withOpacity(0.2),
                                            );
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
        onTap: () => deleteItems<ItemType>(
          prController.typeSelectedRow,
          homeTypeCollection(),
        ),
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
