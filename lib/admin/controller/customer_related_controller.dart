import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' hide log;
/* import 'dart:html' as html;
 */
import 'package:get/get_navigation/src/extension_navigation.dart' hide back;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pizza/models/customer_filter_type.dart';
import 'package:uuid/uuid.dart';

import '../../constant/data.dart';
import '../../core/firebase_reference.dart';
import '../../models/auth_user.dart';
import '../../models/customer_role.dart';
import '../../models/page_type.dart';
import '../../service/database.dart';
import '../utils/func.dart';
import '../utils/show_loading.dart';
import 'admin_login_controller.dart';
import 'admin_ui_controller.dart';

class CustomerRelatedController extends GetxController {
  final AdminLoginController alController = Get.find();
  final AdminUiController adminUiController = Get.find();
  Rxn<Query<AuthUser>> userQuery =
      Rxn<Query<AuthUser>>(userCollectionReference().orderBy("name"));
  final ScrollController scrollController =
      ScrollController(initialScrollOffset: 0);
  TextEditingController searchController = TextEditingController();
  Rxn<FirestoreQueryBuilderSnapshot<AuthUser>> snapshot =
      Rxn<FirestoreQueryBuilderSnapshot<AuthUser>>();
  Rxn<AuthUser> editUser = Rxn<AuthUser>(null);
  void startSearch() {
    if (searchController.text.isNotEmpty) {
      userQuery.value = userCollectionReference().orderBy('name').startAt(
          [searchController.text]).endAt([searchController.text + '\uf8ff']);
    } else {
      userQuery.value = userCollectionReference().orderBy("name");
    }
  }

