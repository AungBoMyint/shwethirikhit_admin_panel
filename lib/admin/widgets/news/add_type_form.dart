import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pizza/admin/utils/extensions.dart';
import 'package:pizza/models/object_models/type.dart';
import 'package:uuid/uuid.dart';

import '../../../models/object_models/category.dart';
import '../../../service/firebase_reference.dart';
import '../../controller/news_controller.dart';
import '../../utils/func.dart';
import '../../utils/space.dart';

class AddTypeForm extends StatefulWidget {
  const AddTypeForm({
    super.key,
    required this.width,
    required this.newsController,
    required this.dropDownBorder,
    this.type,
  });

  final double width;
  final NewsController newsController;
  final InputBorder? dropDownBorder;
  final ItemType? type;

  @override
  State<AddTypeForm> createState() => _AddTypeFormState();
}

class _AddTypeFormState extends State<AddTypeForm> {
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController nameTextController = TextEditingController();

  @override
  void initState() {
    if (!(widget.type == null)) {
      nameTextController.text = widget.type!.name;
    }
    super.initState();
  }

  @override
  void dispose() {
    nameTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextFormField(
              validator: (v) => stringValidator("Name", v),
              controller: nameTextController,
              decoration: InputDecoration(
                border: widget.dropDownBorder,
                disabledBorder: widget.dropDownBorder,
                focusedBorder: widget.dropDownBorder,
                enabledBorder: widget.dropDownBorder,
                labelText: "Name",
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
            ),
            verticalSpace(),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState?.validate() == true) {
                  List<String> subName = [];
                  var subList = nameTextController.text.split('');
                  for (var i = 0; i < subList.length; i++) {
                    subName.add(nameTextController.text
                        .substring(0, i + 1)
                        .toLowerCase());
                  }
                  if (widget.type == null) {
                    final itemType = ItemType(
                      id: Uuid().v1(),
                      name: nameTextController.text,
                      dateTime: DateTime.now().toIso8601String(),
                      order: 0,
                      nameList: subName,
                    );
                    upload<ItemType>(
                        homeTypeDocument(itemType.id),
                        itemType,
                        "Type uploading is successful.",
                        "Type uploading is failed.", () {
                      setState(() {
                        nameTextController.clear();
                      });
                    });

                    debugPrint("******Uploading...Slider");
                  } else if (nameTextController.text != widget.type!.name) {
                    final itemType = ItemType(
                      id: widget.type!.id,
                      name: nameTextController.text,
                      dateTime: widget.type!.dateTime,
                      order: widget.type!.order,
                      nameList: subName,
                    );
                    edit<ItemType>(
                        homeTypeDocument(itemType.id),
                        itemType,
                        "Type updating is successful.",
                        "Type updating is failed.",
                        () {});

                    debugPrint("******Uploading...Slider");
                  }
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  widget.type == null ? "Save" : "Update",
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            verticalSpace(v: 10),
            ElevatedButton(
              onPressed: () {
                Get.back();
              },
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  "Back",
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ).withColor(Colors.red),
          ],
        ),
      ),
    );
  }
}
