import 'dart:math';

import 'package:uuid/uuid.dart';
import '../../models/customer_filter.dart';
import '../../models/customer_filter_type.dart';

const List<CustomerFilter> customerFilters = [
  CustomerFilter(
    cft: CustomerFilterType.admin(),
    title: "Admin",
  ),
  CustomerFilter(
    cft: CustomerFilterType.customer(),
    title: "Customer",
  ),
  CustomerFilter(
    cft: CustomerFilterType.active(),
    title: "Active",
  ),
  CustomerFilter(
    cft: CustomerFilterType.inactive(),
    title: "Inactive",
  ),
];