  void setSnapshot(FirestoreQueryBuilderSnapshot<AuthUser> v) =>
      snapshot.value = v;
  void pickCSVFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );
    if (!(result == null)) {
      try {
        /*   //This is for web
        final fileBytes = result.files.first.bytes!;

        final contents = utf8.decode(fileBytes); */
        //This is for another platform
        final contents = await File(result.files.single.path!).readAsString();
        final list = contents.split("\n"); //split row
        final dataList = list.sublist(1); //becuase o is title row
        var csvData = dataList;
        csvData.remove(csvData.last);
        var users = <AuthUser>[];

        for (final row in csvData) {
          // Split the modified string by commas
          List<String> parts = row.split(',');

          String id = parts[0];
          String name = parts[1];
          String phone = parts[2];
          String location = parts[3];
          double lat = (int.tryParse(parts[4]) ?? 0) + .0;
          double long = (int.tryParse(parts[5]) ?? 0) + .0;
          String avatar = parts[6];
          int status = int.tryParse(parts[7]) ?? 0;
          List<bool> memicActive = [true, false];

          var user = AuthUser(
            id: id,
            name: name,
            phone: phone,
            location: location,
            lat: lat,
            long: long,
            avatar: avatar,
            status: status,
            isActive: memicActive[Random().nextInt(2)],
          );
          users.add(user);
        }
        users.removeRange(101, users.length);
        debugPrint("*****User List: ${users.length}");
        if (users.isNotEmpty) {
          final batch = FirebaseFirestore.instance.batch();

          try {
            showLoading(Get.context!);
            for (var user in users) {
              batch.set(
                userDocumentReference(user.id),
                user,
              );
              /*  await itemDocumentReference(item.id).set(item); */
            }
            await batch.commit();
            hideLoading(Get.context!);
          } catch (error) {
            hideLoading(Get.context!);
            log("User Document Write Error: $error");
          }
        }
      } on FormatException catch (e) {
        if (Get.isDialogOpen!) {
          hideLoading(Get.context!);
        }
        log("CSV File Pick Error: ${e.message}\n ${e.source}");
      }
    }
  }

  //Example, to delete
  Future<void> makeExportingCSV() async {
    showLoading(Get.context!);
    final data = await userCollectionReference().get();
    final users = data.docs.map((e) => e.data()).toList();
    hideLoading(Get.context!);
    if (users.isNotEmpty) {
      exportCSV(users);
      log("Exporting...............");
    } else {
      log("Data is Empty...");
    }
  }

  void exportCSV(List<AuthUser> users) {
    List<List<dynamic>> rows = [];

    // Add header row
    rows.add(
        ['id', 'name', 'phone', 'location', 'lat', 'long', 'avatar', 'status']);

    // Add data row
    for (var user in users) {
      List<dynamic> dataRow = [
        user.id,
        user.name,
        user.phone,
        user.location,
        user.lat,
        user.long,
        user.avatar,
        user.status,
      ];
      rows.add(dataRow);
    }
    /* if (rows.length > 1) {
      downloadCsv(rows);
    } */
  }

  /*  void downloadCsv(List<List<dynamic>> csvData) {
    String csvString = const ListToCsvConverter().convert(csvData);

    // Create blob object from CSV data
    final blob = html.Blob([csvString], 'text/csv');

    // Create URL for download link
    final url = html.Url.createObjectUrlFromBlob(blob);

    // Create download link element
    final link = html.AnchorElement(href: url)
      ..setAttribute('download', 'data.csv')
      ..text = 'Download CSV';

    // Append link element to DOM and click it to initiate download
    html.document.body!.append(link);
    link.click();

    // Cleanup URL object
    html.Url.revokeObjectUrl(url);
  }
 */

  Future<QuerySnapshot<AuthUser>> getTotalUsers() =>
      userCollectionReference().get();
  Future<QuerySnapshot<AuthUser>> getActiveUsers() =>
      userCollectionReference().where("isActive", isEqualTo: true).get();
  @override
  void onInit() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (!(snapshot.value == null) && snapshot.value!.hasMore) {
          snapshot.value!.fetchMore();
        }
      }
    });
    ever(adminUiController.customerFilterType, changeUserOrder);
    super.onInit();
  }

  changeUserOrder(CustomerFilterType? cft) {
    if (cft == CustomerFilterType.initial()) {
      userQuery.value = userCollectionReference().orderBy("name");
    } else if (cft == CustomerFilterType.customer()) {
      userQuery.value = userCollectionReference()
          .where("status", isEqualTo: 0)
          .orderBy("name");
    } else if (cft == CustomerFilterType.admin()) {
      userQuery.value = userCollectionReference()
          .where("status", isEqualTo: 1)
          .orderBy("name");
    } else if (cft == CustomerFilterType.active()) {
      userQuery.value = userCollectionReference()
          .where("isActive", isEqualTo: true)
          .orderBy("name");
    } else if (cft == CustomerFilterType.inactive()) {
      userQuery.value = userCollectionReference()
          .where("isActive", isEqualTo: false)
          .orderBy("name");
    } else {
      userQuery.value = userCollectionReference().orderBy("name");
    }
  }

  //---------------------For Adding Customer-----------------
  var isFileImage = true.obs;
  var pickedImage = "".obs;
  var pickedImageError = "".obs;

  final Database _database = Database();
  final ImagePicker _imagePicker = ImagePicker();
  Rxn<Role> role = Rxn<Role>(null);
  var roleError = "".obs;
  final GlobalKey<FormState> form = GlobalKey();
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  void setEditUser(AuthUser? user) {
    reset();
    if (user == null) {
      editUser.value = null;
    } else {
      editUser.value = user;
      //Make initialization
      userNameController.text = user.name;
      emailController.text = user.email ?? '';
      passwordController.text = user.password ?? "";
      locationController.text = user.location ?? '';
      role.value = user.status == 0
          ? Role.customer
          : user.status == 1
              ? Role.admin
              : Role.nothing;
      pickedImage.value = user.avatar ?? '';
    }
  }

  void reset() {
    isFileImage.value = true;
    pickedImage.value = "";
    pickedImageError.value = "";
    userNameController.clear();
    emailController.clear();
    passwordController.clear();
    locationController.clear();
    role.value = null;
    roleError.value = "";
  }

  void changeRole(Role r) {
    role.value = r;
    roleError.value = "";
  }

  Future<void> pickImage() async {
    try {
      final XFile? _file =
          await _imagePicker.pickImage(source: ImageSource.gallery);
      if (!(_file == null)) {
        pickedImage.value = _file.path;
        pickedImageError.value = "";
        isFileImage.value = true;
      }
    } catch (e) {
      print("pickImage error $e");
    }
  }

  String? validator(String? data, String key) =>
      data?.isEmpty == true ? '$key is required.' : null;
  bool checkPickImage() {
    if (pickedImage.value.isNotEmpty) {
      pickedImageError.value = "";
      return true;
    } else {
      pickedImageError.value = "Image must be picked.";
      return false;
    }
  }

  bool checkRole() {
    if (role.value == null) {
      roleError.value = "User Role must be selected at least one";
      log("Role Error: ${roleError.value}");
      return false;
    } else {
      roleError.value = "";
      return true;
    }
  }

  Future<void> addUser() async {
    final checkImage = checkPickImage();
    final checkRoleError = checkRole();
    if ((form.currentState?.validate() == true) &&
        checkImage &&
        checkRoleError) {
      log("Form is valid");
      showLoading(Get.context!);
      await Future.delayed(Duration.zero);
      registerWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      ).then((value) async {
        final url = await _database.uploadImage("users", pickedImage.value);
        final r = role.value == Role.customer ? 0 : 1;
        final authUser = AuthUser(
          id: Uuid().v1(),
          name: userNameController.text,
          avatar: url,
          email: emailController.text,
          password: passwordController.text,
          location: locationController.text,
          lat: 0,
          long: 0,
          status: r,
          isActive: false,
        );
        await userDocumentReference(authUser.id).set(authUser);
        hideLoading(Get.context!);
        reset();
        Get.snackbar("Success", "User Adding is successful");
      }).catchError((o) {
        hideLoading(Get.context!);
        log("Register error: $o");
      });
    } else {
      log("Form is not valid");
    }
  }

  //TODO:TO MAKE LOGIC FOR UPDATE USE
  Future<void> updateUser() async {
    final checkImage = checkPickImage();
    final checkRoleError = checkRole();
    if ((form.currentState?.validate() == true) &&
        checkImage &&
        checkRoleError) {
      log("Form is valid");
      showLoading(Get.context!);
      await Future.delayed(Duration.zero);
      var updateUser = AuthUser(
        id: editUser.value!.id,
        name: userNameController.text,
        avatar: pickedImage.value,
        email: emailController.text,
        password: passwordController.text,
        location: locationController.text,
        lat: 0,
        long: 0,
        status: role.value == Role.customer ? 0 : 1,
        isActive: false,
      );
      //we need to first Login to get this user
      final userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      //user name update
      if (updateUser.name != editUser.value!.name) {
        await userCredential.user?.updateDisplayName(updateUser.name);
      }
      //user avatar update
      if (updateUser.avatar != editUser.value!.avatar) {
        final url = await _database.uploadImage("users", updateUser.avatar!);
        await userCredential.user?.updatePhotoURL(url);
        updateUser = updateUser.copyWith(avatar: url);
      }
      //user email update
      if (updateUser.email != editUser.value!.email) {
        await userCredential.user?.updateEmail(updateUser.email!);
      }
      //user password update
      if (updateUser.password != editUser.value!.password) {
        await userCredential.user?.updatePassword(updateUser.password!);
      }

      await userDocumentReference(updateUser.id).set(updateUser);
      hideLoading(Get.context!);
      Get.snackbar("Success", "User Updating is successful");
    } else {
      log("Form is not valid");
    }
  }

  Future<void> registerWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        log('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        log('The account already exists for that email.');
      }
    } catch (e) {
      log("$e");
    }
  }

  ///------UPDATE CURRENT USER PROFILE-------//
  void initializeUpdateProfile() {
    final password = alController.box.get(passwordKey, defaultValue: "");
    final currentUser = alController.currentUser.value!;
    userNameController.text = currentUser.name;
    emailController.text = currentUser.email ?? "";
    passwordController.text = password;
    locationController.text = currentUser.location ?? "";
    role.value = currentUser.status == 0 ? Role.customer : Role.admin;
  }

  Future<void> updateProfile() async {
    final checkImage = checkPickImage();
    final checkRoleError = checkRole();
    if ((form.currentState?.validate() == true) &&
        checkImage &&
        checkRoleError) {
      try {
        showLoading(Get.context!);
        final User user = FirebaseAuth.instance.currentUser!;
        await user.updateDisplayName(userNameController.text);
        await user.updateEmail(emailController.text);
        await user.updatePassword(passwordController.text);
        log("Form is valid");
        final url = await _database.uploadImage("users", pickedImage.value);
        await user.updatePhotoURL(url);
        final r = role.value == Role.customer ? 0 : 1;
        final authUser = AuthUser(
          id: alController.currentUser.value!.id,
          name: userNameController.text,
          avatar: url,
          email: emailController.text,
          location: locationController.text,
          lat: 0,
          long: 0,
          status: r,
          isActive: false,
        );
        await userDocumentReference(authUser.id).update(authUser.toJson());
        alController.currentUser.value = authUser;
        hideLoading(Get.context!);
        reset();
        Get.snackbar("Success", "Profile updating is successful");

        /* adminUiController.setPageType(const PageType.overview()); */
      } on FirebaseAuthException catch (e) {
        hideLoading(Get.context!);
        errorSnack("${e.message}");
      } catch (e) {
        hideLoading(Get.context!);
        errorSnack("$e");
      }
    } else {
      log("Form is not valid");
    }
  }

  Future<void> deleteUser(String id) async {
    try {
      debugPrint("************Delete User ID: $id");
      showLoading(Get.context!);
      await userDocumentReference(id).delete();
      try {
        await FirebaseAuth.instance.currentUser!.delete();
      } catch (e) {
        errorSnack("$e");
      }
      //we also delete document

      hideLoading(Get.context!);
    } on FirebaseAuthException catch (e) {
      hideLoading(Get.context!);
      if (e.code == 'requires-recent-login') {
        errorSnack(
            'The user must reauthenticate before this operation can be executed.');
      }
    } catch (e) {
      hideLoading(Get.context!);
      errorSnack("$e");
    }
  }
}
