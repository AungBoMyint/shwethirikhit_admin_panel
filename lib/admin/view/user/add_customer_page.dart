import 'dart:io';

import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

import '../../../models/customer_role.dart';
import '../../../models/page_type.dart';
import '../../controller/admin_login_controller.dart';
import '../../controller/admin_ui_controller.dart';
import '../../controller/customer_related_controller.dart';
import '../../utils/constant.dart';
import '../../utils/func.dart';
import '../../utils/space.dart';

class AddCustomerPage extends StatelessWidget {
  const AddCustomerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AdminLoginController alController = Get.find();
    final AdminUiController adminUiController = Get.find();
    dropDownBorder() => OutlineInputBorder(
            borderSide: BorderSide(
          color: alController.isLightTheme.value
              ? Theme.of(context).dividerColor
              : Colors.grey.shade100,
        ));
    const addImageIcon =
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT7QsDfFzqYkAHGCjGUZI_Q6g27cdw7tF9DO3FveGM&s";
    const girlNetworkImage =
        "https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80";
    final textTheme = Theme.of(context).textTheme;
    final titleTextStyle = textTheme.displayMedium?.copyWith(fontSize: 22);
    final bodyTextStyle = textTheme.displayMedium;
    final CustomerRelatedController crController = Get.find();
    var labelStyle = textTheme.displayMedium?.copyWith(
      color:
          alController.isLightTheme.value ? Colors.grey : Colors.grey.shade300,
    );
    var floatingLabelStyle = textTheme.displayMedium?.copyWith(
      color:
          alController.isLightTheme.value ? Colors.grey : Colors.grey.shade300,
    );
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      final height = constraints.maxHeight;
      return Container(
        color: Theme.of(context).cardTheme.color,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  text: "← Customers/",
                  style: textTheme.displayMedium?.copyWith(
                    fontSize: 25,
                    color: Colors.blue,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      adminUiController.changePageType(PageType.customers());
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
                  SizedBox(
                    height: height * 0.8,
                    width: width * 0.5,
                    child: Form(
                      key: crController.form,
                      child: SingleChildScrollView(
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
                                    labelStyle: labelStyle,
                                    floatingLabelStyle: floatingLabelStyle,
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
                                    labelStyle: labelStyle,
                                    floatingLabelStyle: floatingLabelStyle,
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
                                    labelStyle: labelStyle,
                                    floatingLabelStyle: floatingLabelStyle,
                                  ),
                                ),
                              ),
                              verticalSpace(),
                              //Ages
                              DropDownTextField(
                                controller: crController.ageController,
                                clearOption: true,
                                textFieldDecoration: InputDecoration(
                                  border: dropDownBorder(),
                                  disabledBorder: dropDownBorder(),
                                  focusedBorder: dropDownBorder(),
                                  enabledBorder: dropDownBorder(),
                                  labelText: "Select Age",
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                ),
                                validator: (value) =>
                                    stringValidator("Age", value),
                                dropDownItemCount: ages.length,
                                dropDownList: ages
                                    .map((e) => DropDownValueModel(
                                          name: e,
                                          value: e,
                                        ))
                                    .toList(),
                                onChanged: (val) {
                                  debugPrint("Single Selections: $val");
                                },
                              ),
                              verticalSpace(),
                              //Areas
                              MultiSelectDialogField(
                                initialValue: crController.multiSelectedItems
                                    .map((element) => element)
                                    .toList(),
                                title: Text("Select Areas"),
                                buttonText: Text("Select Areas"),
                                buttonIcon: Icon(Icons.arrow_drop_down),
                                items: areas
                                    .map((e) => MultiSelectItem(e, e))
                                    .toList(),
                                listType: MultiSelectListType.LIST,
                                onConfirm: (values) {
                                  crController.multiSelectedItems.value =
                                      values.map((e) => e as String).toList();
                                },
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: alController.isLightTheme.value
                                        ? Theme.of(context).dividerColor
                                        : Colors.grey.shade100,
                                  ),
                                ),
                                validator: (v) {
                                  if (v == null || v.isEmpty) {
                                    return "Areas is required.";
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              /*  DropDownTextField.multiSelection(
                                controller:
                                    multiController /* crController.areaController */,
                                clearOption: true,
                                displayCompleteItem: true,
                                textFieldDecoration: InputDecoration(
                                  border: dropDownBorder(),
                                  disabledBorder: dropDownBorder(),
                                  focusedBorder: dropDownBorder(),
                                  enabledBorder: dropDownBorder(),
                                  labelText: "Select Areas",
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                ),
                                validator: (value) =>
                                    stringValidator("Areas", value),
                                dropDownItemCount: areas.length,
                                dropDownList: areas
                                    .map((e) => DropDownValueModel(
                                          name: e,
                                          value: e,
                                        ))
                                    .toList(),
                                onChanged: (val) {
                                  debugPrint("Multi Selection: $val");
                                },
                              ), */
                              verticalSpace(),
                              //Select Role, Admin or Customer
                              Obx(() {
                                final r = crController.role.value;
                                return LayoutBuilder(
                                    builder: (context, constraints) {
                                  final parentWidth = constraints.maxWidth;
                                  return DropdownButtonFormField<Role>(
                                    dropdownColor:
                                        Theme.of(context).cardTheme.color,
                                    value: r,
                                    alignment: AlignmentDirectional.centerStart,
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
                                        style: textTheme.displaySmall?.copyWith(
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
                                          style:
                                              textTheme.displaySmall?.copyWith(
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
                              }),
                              verticalSpace(),
                              Obx(() {
                                return Align(
                                  alignment: Alignment.bottomRight,
                                  child: crController.editUser.value == null
                                      ? ElevatedButton(
                                          onPressed: () =>
                                              crController.addUser(),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "ADD",
                                              style: textTheme.displayMedium
                                                  ?.copyWith(
                                                      color: Colors.white),
                                            ),
                                          ),
                                        )
                                      : ElevatedButton(
                                          onPressed: () =>
                                              crController.updateUser(),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "UPDATE",
                                              style: textTheme.displayMedium
                                                  ?.copyWith(
                                                      color: Colors.white),
                                            ),
                                          ),
                                        ),
                                );
                              }),
                              verticalSpace(),
                            ]),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
