import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pizza/admin/controller/therapy_controller.dart';
import 'package:pizza/admin/utils/extensions.dart';
import 'package:uuid/uuid.dart';

import '../../../models/object_models/category.dart';
import '../../../service/firebase_reference.dart';
import '../../controller/news_controller.dart';
import '../../utils/func.dart';
import '../../utils/space.dart';

class AddCategoryForm extends StatefulWidget {
  const AddCategoryForm({
    super.key,
    required this.width,
    required this.therapyControllert,
    required this.dropDownBorder,
    this.category,
  });

  final double width;
  final TherapyController therapyControllert;
  final InputBorder? dropDownBorder;
  final Category? category;

  @override
  State<AddCategoryForm> createState() => _AddCategoryFormState();
}

class _AddCategoryFormState extends State<AddCategoryForm> {
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController nameTextController = TextEditingController();
  TextEditingController imageTextController = TextEditingController();

  @override
  void initState() {
    if (!(widget.category == null)) {
      nameTextController.text = widget.category!.name;
      imageTextController.text = widget.category!.image;
    }
    super.initState();
  }

  @override
  void dispose() {
    nameTextController.dispose();
    imageTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TherapyController therapyController = Get.find();
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
            TextFormField(
              validator: (v) => stringValidator("Image", v),
              controller: imageTextController,
              decoration: InputDecoration(
                border: widget.dropDownBorder,
                disabledBorder: widget.dropDownBorder,
                focusedBorder: widget.dropDownBorder,
                enabledBorder: widget.dropDownBorder,
                labelText: "Image Url",
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
                  if (widget.category == null) {
                    final category = Category(
                      id: Uuid().v1(),
                      name: nameTextController.text,
                      image: imageTextController.text.removeAllWhitespace,
                      order: 0,
                      dateTime: DateTime.now(),
                      nameList: subName,
                    );
                    upload<Category>(
                        therapyCategoryDocument(category.id),
                        category,
                        "Category uploading is successful.",
                        "Category uploading is failed.", () {
                      setState(() {
                        nameTextController.clear();
                        imageTextController.clear();
                      });
                      therapyController.categories.add(category);
                    });

                    debugPrint("******Uploading...Slider");
                  } else if (nameTextController.text != widget.category!.name ||
                      imageTextController.text != widget.category!.image) {
                    final category = Category(
                      id: widget.category!.id,
                      name: nameTextController.text,
                      image: imageTextController.text.removeAllWhitespace,
                      order: widget.category!.order ?? 0,
                      dateTime: widget.category!.dateTime,
                      nameList: subName,
                    );
                    edit<Category>(
                        therapyCategoryDocument(category.id),
                        category,
                        "Category updating is successful.",
                        "Category updating is failed.", () {
                      final index = therapyController.categories
                          .indexWhere((e) => e.id == category.id);
                      therapyController.categories[index] = category;
                    });

                    debugPrint("******Uploading...Slider");
                  }
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  widget.category == null ? "Save" : "Update",
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
