import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../constant/icon.dart';
import '../../../models/rbpoint.dart';
import '../controller/admin_login_controller.dart';
import '../controller/admin_ui_controller.dart';

class DrawerHeader extends GetView<AdminUiController> {
  const DrawerHeader({
    super.key,
    required this.textTheme,
  });

  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    final AdminLoginController alController = Get.find();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          width: 25,
        ),
        SvgPicture.asset(
          AdminIcon.nuclear,
          width: controller.rbPoint.value!.getOrElse(() => RBPoint.xl()).map(
              xl: (_) => 30,
              desktop: (_) => 25,
              tablet: (_) => 23,
              mobile: (_) => 22),
          height: controller.rbPoint.value!.getOrElse(() => RBPoint.xl()).map(
              xl: (_) => 30,
              desktop: (_) => 25,
              tablet: (_) => 23,
              mobile: (_) => 22),
          color: Theme.of(context).iconTheme.color,
        ),
        SizedBox(
          width: controller.rbPoint.value!.getOrElse(() => RBPoint.xl()).map(
              xl: (_) => 45,
              desktop: (_) => 35,
              tablet: (_) => 25,
              mobile: (_) => 15),
        ),
        Expanded(
          child: Text(
            "Shwe Thiri Khit",
            style: textTheme.displayMedium?.copyWith(
              fontSize: controller.rbPoint.value!
                  .getOrElse(() => RBPoint.xl())
                  .map(
                      xl: (_) => 24,
                      desktop: (_) => 18,
                      tablet: (_) => 16,
                      mobile: (_) => 13),
            ),
          ),
        ),
        const SizedBox(),
      ],
    );
  }
}
