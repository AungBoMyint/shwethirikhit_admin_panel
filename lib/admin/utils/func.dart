import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pizza/admin/utils/show_loading.dart';
import 'package:pizza/constant/data.dart';
import 'dart:math';
import 'dart:developer' as d;
import '../../models/rbpoint.dart';

RBPoint getRBPoint(double width) {
  if (width <= kMobileBreakpoint) {
    return const RBPoint.mobile();
  } else if (width <= kTabletBreakpoint) {
    return const RBPoint.tablet();
  } else if (width <= kDesktopBreakpoint) {
    return const RBPoint.desktop();
  } else {
    return const RBPoint.xl();
  }
}

String formatNumber(double number) {
  if (number < 1000) {
    return number.toString();
  } else if (number < 1000000) {
    double num = number / 1000.0;
    return '${num.toStringAsFixed(num.truncateToDouble() == num ? 0 : 1)}k';
  } else {
    double num = number / 1000000.0;
    return '${num.toStringAsFixed(num.truncateToDouble() == num ? 0 : 1)}m';
  }
}

String formatCurrency(double amount) {
  var formatter =
      NumberFormat.currency(locale: 'en_US', symbol: '\$', decimalDigits: 2);

  return formatter.format(amount);
}

String formatNumberComma(int number) {
  var formatter = NumberFormat('#,###');
  return formatter.format(number);
}

DateTime randomDateTimeInRange(DateTime start, DateTime end) {
  final random = Random();
  int range = end.difference(start).inSeconds;
  int seconds = (start.second + random.nextInt(range)) as int;
  int minutes = (start.minute + random.nextInt(range)) as int;
  int hours = (start.hour + random.nextInt(range)) as int;
  int days = (start.day + random.nextInt(range)) as int;
  int months = (start.month + random.nextInt(range)) as int;
  int years = (start.year + random.nextInt(range)) as int;

  return DateTime(years, months, days, hours, minutes, seconds);
}

int getMonthNumber(String monthName) {
  switch (monthName.toLowerCase()) {
    case 'january':
      return 0;
    case 'february':
      return 1;
    case 'march':
      return 2;
    case 'april':
      return 3;
    case 'may':
      return 4;
    case 'june':
      return 5;
    case 'july':
      return 6;
    case 'august':
      return 7;
    case 'september':
      return 8;
    case 'october':
      return 9;
    case 'november':
      return 10;
    case 'december':
      return 11;
    default:
      throw ArgumentError('Invalid month name: $monthName');
  }
}

void errorSnack(String message) => Get.snackbar(
      "",
      message,
      colorText: Colors.white,
      backgroundColor: Colors.red,
      snackPosition: SnackPosition.BOTTOM,
    );
String? validateEmail(String? email) {
  // Regular expression pattern for email validation
  final RegExp emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  if (email == null || email.isEmpty) {
    // Email is null or empty
    return "Email must be filled.";
  } else if (!emailRegExp.hasMatch(email)) {
    // Email does not match the regular expression pattern
    return "Email is invalid.";
  }
  // Email is valid
  return null;
}

String? stringValidator(String key, String? value) {
  if (value == null || value.isEmpty) {
    return "$key is required";
  } else {
    return null;
  }
}

String? integerValidator(String key, String? value) {
  if (value == null || value.isEmpty) {
    return "$key is required";
  } else if (int.tryParse(value) == null) {
    return "$key must be integer.(example=> '0')";
  } else {
    return null;
  }
}

Future<void> upload<T>(
  DocumentReference<T> reference,
  T object,
  String success,
  String error,
  void Function() successCallBack,
) async {
  showLoading(Get.context!);
  try {
    await reference.set(object);
    hideLoading(Get.context!);
    successSnap(success);
    if (!Get.isSnackbarOpen) {
      successSnap(success);
    }
    successCallBack();
  } catch (e) {
    hideLoading(Get.context!);
    if (!Get.isSnackbarOpen) {
      errorSnap(error);
    }
  }
}

Future<void> edit<T>(
  DocumentReference<T> reference,
  T object,
  String success,
  String error,
  void Function() successCallBack,
) async {
  showLoading(Get.context!);
  try {
    await reference.set(object);
    hideLoading(Get.context!);
    successSnap(success);
    if (!Get.isSnackbarOpen) {
      successSnap(success);
    }
    successCallBack();
  } catch (e) {
    hideLoading(Get.context!);
    if (!Get.isSnackbarOpen) {
      errorSnap(error);
    }
  }
}

Future<void> delete<T>(
    DocumentReference<T> reference, String success, String error) async {
  showLoading(Get.context!);
  try {
    await reference.delete();
    hideLoading(Get.context!);
    if (!Get.isSnackbarOpen) {
      successSnap(success);
    }
  } catch (e) {
    hideLoading(Get.context!);
    if (!Get.isSnackbarOpen) {
      errorSnap(error);
    }
  }
}

Future<void> deleteItems<T>(
    List<String> idList, CollectionReference<T> reference) async {
  if (idList.isNotEmpty) {
    await deleteItemsWithBatch(idList, reference);
  }
}

Future<void> deleteItemsWithBatch<T>(
    List<String> idList, CollectionReference<T> reference) async {
  final batch = FirebaseFirestore.instance.batch();

  try {
    showLoading(Get.context!);
    Future.delayed(Duration.zero);
    for (var id in idList) {
      batch.delete(reference.doc(id));
    }
    await batch.commit();
    hideLoading(Get.context!);
  } catch (error) {
    hideLoading(Get.context!);
    d.log("Item Document Delete Error: $error");
  }
}
