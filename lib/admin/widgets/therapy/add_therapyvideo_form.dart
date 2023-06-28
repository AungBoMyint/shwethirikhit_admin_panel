import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pizza/admin/controller/therapy_controller.dart';
import 'package:pizza/admin/controller/vlog_controller.dart';
import 'package:pizza/admin/utils/extensions.dart';
import 'package:pizza/models/object_models/category.dart';
import 'package:pizza/models/object_models/therapy_video.dart';
import 'package:pizza/models/object_models/vlog_video.dart';
import 'package:pizza/service/query.dart';
import 'package:uuid/uuid.dart';
import '../../../service/firebase_reference.dart';
import '../../utils/func.dart';
import '../../utils/space.dart';
import '../../utils/widgets.dart';

class AddTherapyVideoForm extends StatefulWidget {
  const AddTherapyVideoForm({
    super.key,
    required this.dropDownBorder,
    required this.therapyController,
    this.therapyVideo,
  });

  final TherapyController therapyController;
  final InputBorder? dropDownBorder;
  final TherapyVideo? therapyVideo;

  @override
  State<AddTherapyVideoForm> createState() => _AddTherapyVideoFormState();
}

class _AddTherapyVideoFormState extends State<AddTherapyVideoForm> {
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController nameTextController = TextEditingController();
  TextEditingController imageTextController = TextEditingController();
  TextEditingController videoTextController = TextEditingController();
  TextEditingController minutesTextController = TextEditingController();
  late SingleValueDropDownController _categoryController;

  @override
  void initState() {
    _categoryController = SingleValueDropDownController();
    widget.therapyController.videoDuration.value = "";
    if (!(widget.therapyVideo == null)) {
      nameTextController.text = widget.therapyVideo!.title;
      imageTextController.text = widget.therapyVideo!.image;
      videoTextController.text = widget.therapyVideo!.videoURL;
      minutesTextController.text = "${widget.therapyVideo!.minutes}";
      widget.therapyController.videoDuration.value =
          "${widget.therapyVideo!.minutes}";
      therapyCategoryDocument(widget.therapyVideo?.parentID ?? "")
          .get()
          .then((value) {
        var parentId = widget.therapyVideo?.parentID;
        var name = value.data()?.name ?? "";
        var v = value.data()?.id ?? "";
        _categoryController = SingleValueDropDownController(
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
    videoTextController.dispose();
    minutesTextController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  void refresh() {
    setState(() {
      nameTextController.clear();
      imageTextController.clear();
      videoTextController.clear();
      minutesTextController.clear();
      _categoryController.clearDropDown();
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
              validator: (v) => stringValidator("Video Url", v),
              onChanged: (v) => therapyController.debouncer.run(() {
                therapyController.startVideoDurationExtraction(v);
              }),
              controller: videoTextController,
              decoration: InputDecoration(
                border: widget.dropDownBorder,
                disabledBorder: widget.dropDownBorder,
                focusedBorder: widget.dropDownBorder,
                enabledBorder: widget.dropDownBorder,
                labelText: "Video Url",
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
            ),
            verticalSpace(),
            Obx(() {
              final duration = therapyController.videoDuration.value;

              minutesTextController.text = duration;
              debugPrint("****Vlog Video Minute: ${duration}");
              return TextFormField(
                validator: (v) => integerValidator("Duration(minutes)", v),
                controller: minutesTextController,
                decoration: InputDecoration(
                  border: widget.dropDownBorder,
                  disabledBorder: widget.dropDownBorder,
                  focusedBorder: widget.dropDownBorder,
                  enabledBorder: widget.dropDownBorder,
                  labelText: "Duration(minutes)",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              );
            }),
            verticalSpace(),
            FirebaseSnapHelper<QuerySnapshot<Category>>(
              future: therapyCategoryCollection().get(),
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
                  if (widget.therapyVideo == null) {
                    final therapyVideo = TherapyVideo(
                      id: Uuid().v1(),
                      title: nameTextController.text,
                      image: imageTextController.text,
                      videoURL: videoTextController.text,
                      minutes: int.tryParse(minutesTextController.text) ?? 0,
                      dateTime: DateTime.now(),
                      order: 0,
                      parentID: _categoryController.dropDownValue?.value ?? "",
                      nameList: subName,
                    );
                    upload<TherapyVideo>(
                        therapyVideoDocument(therapyVideo.id),
                        therapyVideo,
                        "Therapy Video uploading is successful.",
                        "Therapy Video uploading is failed.", () {
                      refresh();
                      therapyController.therapyVideos.add(therapyVideo);
                    });

                    debugPrint("******Uploading...Slider");
                  } else {
                    final therapyVideo = TherapyVideo(
                      id: widget.therapyVideo!.id,
                      title: nameTextController.text,
                      image: imageTextController.text,
                      videoURL: videoTextController.text,
                      minutes: int.tryParse(minutesTextController.text) ?? 0,
                      dateTime: widget.therapyVideo?.dateTime ?? DateTime.now(),
                      order: 0,
                      parentID: _categoryController.dropDownValue?.value ?? "",
                      nameList: subName,
                    );
                    edit<TherapyVideo>(
                        therapyVideoDocument(therapyVideo.id),
                        therapyVideo,
                        "Therapy Video updating is successful.",
                        "Therapy Video updating is failed.", () {
                      final index = therapyController.therapyVideos
                          .indexWhere((e) => e.id == therapyVideo.id);
                      therapyController.therapyVideos[index] = therapyVideo;
                    });

                    debugPrint("******Uploading...Slider");
                  }
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  widget.therapyVideo == null ? "Save" : "Update",
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
