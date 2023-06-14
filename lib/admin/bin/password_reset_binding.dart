import 'package:get/get.dart';

import '../controller/password_reset_controller.dart';

class PasswordResetBining extends Bindings {
  @override
  void dependencies() {
    Get.put(PasswordResetController());
  }
}
