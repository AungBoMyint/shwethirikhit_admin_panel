import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../models/rbpoint.dart';
import '../controller/admin_ui_controller.dart';

class DataColumnRowContainer extends GetView<AdminUiController> {
  const DataColumnRowContainer({
    super.key,
    required this.horizontalSpace,
    required this.verticalSpace,
    required this.topImageIcon,
    required this.topData,
    required this.titleData,
    required this.subTitleData,
    this.containerBackgroundColor,
    this.columnCrossAxisAlignment,
    this.rowMainAxisAlignment,
    this.border,
    this.titleLeftPadding,
  });

  final SizedBox Function({double? v}) horizontalSpace;
  final SizedBox Function({double? v}) verticalSpace;
  final String topImageIcon;
  final String topData;
  final String titleData;
  final String subTitleData;
  final Color? containerBackgroundColor;
  final CrossAxisAlignment? columnCrossAxisAlignment;
  final MainAxisAlignment? rowMainAxisAlignment;
  final BoxBorder? border;
  final double? titleLeftPadding;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final dataTextStyle = GoogleFonts.roboto(
      fontSize: controller.rbPoint.value!.fold(
        (l) => 0,
        (r) => r.map(
          xl: (_) => 20,
          desktop: (_) => 18,
          tablet: (_) => 16,
          mobile: (_) => 14,
        ),
      ),
      color: Theme.of(context).textTheme.displayLarge?.color,
      fontWeight: FontWeight.bold,
    );
    log("RBPoint: ${controller.rbPoint.value!.getOrElse(() => const RBPoint.mobile())}");

    return SizedBox(
      width: 250,
      height: 200,
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
            side: BorderSide(
              color: Colors.grey,
            )),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Icon
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.black,
                    child: Center(
                      child: SvgPicture.asset(
                        topImageIcon,
                        width: controller.rbPoint.value!.fold(
                          (l) => 0,
                          (r) => r.map(
                            xl: (_) => 18,
                            desktop: (_) => 14,
                            tablet: (_) => 12,
                            mobile: (_) => 10,
                          ),
                        ),
                        height: controller.rbPoint.value!.fold(
                          (l) => 0,
                          (r) => r.map(
                            xl: (_) => 18,
                            desktop: (_) => 14,
                            tablet: (_) => 12,
                            mobile: (_) => 10,
                          ),
                        ),
                        color: Colors.white,
                      ),
                    ),
                  ),
                  horizontalSpace(
                    v: controller.rbPoint.value!.fold(
                      (l) => 0,
                      (r) => r.map(
                        xl: (_) => 20,
                        desktop: (_) => 16,
                        tablet: (_) => 14,
                        mobile: (_) => 12,
                      ),
                    ),
                  ),
                  //Data
                  Expanded(
                    child: Text(
                      topData,
                      style: textTheme.displayLarge?.copyWith(
                        fontSize: controller.rbPoint.value!
                            .getOrElse(() => RBPoint.xl())
                            .map(
                                xl: (_) => 16,
                                desktop: (_) => 14,
                                tablet: (_) => 12,
                                mobile: (_) => 10),
                      ),
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
              verticalSpace(
                v: controller.rbPoint.value!.fold(
                  (l) => 0,
                  (r) => r.map(
                    xl: (_) => 12,
                    desktop: (_) => 10,
                    tablet: (_) => 8,
                    mobile: (_) => 6,
                  ),
                ),
              ),
              //Container Title
              Padding(
                padding: EdgeInsets.only(left: titleLeftPadding ?? 0),
                child: Text(
                  titleData,
                  style: dataTextStyle,
                ),
              ),
              verticalSpace(v: 4),
              //Container SubTitle

              Text(
                subTitleData,
                style: dataTextStyle.copyWith(
                  fontWeight: FontWeight.normal,
                  color: Colors.grey,
                  fontSize: controller.rbPoint.value!.fold(
                    (l) => 0,
                    (r) => r.map(
                      xl: (_) => 12,
                      desktop: (_) => 10,
                      tablet: (_) => 8,
                      mobile: (_) => 6,
                    ),
                  ),
                ),
              ),
              /*  verticalSpace,
                    Divider(), */
            ],
          ),
        ),
      ),
    );
  }
}
