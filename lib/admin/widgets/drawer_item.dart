import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pizza/admin/controller/admin_login_controller.dart';

import '../../../models/rbpoint.dart';
import '../controller/admin_ui_controller.dart';

class DrawerItem extends GetView<AdminUiController> {
  const DrawerItem({
    super.key,
    required this.textTheme,
    required this.imageIcon,
    required this.label,
    this.trailling,
    required this.isSelected,
    required this.onTap,
  });

  final TextTheme textTheme;
  final String label;
  final Widget? trailling;
  final bool isSelected;
  final String imageIcon;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final AdminLoginController alController = Get.find();
    final isLightTheme = alController.isLightTheme.value;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: controller.rbPoint.value!
                  .getOrElse(() => RBPoint.xl())
                  .map(
                      xl: (_) => 25,
                      desktop: (_) => 20,
                      tablet: (_) => 15,
                      mobile: (_) => 10),
            ),
            SvgPicture.asset(
              imageIcon,
              width: controller.rbPoint.value!
                  .getOrElse(() => RBPoint.xl())
                  .map(
                      xl: (_) => 25,
                      desktop: (_) => 20,
                      tablet: (_) => 15,
                      mobile: (_) => 10),
              height: controller.rbPoint.value!
                  .getOrElse(() => RBPoint.xl())
                  .map(
                      xl: (_) => 25,
                      desktop: (_) => 20,
                      tablet: (_) => 15,
                      mobile: (_) => 10),
              color: isSelected
                  ? Theme.of(context).iconTheme.color
                  : Colors.grey.shade800,
            ),
            SizedBox(
              width: controller.rbPoint.value!
                  .getOrElse(() => RBPoint.xl())
                  .map(
                      xl: (_) => 30,
                      desktop: (_) => 20,
                      tablet: (_) => 10,
                      mobile: (_) => 5),
            ),
            Expanded(
              child: Text(
                label,
                style: textTheme.displayLarge?.copyWith(
                  color: isSelected
                      ? Theme.of(context).iconTheme.color
                      : Colors.grey.shade600,
                  fontSize: controller.rbPoint.value!
                      .getOrElse(() => RBPoint.xl())
                      .map(
                          xl: (_) => 20,
                          desktop: (_) => 16,
                          tablet: (_) => 14,
                          mobile: (_) => 12),
                ),
              ),
            ),
            trailling ?? const SizedBox(),
            !(trailling == null)
                ? const SizedBox(
                    width: 20,
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
