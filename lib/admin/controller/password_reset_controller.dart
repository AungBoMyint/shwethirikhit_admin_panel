import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PasswordResetController extends GetxController {
  var isFirstTimePressed = false.obs;
  TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? validator(String? v, String key) {
    if (v == null || v.isEmpty) {
      return "$key must be filled";
    } else {
      return null;
    }
  }

  Future<void> resetPassword() async {
    isFirstTimePressed.value = true;
    if (formKey.currentState?.validate() == true) {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(
          email: emailController.text.trim(),
        );
        Get.snackbar(
            "", 'Password reset email sent. Please check your email inbox.');
      } catch (e) {
        Get.snackbar("", "$e");
      }
    }
  }
}
