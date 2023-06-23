import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../constant/data.dart';
import '../../../models/page_type.dart';
import '../../../models/rbpoint.dart';
import '../../../routes.dart';
import '../controller/admin_login_controller.dart';
import '../controller/admin_ui_controller.dart';
import '../controller/customer_related_controller.dart';

class BodyActionBar extends GetView<AdminUiController> {
  const BodyActionBar({
    super.key,
    required this.horizontalSpace,
    required this.girlNetworkImage,
    required this.textTheme,
  });

  final SizedBox Function({double? v}) horizontalSpace;
  final String girlNetworkImage;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    final AdminLoginController alController = Get.find();
    return Obx(() {
      final currentUser = alController.currentUser.value;
      return Container(
        padding: const EdgeInsets.only(
          top: 10,
          bottom: 10,
        ),
        color: Theme.of(context).cardTheme.color,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          /* mainAxisAlignment: MainAxisAlignment.end, */
          children: [
            controller.rbPoint.value!.fold(
              (l) => const SizedBox(),
              (r) => r.map(
                xl: (_) => const Expanded(child: SizedBox()),
                desktop: (_) => const Expanded(child: SizedBox()),
                tablet: (_) => IconButton(
                  onPressed: () =>
                      controller.scaffoldKey.currentState?.openDrawer(),
                  icon: const Icon(
                    FontAwesomeIcons.gripLines,
                    size: 15,
                    color: Colors.black,
                  ),
                ),
                mobile: (_) => IconButton(
                  onPressed: () =>
                      controller.scaffoldKey.currentState?.openDrawer(),
                  icon: const Icon(
                    FontAwesomeIcons.gripLines,
                    size: 15,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            controller.rbPoint.value!.fold(
              (l) => const SizedBox(),
              (r) => r.map(
                xl: (_) => const SizedBox(),
                desktop: (_) => const SizedBox(),
                tablet: (_) => const Expanded(child: SizedBox()),
                mobile: (_) => const Expanded(child: SizedBox()),
              ),
            ),
            //Search Icon
            Obx(() {
              final isLightTheme = alController.isLightTheme.value;
              return IconButton(
                onPressed: () => alController.changeTheme(),
                icon: Icon(
                  isLightTheme ? FontAwesomeIcons.moon : FontAwesomeIcons.sun,
                  size: controller.rbPoint.value!
                      .getOrElse(() => RBPoint.xl())
                      .map(
                          xl: (_) => 25,
                          desktop: (_) => 20,
                          tablet: (_) => 15,
                          mobile: (_) => 10),
                  color: isLightTheme ? Colors.black : Colors.white,
                ),
              );
            }),
            horizontalSpace(v: 15),
            //Ball Notify Icon
            IconButton(
              onPressed: () {},
              icon: Icon(
                FontAwesomeIcons.bell,
                size: controller.rbPoint.value!
                    .getOrElse(() => RBPoint.xl())
                    .map(
                        xl: (_) => 25,
                        desktop: (_) => 20,
                        tablet: (_) => 15,
                        mobile: (_) => 10),
                color: Theme.of(context).iconTheme.color,
              ),
            ),
            horizontalSpace(v: 15),
            GestureDetector(
              onTapDown: (details) {
                showPopupMenu(context, details.globalPosition);
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //CircleAvatar
                  CircleAvatar(
                    radius: controller.rbPoint.value!
                        .getOrElse(() => RBPoint.xl())
                        .map(
                            xl: (_) => 25,
                            desktop: (_) => 20,
                            tablet: (_) => 15,
                            mobile: (_) => 10),
                    backgroundImage: NetworkImage(
                      currentUser?.avatar ?? emptyUserImage,
                    ),
                  ),

                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    currentUser?.name ?? "",
                    style: textTheme.headlineMedium?.copyWith(
                      fontSize: controller.rbPoint.value!
                          .getOrElse(() => RBPoint.xl())
                          .map(
                              xl: (_) => 20,
                              desktop: (_) => 18,
                              tablet: (_) => 16,
                              mobile: (_) => 14),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Icon(
                    FontAwesomeIcons.chevronDown,
                    size: controller.rbPoint.value!
                        .getOrElse(() => RBPoint.xl())
                        .map(
                            xl: (_) => 18,
                            desktop: (_) => 16,
                            tablet: (_) => 14,
                            mobile: (_) => 12),
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
            horizontalSpace(v: 20),
          ],
        ),
      );
    });
  }
}

void showPopupMenu(BuildContext context, Offset position) async {
  const girlNetworkImage =
      "https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80";
  final AdminUiController adminUiController = Get.find();
  final AdminLoginController alController = Get.find();
  final CustomerRelatedController crController = Get.find();
  final textTheme = Theme.of(context).textTheme;
  final RenderBox overlay =
      Overlay.of(context).context.findRenderObject() as RenderBox;
  final RenderBox popupButton = context.findRenderObject() as RenderBox;
  final Offset targetPosition =
      popupButton.localToGlobal(Offset.zero, ancestor: overlay);
  final result = await showMenu(
    color: Theme.of(context).cardTheme.color,
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
      //Avatar Name Role
      PopupMenuItem(
        onTap: () {},
        value: 'avatar',
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(
              alController.currentUser.value?.avatar ?? emptyUserImage,
            ),
          ),
          title: Text(
            alController.currentUser.value?.name ?? "",
            style: textTheme.displayMedium?.copyWith(
              color: alController.isLightTheme.value
                  ? Colors.grey
                  : Colors.grey.shade100,
            ),
          ),
          subtitle: Text("Admin",
              style: textTheme.displayMedium?.copyWith(
                color: alController.isLightTheme.value
                    ? Colors.grey.shade800
                    : Colors.grey.shade100,
              )),
        ),
      ),

      //Profile
      PopupMenuItem(
        onTap: () {
          crController.setEditUser(alController.currentUser.value);
          adminUiController.changePageType(const PageType.updateProfile());
        },
        value: 'profile',
        child: ListTile(
            leading: Icon(
              FontAwesomeIcons.user,
              color: Colors.grey,
              size: 20,
            ),
            title: Text(
              "Profile",
              style: textTheme.displayMedium?.copyWith(
                color: alController.isLightTheme.value
                    ? Colors.grey.shade800
                    : Colors.grey.shade100,
              ),
            )),
      ),
      //Sign Out
      PopupMenuItem(
        onTap: () => alController.signOut(),
        value: 'sign out',
        child: ListTile(
            leading: Icon(
              FontAwesomeIcons.powerOff,
              color: Colors.grey,
              size: 20,
            ),
            title: Text(
              "Sign Out",
              style: textTheme.displayMedium?.copyWith(
                color: Colors.grey,
              ),
            )),
      ),
    ],
  );
}
