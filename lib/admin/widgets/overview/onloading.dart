import 'package:flutter/material.dart';

Widget onLoading() => SizedBox(
      height: 50,
      width: 200,
      child: Center(
          child: SizedBox(width: 50, child: CircularProgressIndicator())),
    );
