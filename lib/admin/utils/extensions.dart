import 'package:flutter/material.dart';

extension button on ElevatedButton {
  ElevatedButtonTheme withColor(Color color, {OutlinedBorder? shape}) {
    return ElevatedButtonTheme(
      data: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: shape ??
              const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    10,
                  ),
                ),
              ),
        ),
      ),
      child: this,
    );
  }
}
