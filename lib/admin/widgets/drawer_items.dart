import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart' hide DrawerHeader;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pizza/admin/widgets/sub_item.dart';

import '../../../constant/data.dart';
import '../../../constant/icon.dart';
import '../../../models/page_type.dart';
import '../../../models/rbpoint.dart';
import '../controller/admin_login_controller.dart';
import '../controller/admin_ui_controller.dart';
import '../utils/space.dart';
import 'bottom_header.dart';
import 'drawer_header.dart';
import 'drawer_item.dart';

class DrawerItems extends GetView<AdminLoginController> {
  const DrawerItems({
    super.key,
    required this.textTheme,
  });

  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    final AdminLoginController alController = Get.find();
    final AdminUiController adminUiController = Get.find();
    final pageType = adminUiController.pageType.value;
    return Expanded(
      flex: adminUiController.rbPoint.value!.getOrElse(() => RBPoint.xl()).map(
          xl: (_) => 2, desktop: (_) => 2, tablet: (_) => 1, mobile: (_) => 1),
      child: LayoutBuilder(builder: (context, constraints) {
        final height = constraints.maxHeight;
        final width = constraints.maxWidth;
        return /* Drawer(
            backgroundColor: controller.isLightTheme.value
                ? Colors.white
                : darkThemeCardColor,
            elevation: 0,
            child:  */
            Container(
          color: Theme.of(context).cardTheme.color,
          height: height,
          width: width,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                verticalSpace(),
                //DrawerHeader
                DrawerHeader(textTheme: textTheme),
                verticalSpace(),
                Divider(),
                //DrawerItems
                verticalSpace(v: 15),

                verticalSpace(v: 10),
                //Overview
                Obx(() {
                  final pageType = adminUiController.pageType.value!
                      .getOrElse(() => PageType.initial());
                  return DrawerItem(
                    onTap: () =>
                        adminUiController.changePageType(PageType.initial()),
                    textTheme: textTheme,
                    isSelected: pageType == PageType.initial(),
                    imageIcon: AdminIcon.columnChart,
                    label: "Overview",
                  );
                }),
                verticalSpace(v: 10),
                //News
                ExpandablePanel(
                  theme: ExpandableThemeData(
                    expandIcon: null,
                    collapseIcon: null,
                    iconColor: Colors.grey,
                    tapHeaderToExpand: true,
                    iconPadding: EdgeInsets.zero,
                  ),
                  header: DrawerItem(
                    onTap: null,
                    textTheme: textTheme,
                    isSelected: pageType == PageType.newsSlider() ||
                        pageType == PageType.newsType() ||
                        pageType == PageType.newsItems(),
                    imageIcon: AdminIcon.news,
                    label: "News",
                  ),
                  collapsed: const SizedBox(),
                  expanded: Container(
                    color: Theme.of(context).cardTheme.color,
                    padding: const EdgeInsets.only(
                      left: 40,
                    ),
                    height: 160,
                    child: Obx(() {
                      final pageType = adminUiController.pageType.value!
                          .getOrElse(() => PageType.initial());
                      return Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          SubItem(
                            onTap: () {
                              adminUiController
                                  .changePageType(PageType.newsSlider());
                            },
                            title: "Slider",
                            isSelected: pageType == PageType.newsSlider(),
                          ),
                          SubItem(
                            onTap: () {
                              adminUiController
                                  .changePageType(PageType.newsType());
                            },
                            title: "Type",
                            isSelected: pageType == PageType.newsType(),
                          ),
                          SubItem(
                            onTap: () {
                              adminUiController
                                  .changePageType(PageType.newsItems());
                            },
                            title: "Items",
                            isSelected: pageType == PageType.newsItems() ||
                                pageType == PageType.newsItemsAdd(),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
                verticalSpace(v: 10),
                //Vlog
                Obx(() {
                  final pageType = adminUiController.pageType.value!
                      .getOrElse(() => PageType.initial());
                  return DrawerItem(
                    onTap: () =>
                        adminUiController.changePageType(PageType.vlog()),
                    textTheme: textTheme,
                    isSelected: pageType == PageType.vlog() ||
                        pageType == PageType.vlogAdd(),
                    imageIcon: AdminIcon.vlog,
                    label: "Vlog",
                  );
                }),
                verticalSpace(v: 10),
                //Affirmations
                ExpandablePanel(
                  theme: ExpandableThemeData(
                    iconColor: Colors.grey,
                    tapHeaderToExpand: true,
                    iconPadding: EdgeInsets.zero,
                  ),
                  header: DrawerItem(
                    onTap: null,
                    textTheme: textTheme,
                    isSelected:
                        false /* pageType == const PageType.products() */,
                    imageIcon: AdminIcon.therapy,
                    label: "Therapy",
                  ),
                  collapsed: const SizedBox(),
                  expanded: Container(
                    color: Theme.of(context).cardTheme.color,
                    padding: const EdgeInsets.only(
                      left: 40,
                    ),
                    height: 125,
                    child: Obx(() {
                      final pageType = adminUiController.pageType.value!
                          .getOrElse(() => PageType.initial());
                      return Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          SubItem(
                            onTap: () {
                              adminUiController
                                  .changePageType(PageType.therapyCategory());
                            },
                            title: "Categories",
                            isSelected: pageType == PageType.therapyCategory(),
                          ),
                          SubItem(
                            onTap: () {
                              adminUiController
                                  .changePageType(PageType.therapyItems());
                            },
                            title: "Items",
                            isSelected: pageType == PageType.therapyItems(),
                          ),
                        ],
                      );
                    }),
                  ),
                ),

                verticalSpace(v: 10),
                //Affirmations
                ExpandablePanel(
                  theme: ExpandableThemeData(
                    iconColor: Colors.grey,
                    tapHeaderToExpand: true,
                    iconPadding: EdgeInsets.zero,
                  ),
                  header: DrawerItem(
                    onTap: null,
                    textTheme: textTheme,
                    isSelected:
                        false /* pageType == const PageType.products() */,
                    imageIcon: AdminIcon.affirmations,
                    label: "Affirmations",
                  ),
                  collapsed: const SizedBox(),
                  expanded: Container(
                    color: Theme.of(context).cardTheme.color,
                    padding: const EdgeInsets.only(
                      left: 40,
                    ),
                    height: 160,
                    child: Obx(() {
                      final pageType = adminUiController.pageType.value!
                          .getOrElse(() => PageType.initial());
                      return Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          SubItem(
                            onTap: () {
                              adminUiController.changePageType(
                                  PageType.affirmationsCategory());
                            },
                            title: "Categories",
                            isSelected:
                                pageType == PageType.affirmationsCategory(),
                          ),
                          SubItem(
                            onTap: () {
                              adminUiController
                                  .changePageType(PageType.affirmationsType());
                            },
                            title: "Type",
                            isSelected: pageType == PageType.affirmationsType(),
                          ),
                          SubItem(
                            onTap: () {
                              adminUiController
                                  .changePageType(PageType.affirmationsItems());
                            },
                            title: "Items",
                            isSelected:
                                pageType == PageType.affirmationsItems(),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
                verticalSpace(v: 10),
                //Vlog
                Obx(() {
                  final pageType = adminUiController.pageType.value!
                      .getOrElse(() => PageType.initial());
                  return DrawerItem(
                    onTap: () =>
                        adminUiController.changePageType(PageType.customers()),
                    textTheme: textTheme,
                    isSelected: pageType == PageType.vlog() ||
                        pageType == PageType.vlogAdd(),
                    imageIcon: AdminIcon.rowUser,
                    label: "Users",
                  );
                }),
                verticalSpace(v: 10),
                Divider(),
                verticalSpace(),
                DrawerItem(
                  onTap: () => alController.signOut(),
                  textTheme: textTheme,
                  isSelected: false,
                  imageIcon: AdminIcon.enter,
                  label: "Log out",
                ),
              ],
            ),
          ),
          /*  ), */
        );
      }),
    );
  }
}
