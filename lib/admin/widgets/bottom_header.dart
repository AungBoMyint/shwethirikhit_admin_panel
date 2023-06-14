import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../constant/icon.dart';
import '../../../models/rbpoint.dart';
import '../controller/admin_ui_controller.dart';

class BottomHeader extends GetView<AdminUiController> {
  const BottomHeader({
    super.key,
    required this.textTheme,
  });

  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
          width: controller.rbPoint.value!.getOrElse(() => RBPoint.xl()).map(
              xl: (_) => 25,
              desktop: (_) => 20,
              tablet: (_) => 15,
              mobile: (_) => 10),
        ),
        SvgPicture.asset(
          AdminIcon.halfCircle,
          width: controller.rbPoint.value!.getOrElse(() => RBPoint.xl()).map(
              xl: (_) => 25,
              desktop: (_) => 20,
              tablet: (_) => 15,
              mobile: (_) => 10),
          height: controller.rbPoint.value!.getOrElse(() => RBPoint.xl()).map(
              xl: (_) => 25,
              desktop: (_) => 20,
              tablet: (_) => 15,
              mobile: (_) => 10),
        ),
        SizedBox(
          width: controller.rbPoint.value!.getOrElse(() => RBPoint.xl()).map(
              xl: (_) => 30,
              desktop: (_) => 20,
              tablet: (_) => 10,
              mobile: (_) => 5),
        ),
        Expanded(
          child: Text(
            "Delivery Boy Manager",
            style: textTheme.displayLarge?.copyWith(
                fontSize: controller.rbPoint.value!
                    .getOrElse(() => RBPoint.xl())
                    .map(
                        xl: (_) => 20,
                        desktop: (_) => 16,
                        tablet: (_) => 14,
                        mobile: (_) => 12)),
          ),
        ),
        const SizedBox(),
      ],
    );
  }
}
