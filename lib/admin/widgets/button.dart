import 'package:flutter/material.dart';

ElevatedButton button({
  required String text,
  required TextStyle textStyle,
  required void Function()? onPressed,
  double? contentPadding,
}) {
  return ElevatedButton(
    onPressed: onPressed,
    child: Padding(
      padding: EdgeInsets.all(contentPadding ?? 0),
      child: Text(
        text,
        style: textStyle,
      ),
    ),
  );
}

extension ElevatedExtendion on ElevatedButton {
  withBorder(
    BuildContext context, {
    Color? borderColor,
    double? borderRadius,
    Color? backgroundColor,
  }) =>
      ElevatedButtonTheme(
        data: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? Colors.white,
            shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: borderColor ?? (backgroundColor ?? Colors.white),
                ),
                borderRadius:
                    BorderRadius.all(Radius.circular(borderRadius ?? 0))),
          ),
        ),
        child: this,
      );
}
