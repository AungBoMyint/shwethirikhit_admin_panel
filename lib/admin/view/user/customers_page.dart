import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../constant/icon.dart';
import '../../../models/auth_user.dart';
import '../../../models/customer_filter_type.dart';
import '../../../models/page_type.dart';
import '../../controller/admin_login_controller.dart';
import '../../controller/admin_ui_controller.dart';
import '../../controller/customer_related_controller.dart';
import '../../utils/constant.dart';
import '../../utils/show_loading.dart';
import '../../utils/space.dart';
import '../../widgets/button.dart';

class CustomersPage extends StatefulWidget {
  const CustomersPage({super.key});

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  late ScrollController scrollController;
  final CustomerRelatedController crController = Get.find();
  @override
  void initState() {
    scrollController = ScrollController(initialScrollOffset: 0.0);
    crController.setScrollListener(scrollController);
    crController.startGetUsers();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.removeListener(() {});
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AdminLoginController alController = Get.find();
    final AdminUiController adminUiController = Get.find();
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
        //Filters Search
        Card(
            child: Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 5,
            bottom: 5,
          ),
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
                      style: textTheme.displayLarge,
                    ),
                    verticalSpace(v: 10),
                    TextFormField(
                      controller: crController.searchController,
                      onChanged: (v) => crController.debouncer.run(() {
                        crController.startSearch();
                      }),
                      decoration: InputDecoration(
                        border: dropDownBorder(),
                        disabledBorder: dropDownBorder(),
                        focusedBorder: dropDownBorder(),
                        enabledBorder: dropDownBorder(),
                        suffixIcon: Icon(Icons.search,
                            color: Theme.of(context).iconTheme.color),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )),

        //Customers Table
        Expanded(
          child: Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                verticalSpace(v: 5),
                //Head Actions
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: SizedBox(
                    height: 80,
                    child: Row(
                      /* mainAxisAlignment: MainAxisAlignment.spaceBetween, */
                      children: [
                        const Expanded(child: SizedBox()),
                        //Add User
                        SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              crController.setEditUser(null);
                              adminUiController
                                  .changePageType(PageType.addCustomer());
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
                                    "Add User",
                                    style: textTheme.displayMedium?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //Table
                const Divider(),
                Expanded(
                  child: Obx(() {
                    final users = crController.users;
                    return DataTable2(
                      scrollController: scrollController,
                      columnSpacing: 20,
                      horizontalMargin: 20,
                      minWidth: 600,
                      onSelectAll: (v) =>
                          adminUiController.setDataTableSelectAll(),
                      columns: [
                        DataColumn2(
                          label: Text(
                            'ID',
                            style: titleTextStyle,
                          ),
                          fixedWidth: 100,
                        ),
                        DataColumn2(
                          label: Text(
                            'USER',
                            style: titleTextStyle,
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'ROLE',
                            style: titleTextStyle,
                          ),
                        ),
                        DataColumn2(
                          label: Text(
                            'ACTIONS',
                            style: titleTextStyle,
                            textAlign: TextAlign.center,
                          ),
                          fixedWidth: 160,
                        ),
                      ],
                      rows: List.generate(users.length, (index) {
                        final user = users[index];
                        return DataRow(cells: [
                          //ID
                          DataCell(
                            Text(
                              user.id,
                              style: textTheme.displayMedium,
                            ),
                          ),
                          DataCell(Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: NetworkImage(
                                  user.avatar ?? emptyProfile,
                                ),
                              ),
                              horizontalSpace(v: 10),
                              Expanded(
                                child: Text(
                                  user.name,
                                  style: textTheme.displayMedium,
                                ),
                              )
                            ],
                          )),
                          DataCell(Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: user.status == 1
                                    ? Colors.green.withOpacity(0.3)
                                    : Colors.blue.withOpacity(0.3),
                                child: user.status == 1
                                    ? Icon(FontAwesomeIcons.userSecret,
                                        color: Colors.green)
                                    : Icon(
                                        FontAwesomeIcons.user,
                                        color: Colors.blue,
                                      ),
                              ),
                              horizontalSpace(v: 10),
                              Text(
                                user.status == 1 ? "Admin" : "Customer",
                                style: textTheme.displayMedium,
                              )
                            ],
                          )),

                          //ACTIONS
                          DataCell(Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                iconSize: 25,
                                onPressed: () {
                                  showCustomDialog(context,
                                      barrierColor: Colors.white.withOpacity(0),
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Are you sure you want to delete this user?",
                                            style: textTheme.displayMedium,
                                          ),
                                          verticalSpace(),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              button(
                                                onPressed: () =>
                                                    Navigator.of(context).pop(),
                                                text: "Cancel",
                                                textStyle:
                                                    textTheme.displayMedium!,
                                              ).withBorder(
                                                context,
                                                borderColor: Colors.red,
                                                borderRadius: 20,
                                              ),
                                              horizontalSpace(),
                                              button(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  crController
                                                      .deleteUser(user.id)
                                                      .then(
                                                        (value) => crController
                                                            .users
                                                            .removeWhere(
                                                                (element) =>
                                                                    element
                                                                        .id ==
                                                                    user.id),
                                                      );
                                                },
                                                text: "OK",
                                                textStyle:
                                                    textTheme.displayMedium!,
                                              ).withBorder(
                                                context,
                                                borderRadius: 20,
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .primaryColor,
                                              ),
                                            ],
                                          )
                                        ],
                                      ));
                                },
                                icon: Icon(
                                  FontAwesomeIcons.trash,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              IconButton(
                                iconSize: 25,
                                onPressed: () {
                                  /* prController.setSelectedItem(item); */
                                  crController.setEditUser(user);
                                  adminUiController
                                      .changePageType(PageType.addCustomer());
                                },
                                icon: Icon(
                                  FontAwesomeIcons.pen,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          )),
                        ]);
                      }),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class TextShimmer extends StatelessWidget {
  const TextShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.white,
      child: Container(
        height: 10,
        width: 80,
        color: Colors.white,
      ),
    );
  }
}

extension WidgetExtension on Container {
  withBorderRadius(double radius) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(radius)),
          color: color,
        ),
        margin: margin,
        padding: padding,
        child: child,
      );
}
