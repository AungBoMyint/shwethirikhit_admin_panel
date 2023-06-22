import 'package:get/get.dart';
import 'package:pizza/admin/controller/therapy_controller.dart';
import 'package:pizza/admin/controller/vlog_controller.dart';

import '../controller/admin_ui_controller.dart';
import '../controller/customer_related_controller.dart';
import '../controller/news_controller.dart';

class AdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AdminUiController());
    Get.put(CustomerRelatedController());
    Get.put(NewsController());
    Get.put(VlogController());
    Get.put(TherapyController());
  }
}
