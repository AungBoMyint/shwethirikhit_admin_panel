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

const List<String> ages = [
  "Under 18",
  "Between 18 and 24",
  "Between 25 and 34",
  "Between 35 and 44",
  "Between 45 and 54",
  "Above 55",
];

const List<String> areas = [
  "Creating the life I desire",
  "Becoming more joyful",
  "Improving Self-Esteem",
  "Being more successful",
  "Eliminating Negative SelfTalk",
  "Healing Inner Child",
  "Building Good Habits",
];

const emptyProfile =
    "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png";
