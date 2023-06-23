import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pizza/models/page_type.dart';

import '../../controller/admin_ui_controller.dart';
import '../../controller/customer_related_controller.dart';
import '../../utils/space.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final AdminUiController adminUiController = Get.find();
    dropDownBorder() => OutlineInputBorder(
            borderSide: BorderSide(
          color: Theme.of(context).dividerColor,
        ));
    const addImageIcon =
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT7QsDfFzqYkAHGCjGUZI_Q6g27cdw7tF9DO3FveGM&s";

    final textTheme = Theme.of(context).textTheme;
    final CustomerRelatedController crController = Get.find();
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      return Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      text: "← Back/",
                      style: textTheme.displayMedium?.copyWith(
                        fontSize: 25,
                        color: Colors.blue,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          adminUiController
                              .changePageType(PageType.newsSlider());
                        },
                    ),
                  ),

                  //Top Image,Name,
                  Row(
                    children: [
                      //Product Image
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () => crController.pickImage(),
                            child: Obx(() {
                              return crController.isFileImage.value &&
                                      crController.pickedImage.isNotEmpty
                                  ? Image.network(
                                      crController.pickedImage.value,
                                      width: width *
                                          0.25, //for web width,height=> width*0.25,
                                      height: width * 0.25,
                                      fit: BoxFit.cover,
                                    )
                                  : !crController.isFileImage.value &&
                                          crController.pickedImage.isNotEmpty
                                      ? Image.network(
                                          crController.pickedImage.value,
                                          /* width: width * 0.25,
                                        height: width * 0.25, */
                                          fit: BoxFit.cover,
                                        )
                                      : Image.network(
                                          addImageIcon,
                                          width: width * 0.25,
                                          height: width * 0.25,
                                          fit: BoxFit.cover,
                                        );
                            }),
                          ),
                          //Image Error
                          Obx(() {
                            return crController.pickedImageError.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                      top: 10,
                                    ),
                                    child: Text(
                                      crController.pickedImageError.value,
                                      style: const TextStyle(
                                        color: Colors.red,
                                      ),
                                    ),
                                  )
                                : const SizedBox();
                          }),
                        ],
                      ),
                      horizontalSpace(),
                      //Name Description
                      Expanded(
                        child: Form(
                          key: crController.form,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                //user name
                                SizedBox(
                                  child: TextFormField(
                                    validator: (v) =>
                                        crController.validator(v, "User Name"),
                                    controller: crController.userNameController,
                                    decoration: InputDecoration(
                                      border: dropDownBorder(),
                                      disabledBorder: dropDownBorder(),
                                      focusedBorder: dropDownBorder(),
                                      enabledBorder: dropDownBorder(),
                                      labelText: "User Name",
                                    ),
                                  ),
                                ),
                                verticalSpace(),
                                //email address
                                SizedBox(
                                  child: TextFormField(
                                    validator: (v) =>
                                        crController.validator(v, "Email"),
                                    controller: crController.emailController,
                                    decoration: InputDecoration(
                                      border: dropDownBorder(),
                                      disabledBorder: dropDownBorder(),
                                      focusedBorder: dropDownBorder(),
                                      enabledBorder: dropDownBorder(),
                                      labelText: "Email",
                                    ),
                                  ),
                                ),
                                verticalSpace(),
                                //password
                                SizedBox(
                                  child: TextFormField(
                                    validator: (v) =>
                                        crController.validator(v, "Password"),
                                    controller: crController.passwordController,
                                    decoration: InputDecoration(
                                      border: dropDownBorder(),
                                      disabledBorder: dropDownBorder(),
                                      focusedBorder: dropDownBorder(),
                                      enabledBorder: dropDownBorder(),
                                      labelText: "Password",
                                    ),
                                  ),
                                ),
                                /*  //location
                                SizedBox(
                                  child: TextFormField(
                                    validator: (v) =>
                                        crController.validator(v, "Address"),
                                    controller: crController.locationController,
                                    decoration: InputDecoration(
                                      border: dropDownBorder(),
                                      disabledBorder: dropDownBorder(),
                                      focusedBorder: dropDownBorder(),
                                      enabledBorder: dropDownBorder(),
                                      labelText: "Address",
                                    ),
                                  ),
                                ), */
                                verticalSpace(),
                                /*  //Select Role, Admin or Customer
                                Obx(() {
                                  final r = crController.role.value;
                                  return LayoutBuilder(
                                      builder: (context, constraints) {
                                    final parentWidth = constraints.maxWidth;
                                    return DropdownButtonFormField<Role>(
                                      value: r,
                                      alignment:
                                          AlignmentDirectional.centerStart,
                                      autofocus: false,
                                      decoration: InputDecoration(
                                        border: dropDownBorder(),
                                        disabledBorder: dropDownBorder(),
                                        focusedBorder: dropDownBorder(),
                                        enabledBorder: dropDownBorder(),
                                      ),
                                      hint: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          "Select Role",
                                          style:
                                              textTheme.displaySmall?.copyWith(
                                            color: Colors.grey.shade600,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      items: customerRoles.map((e) {
                                        return DropdownMenuItem<Role>(
                                          value: e.role,
                                          child: Text(
                                            e.roleString,
                                            style: textTheme.displaySmall
                                                ?.copyWith(
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (_) =>
                                          crController.changeRole(_!),
                                    );
                                  });
                                }),
                                //Role Error
                                Obx(() {
                                  return crController.roleError.isNotEmpty
                                      ? Padding(
                                          padding: const EdgeInsets.only(
                                            top: 10,
                                          ),
                                          child: Text(
                                            crController.roleError.value,
                                            style: const TextStyle(
                                              color: Colors.red,
                                            ),
                                          ),
                                        )
                                      : const SizedBox();
                                }), */
                              ]),
                        ),
                      ),
                    ],
                  ),
                  verticalSpace(
                    v: 40,
                  ),
                  const Expanded(child: SizedBox()),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: () => crController.updateProfile(),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "UPDATE",
                          style: textTheme.displayMedium?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  verticalSpace(),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}
