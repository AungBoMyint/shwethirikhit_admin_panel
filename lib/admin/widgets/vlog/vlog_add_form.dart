import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pizza/admin/controller/vlog_controller.dart';
import 'package:pizza/admin/utils/extensions.dart';
import 'package:pizza/models/object_models/vlog_video.dart';
import 'package:uuid/uuid.dart';

import '../../../models/object_models/category.dart';
import '../../../service/firebase_reference.dart';
import '../../controller/news_controller.dart';
import '../../utils/func.dart';
import '../../utils/space.dart';

class VlogAddForm extends StatefulWidget {
  const VlogAddForm({
    super.key,
    required this.dropDownBorder,
    required this.vlogController,
    this.vlogVideo,
  });

  final VlogController vlogController;
  final InputBorder? dropDownBorder;
  final VlogVideo? vlogVideo;

  @override
  State<VlogAddForm> createState() => _VlogAddFormState();
}

class _VlogAddFormState extends State<VlogAddForm> {
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController nameTextController = TextEditingController();
  TextEditingController imageTextController = TextEditingController();
  TextEditingController videoTextController = TextEditingController();
  TextEditingController minutesTextController = TextEditingController();

  @override
  void initState() {
    widget.vlogController.videoDuration.value = "";
    if (!(widget.vlogVideo == null)) {
      nameTextController.text = widget.vlogVideo!.title;
      imageTextController.text = widget.vlogVideo!.image;
      videoTextController.text = widget.vlogVideo!.videoURL;
      minutesTextController.text = "${widget.vlogVideo!.minutes}";
      widget.vlogController.videoDuration.value =
          "${widget.vlogVideo!.minutes}";
    }
    super.initState();
  }

  @override
  void dispose() {
    nameTextController.dispose();
    imageTextController.dispose();
    videoTextController.dispose();
    minutesTextController.dispose();
    super.dispose();
  }

  void refresh() {
    setState(() {
      nameTextController.clear();
      imageTextController.clear();
      videoTextController.clear();
      minutesTextController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final VlogController vlogController = Get.find();
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
              onChanged: (v) => vlogController.debouncer.run(() {
                vlogController.startVideoDurationExtraction(v);
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
              final duration = vlogController.videoDuration.value;

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
                  if (widget.vlogVideo == null) {
                    final vlogVideo = VlogVideo(
                      id: Uuid().v1(),
                      title: nameTextController.text,
                      image: imageTextController.text,
                      videoURL: videoTextController.text,
                      minutes: int.tryParse(minutesTextController.text) ?? 0,
                      dateTime: DateTime.now(),
                      order: 0,
                      nameList: subName,
                    );
                    upload<VlogVideo>(
                        vlogVideoDocument(vlogVideo.id),
                        vlogVideo,
                        "Vlog Video uploading is successful.",
                        "Vlog Video uploading is failed.", () {
                      refresh();
                      vlogController.vlogVideos.add(vlogVideo);
                    });

                    debugPrint("******Uploading...Slider");
                  } else {
                    final vlogVideo = VlogVideo(
                      id: widget.vlogVideo!.id,
                      title: nameTextController.text,
                      image: imageTextController.text,
                      videoURL: videoTextController.text,
                      minutes: int.tryParse(minutesTextController.text) ?? 0,
                      dateTime: widget.vlogVideo?.dateTime ?? DateTime.now(),
                      order: 0,
                      nameList: subName,
                    );
                    edit<VlogVideo>(
                        vlogVideoDocument(vlogVideo.id),
                        vlogVideo,
                        "Vlog Video updating is successful.",
                        "Vlog Video updating is failed.", () {
                      final index = vlogController.vlogVideos
                          .indexWhere((e) => e.id == vlogVideo.id);
                      vlogController.vlogVideos[index] = vlogVideo;
                    });

                    debugPrint("******Uploading...Slider");
                  }
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  widget.vlogVideo == null ? "Save" : "Update",
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
