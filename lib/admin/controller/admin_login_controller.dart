import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../../constant/data.dart';
import '../../core/firebase_reference.dart';
import '../../models/auth_user.dart';
import '../../routes.dart';
import '../../theme/app_theme.dart';
import '../utils/func.dart';
import '../utils/show_loading.dart';

class AdminLoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var isObscure = true.obs;
  var isFirstTimePressed = false.obs;
  var rememberMe = false.obs;
  final box = Hive.box(loginBox);
  Rxn<AuthUser> currentUser = Rxn<AuthUser>(null);
  var isLightTheme = true.obs;

  void changeTheme() {
    isLightTheme.value = !isLightTheme.value;
    box.put(themeKey, isLightTheme.value);

    Get.changeTheme(
        isLightTheme.value ? AppTheme.lightTheme() : AppTheme.darkTheme());
  }

  ThemeData getTheme() {
    if (isLightTheme.value) {
      return AppTheme.lightTheme();
    } else {
      return AppTheme.darkTheme();
    }
  }

  void changeRememberMe() => rememberMe.value = !rememberMe.value;
  void changeObscure() => isObscure.value = !isObscure.value;
  String? validator(String? v, String key) {
    if (v == null || v.isEmpty) {
      return "$key must be filled";
    } else {
      return null;
    }
  }

  Future<void> signIn() async {
    if (!isFirstTimePressed.value) isFirstTimePressed.value = true;
    if (formKey.currentState?.validate() == true) {
      if (rememberMe.value) {
        //user want remember,so need to store
        box.put(isRememberKey, true);
        box.put(emailKey, emailController.text);
        box.put(passwordKey, passwordController.text);
      } else {
        box.put(isRememberKey, false);
      }
      //sign in
      showLoading(Get.context!);
      await Future.delayed(Duration.zero);
      signinWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      ).then((value) async {
        userCollectionReference()
            .where("email", isEqualTo: emailController.text)
            .get()
            .then((userSnap) {
          currentUser.value = userSnap.docs.first.data();
          debugPrint(
              "***************Current User is ${currentUser.value}********");
          hideLoading(Get.context!);
          if (currentUser.value!.status! > 0) {
            Get.toNamed(adminMainRoute); //we do only if user is admin
            box.put(isAuthenticatedKey, true);
            box.put(userIdKey, currentUser.value!.id);
          }
        });
      }).catchError((v) {
        hideLoading(Get.context!);
        debugPrint("************Error register email password: $v");
        errorSnack("Error register email password");
      });
    }
  }

  Future<void> signinWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      hideLoading(Get.context!);
      if (e.code == "user-not-found") {
        createUserWithEmail(email, password);
      }
      if (e.code == 'weak-password') {
        errorSnack('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        errorSnack('The account already exists for that email.');
      }
    } catch (e) {
      errorSnack("$e");
    }
  }

  Future<void> createUserWithEmail(String email, String password) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      currentUser.value = AuthUser(
        id: Uuid().v1(),
        name: "Admin",
        email: email,
        password: password,
        status: 1,
        isActive: true,
      );
      await userCollectionReference()
          .doc(currentUser.value!.id)
          .set(currentUser.value!);
      if (currentUser.value!.status! > 0) {
        Get.toNamed(adminMainRoute); //we do only if user is admin
        box.put(isAuthenticatedKey, true);
        box.put(userIdKey, currentUser.value!.id);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> signOut() async {
    FirebaseAuth.instance.signOut().then((value) {
      box.put(isAuthenticatedKey, false);
      //Get back to login screen
      Get.offAllNamed(adminLoginRoute);
    });
  }

  @override
  void onInit() {
    isLightTheme.value = box.get(themeKey, defaultValue: true);
    final isAuthenticated =
        box.get(isAuthenticatedKey, defaultValue: false) as bool;
    final userId = box.get(userIdKey, defaultValue: "") as String;
    if (isAuthenticated) {
      debugPrint("***************IsAuthenticated: $isAuthenticated");
      debugPrint("***************UserId: $userId");
      //is Already authenticated,we retrieve the user
      retrieveCurrentUser(userId);
    }
    final isRemember = box.get(isRememberKey, defaultValue: false) as bool;
    rememberMe.value = isRemember;
    final email = box.get(emailKey, defaultValue: "") as String;
    final pass = box.get(passwordKey, defaultValue: "") as String;
    if (isRemember) {
      emailController.text = email;
      passwordController.text = pass;
    }
    super.onInit();
  }

  Future<void> retrieveCurrentUser(String userId) async {
    try {
      final userSnapshot = await userDocumentReference(userId).get();
      currentUser.value = userSnapshot.data();
      log("*********Current User: ${currentUser.value?.toJson()}");
    } catch (e) {
      debugPrint("******Firebase Error: $e");
    }
  }
}
