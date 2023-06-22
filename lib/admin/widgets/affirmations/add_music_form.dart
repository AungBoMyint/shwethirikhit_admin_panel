import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pizza/admin/controller/affirmations_controller.dart';
import 'package:pizza/admin/controller/therapy_controller.dart';
import 'package:pizza/admin/controller/vlog_controller.dart';
import 'package:pizza/admin/utils/extensions.dart';
import 'package:pizza/models/object_models/category.dart';
import 'package:pizza/models/object_models/music.dart';
import 'package:pizza/models/object_models/therapy_video.dart';
import 'package:pizza/models/object_models/type.dart';
import 'package:pizza/models/object_models/vlog_video.dart';
import 'package:pizza/service/query.dart';
import 'package:uuid/uuid.dart';
import '../../../service/firebase_reference.dart';
import '../../utils/func.dart';
import '../../utils/space.dart';
import '../../utils/widgets.dart';

class AddMusicForm extends StatefulWidget {
  const AddMusicForm({
    super.key,
    required this.dropDownBorder,
    required this.therapyController,
    this.music,
  });

  final AffirmationsController therapyController;
  final InputBorder? dropDownBorder;
  final Music? music;

  @override
  State<AddMusicForm> createState() => _AddMusicFormState();
}

class _AddMusicFormState extends State<AddMusicForm> {
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController nameTextController = TextEditingController();
  TextEditingController imageTextController = TextEditingController();
  TextEditingController audioTextController = TextEditingController();
  late SingleValueDropDownController _categoryController;
  late SingleValueDropDownController _typeController;
  @override
  void initState() {
    _categoryController = SingleValueDropDownController();
    _typeController = SingleValueDropDownController();
    if (!(widget.music == null)) {
      nameTextController.text = widget.music!.name;
      imageTextController.text = widget.music!.image;
      audioTextController.text = widget.music!.audioURL;
      affirmationsCategoryDocument(widget.music?.categoryID ?? "")
          .get()
          .then((value) {
        var name = value.data()?.name ?? "";
        var v = value.data()?.id ?? "";
        _categoryController = SingleValueDropDownController(
            data: DropDownValueModel(
          name: name,
          value: v,
        ));
      });
      //type
      affirmationsTypeDocument(widget.music?.type ?? "").get().then((value) {
        var name = value.data()?.name ?? "";
        var v = value.data()?.id ?? "";
        _typeController = SingleValueDropDownController(
            data: DropDownValueModel(
          name: name,
          value: v,
        ));
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    nameTextController.dispose();
    imageTextController.dispose();
    audioTextController.dispose();
    _categoryController.dispose();
    _typeController.dispose();
    super.dispose();
  }

  void refresh() {
    setState(() {
      nameTextController.clear();
      imageTextController.clear();
      audioTextController.clear();
      _categoryController.clearDropDown();
      _typeController.clearDropDown();
    });
  }

  @override
  Widget build(BuildContext context) {
    final TherapyController therapyController = Get.find();
    final readOnlyMode = false;

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
            TextFormField(
              validator: (v) => stringValidator("Audio Url", v),
              controller: audioTextController,
              decoration: InputDecoration(
                border: widget.dropDownBorder,
                disabledBorder: widget.dropDownBorder,
                focusedBorder: widget.dropDownBorder,
                enabledBorder: widget.dropDownBorder,
                labelText: "Audio Url",
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
            ),
            verticalSpace(),
            FirebaseSnapHelper<QuerySnapshot<Category>>(
              future: affirmationsCategoryCollection().get(),
              onSuccess: (snapshot) {
                final itemsList = snapshot.docs;
                return DropDownTextField(
                  controller: _categoryController,
                  clearOption: true,
                  readOnly: readOnlyMode,
                  textFieldDecoration: InputDecoration(
                    border: dropDownBorder(),
                    disabledBorder: dropDownBorder(),
                    focusedBorder: dropDownBorder(),
                    enabledBorder: dropDownBorder(),
                    labelText: "Select Category",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  validator: (value) => stringValidator("Category", value),
                  dropDownItemCount: itemsList.length,
                  dropDownList: itemsList
                      .map((e) => DropDownValueModel(
                            name: e.data().name,
                            value: e.data().id,
                          ))
                      .toList(),
                  onChanged: (val) {},
                );
              },
            ),
            verticalSpace(),
            FirebaseSnapHelper<QuerySnapshot<ItemType>>(
              future: affirmationsTypeCollection().get(),
              onSuccess: (snapshot) {
                final itemsList = snapshot.docs;
                return DropDownTextField(
                  controller: _typeController,
                  clearOption: true,
                  readOnly: readOnlyMode,
                  textFieldDecoration: InputDecoration(
                    border: dropDownBorder(),
                    disabledBorder: dropDownBorder(),
                    focusedBorder: dropDownBorder(),
                    enabledBorder: dropDownBorder(),
                    labelText: "Select Type",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  validator: (value) => stringValidator("Type", value),
                  dropDownItemCount: itemsList.length,
                  dropDownList: itemsList
                      .map((e) => DropDownValueModel(
                            name: e.data().name,
                            value: e.data().id,
                          ))
                      .toList(),
                  onChanged: (val) {},
                );
              },
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
                  if (widget.music == null) {
                    final therapyVideo = Music(
                      id: Uuid().v1(),
                      name: nameTextController.text,
                      image: imageTextController.text,
                      audioURL: audioTextController.text,
                      dateTime: DateTime.now(),
                      desc: "",
                      type: _typeController.dropDownValue?.value ?? "",
                      categoryID:
                          _categoryController.dropDownValue?.value ?? "",
                      nameList: subName,
                    );
                    upload<Music>(
                        musicDocument(therapyVideo.id),
                        therapyVideo,
                        "Music uploading is successful.",
                        "Music uploading is failed.", () {
                      refresh();
                    });

                    debugPrint("******Uploading...Slider");
                  } else {
                    final therapyVideo = Music(
                      id: widget.music?.id ?? "",
                      name: nameTextController.text,
                      image: imageTextController.text,
                      audioURL: audioTextController.text,
                      dateTime: widget.music?.dateTime ?? DateTime.now(),
                      desc: "",
                      type: _typeController.dropDownValue?.value ?? "",
                      categoryID:
                          _categoryController.dropDownValue?.value ?? "",
                      nameList: subName,
                    );
                    edit<Music>(
                        musicDocument(therapyVideo.id),
                        therapyVideo,
                        "Music updating is successful.",
                        "Music updating is failed.",
                        () {});

                    debugPrint("******Uploading...Slider");
                  }
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  widget.music == null ? "Save" : "Update",
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
