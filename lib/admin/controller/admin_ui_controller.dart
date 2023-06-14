import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/customer_filter_type.dart';
import '../../models/page_type.dart';
import '../../models/rbpoint.dart';

class AdminUiController extends GetxController {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  Rxn<Either<None, RBPoint>> rbPoint =
      Rxn<Either<None, RBPoint>>(right(const RBPoint.xl()));
  Rxn<CustomerFilterType> customerFilterType = Rxn<CustomerFilterType>(null);
  Rxn<Either<None, PageType>> pageType =
      Rxn<Either<None, PageType>>(right(const PageType.initial()));

  void changePageType(PageType v) => pageType.value = right(v);

  var dataTableSelectAll = false.obs;
  void setRBPoint(RBPoint rb) => rbPoint.value = right(rb);
  void setCustomerFilterType(CustomerFilterType? cft) =>
      customerFilterType.value = cft;
  void setDataTableSelectAll() =>
      dataTableSelectAll.value = !dataTableSelectAll.value;
}
