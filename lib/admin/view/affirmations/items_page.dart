import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:pizza/admin/controller/affirmations_controller.dart';
import 'package:pizza/models/object_models/category.dart';
import 'package:pizza/models/object_models/music.dart';
import 'package:pizza/models/object_models/type.dart';
import 'package:pizza/models/page_type.dart';
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
import '../../widgets/affirmations/add_music_form.dart';

class AffirmationsItemsPage extends StatelessWidget {
  const AffirmationsItemsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AdminUiController controller = Get.find();
    final AffirmationsController newsController = Get.find();
    final textTheme = Theme.of(context).textTheme;
    final titleTextStyle = textTheme.displayMedium?.copyWith(fontSize: 22);
    final bodyTextStyle = textTheme.displayMedium;
    final size = MediaQuery.of(context).size;
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
                        newsController.startItemSearch(v);
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
                          title: "Create Music",
                          onPressed: () {
                            //TODO:CREATE ITEM
                            Get.dialog(
                              Center(
                                child: SizedBox(
                                  height: size.height * 0.7,
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
                                      child: AddMusicForm(
                                        dropDownBorder: dropDownBorder(),
                                        therapyController: newsController,
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
                  return FirestoreQueryBuilder<Music>(
                      query: newsController.itemsQuery.value!,
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
                          newsController.setItemsSnapshot(snapshot);
                        }

                        return Obx(() {
                          final selectedAll =
                              newsController.itemsSelectedAll.value;
                          final selectedRow = newsController.itemsSelectedRow;
                          return DataTable2(
                            showCheckboxColumn: true,
                            scrollController:
                                newsController.itemScrollController,
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
                                          .setItemsSelectedAll(snapshot.docs);
                                    } else {
                                      newsController.setItemsSelectedAll(null);
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
                                  'Image',
                                  style: titleTextStyle,
                                ),
                                size: ColumnSize.L,
                              ),
                              DataColumn(
                                label: Text(
                                  'Music',
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
                                        activeColor:
                                            Theme.of(context).primaryColor,
                                        value: selectedRow.contains(item.id),
                                        onChanged: (_) => newsController
                                            .setItemsSelectedRow(item),
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
                                    DataCell(Image.network(
                                      item.image,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.contain,
                                    )),
                                    DataCell(
                                      Text(
                                        item.audioURL,
                                        style: bodyTextStyle,
                                      ),
                                    ),
                                    DataCell(Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          iconSize: 25,
                                          onPressed: () => delete<Music>(
                                              musicDocument(item.id),
                                              "Item deleting is successful.",
                                              "Item deleting is failed."),
                                          icon: Icon(
                                            FontAwesomeIcons.trash,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                        IconButton(
                                          iconSize: 25,
                                          onPressed: () {
                                            //TODO:VIEW ITEM
                                          },
                                          icon: Icon(
                                            FontAwesomeIcons.eye,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                        IconButton(
                                          iconSize: 25,
                                          onPressed: () {
                                            //TODO:EDIT MUSIC
                                            Get.dialog(
                                              Center(
                                                child: SizedBox(
                                                  height: size.height * 0.7,
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
                                                      child: AddMusicForm(
                                                        dropDownBorder:
                                                            dropDownBorder(),
                                                        therapyController:
                                                            newsController,
                                                        music: item,
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
  final AffirmationsController prController = Get.find();
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
        onTap: () => deleteItems<Music>(
          prController.itemsSelectedRow,
          musicCollection(),
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
