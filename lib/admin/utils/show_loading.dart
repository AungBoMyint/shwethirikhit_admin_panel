import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

void showCustomDialog(
  BuildContext context, {
  required Widget child,
  Color? barrierColor,
  bool isDimissible = false,
  required double width,
}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: isDimissible,
    /*  barrierColor: barrierColor ?? const Color(0x80000000), */
    pageBuilder: (context, __, ___) {
      return Center(
          child: SizedBox(
              width: width,
              child: Card(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  children: [child],
                  shrinkWrap: true,
                ),
              ))));
    },
  );
}

showLoading(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.white.withOpacity(0),
    pageBuilder: (context, __, ___) {
      return Center(
          child: SizedBox(
        height: 50,
        width: 100,
        child: Card(
          child: Center(
            child: LoadingAnimationWidget.flickr(
              leftDotColor: const Color(0xFF1A1A3F),
              rightDotColor: const Color.fromRGBO(244, 167, 41, 1),
              size: 50,
            ),
          ),
        ),
      ));
    },
  );
}

hideLoading(BuildContext context) {
  Navigator.of(context).pop();
}
