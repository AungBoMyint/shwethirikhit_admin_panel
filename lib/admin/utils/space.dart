import 'package:flutter/material.dart';

///Default value is height: 25,
SizedBox verticalSpace({double? v}) => SizedBox(
      height: v ?? 25,
    );

///Default value is width: 25,
SizedBox horizontalSpace({double? v}) => SizedBox(
      width: v ?? 25,
    );
