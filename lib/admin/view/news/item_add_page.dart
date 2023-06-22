import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pizza/admin/controller/admin_ui_controller.dart';
import 'package:pizza/admin/controller/news_controller.dart';
import 'package:pizza/admin/utils/space.dart';
import 'package:pizza/models/object_models/expert.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:pizza/models/object_models/type.dart';
import 'package:pizza/models/page_type.dart';
import 'package:pizza/service/reference.dart';
import 'package:uuid/uuid.dart';

import '../../utils/func.dart';
import '../../utils/widgets.dart';

class ItemAddPage extends StatefulWidget {
  const ItemAddPage({super.key});

  @override
  State<ItemAddPage> createState() => _ItemAddPageState();
}

class _ItemAddPageState extends State<ItemAddPage> {
  final NewsController newsController = Get.find();
  late SingleValueDropDownController _typeController;

  TextEditingController nameTextController = TextEditingController();
  TextEditingController photoOneTextController = TextEditingController();
  TextEditingController photoTwoTextController = TextEditingController();
  TextEditingController photoThreeTextController = TextEditingController();
  TextEditingController descriptionTextController = TextEditingController();
  TextEditingController ratingTextController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();

  var selectedTypeId = "";

  void setSelectedTypeId(String id) {
    setState(() {
      selectedTypeId = id;
    });
  }

  @override
  void initState() {
    _typeController = SingleValueDropDownController();
    final item = newsController.selectedExpertItem.fold((l) => l, (r) => r);
    if (!(item == null)) {
      nameTextController.text = item.name;
      photoOneTextController.text = item.photolink;
      photoTwoTextController.text = item.photolink2;
      photoThreeTextController.text = item.photolink3;
      descriptionTextController.text = item.description;
      ratingTextController.text = item.rating;
      homeTypeDocument(item.type).get().then((value) {
        _typeController = SingleValueDropDownController(
            data: DropDownValueModel(
                name: value.data()?.name ?? "", value: value.data()?.id ?? ""));
      });
    } else {
      refresh(true);
    }
    super.initState();
  }

  @override
  void dispose() {
    nameTextController.dispose();
    photoOneTextController.dispose();
    photoTwoTextController.dispose();
    photoThreeTextController.dispose();
    descriptionTextController.dispose();
    ratingTextController.dispose();
    _typeController.dispose();
    super.dispose();
  }

  void refresh(bool isSetState) {
    isSetState
        ? setState(() {
            nameTextController.clear();
            photoOneTextController.clear();
            photoTwoTextController.clear();
            photoThreeTextController.clear();
            descriptionTextController.clear();
            ratingTextController.clear();
            _typeController.clearDropDown();
          })
        : () {
            nameTextController.clear();
            photoOneTextController.clear();
            photoTwoTextController.clear();
            photoThreeTextController.clear();
            descriptionTextController.clear();
            ratingTextController.clear();
            _typeController.clearDropDown();
          };
  }

  @override
  Widget build(BuildContext context) {
    final AdminUiController adminUiController = Get.find();
    final textTheme = Theme.of(context).textTheme;
    final readOnlyMode = newsController.selectedExpertItem.isLeft();
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                text: "← Items/",
                style: textTheme.displayMedium?.copyWith(
                  fontSize: 25,
                  color: Colors.blue,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    adminUiController.changePageType(PageType.newsItems());
                  },
              ),
            ),
            verticalSpace(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Left Form
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Name
                      TextFormField(
                        validator: (v) => stringValidator("Name", v),
                        controller: nameTextController,
                        readOnly: readOnlyMode,
                        decoration: InputDecoration(
                          border: dropDownBorder(),
                          disabledBorder: dropDownBorder(),
                          focusedBorder: dropDownBorder(),
                          enabledBorder: dropDownBorder(),
                          labelText: "Name",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                      verticalSpace(),
                      //Photo1
                      TextFormField(
                        validator: (v) => stringValidator("Photo1", v),
                        controller: photoOneTextController,
                        readOnly: readOnlyMode,
                        decoration: InputDecoration(
                          border: dropDownBorder(),
                          disabledBorder: dropDownBorder(),
                          focusedBorder: dropDownBorder(),
                          enabledBorder: dropDownBorder(),
                          labelText: "Photo1",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                      verticalSpace(),
                      //Photo2
                      TextFormField(
                        validator: (v) => stringValidator("Photo2", v),
                        controller: photoTwoTextController,
                        readOnly: readOnlyMode,
                        decoration: InputDecoration(
                          border: dropDownBorder(),
                          disabledBorder: dropDownBorder(),
                          focusedBorder: dropDownBorder(),
                          enabledBorder: dropDownBorder(),
                          labelText: "Photo2",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                      verticalSpace(),
                      //Photo3
                      TextFormField(
                        validator: (v) => stringValidator("Photo3", v),
                        controller: photoThreeTextController,
                        readOnly: readOnlyMode,
                        decoration: InputDecoration(
                          border: dropDownBorder(),
                          disabledBorder: dropDownBorder(),
                          focusedBorder: dropDownBorder(),
                          enabledBorder: dropDownBorder(),
                          labelText: "Photo3",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                      verticalSpace(),
                      //Rating
                      TextFormField(
                        validator: (v) => stringValidator("Rating", v),
                        controller: ratingTextController,
                        readOnly: readOnlyMode,
                        decoration: InputDecoration(
                          border: dropDownBorder(),
                          disabledBorder: dropDownBorder(),
                          focusedBorder: dropDownBorder(),
                          enabledBorder: dropDownBorder(),
                          labelText: "Rating",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                      verticalSpace(),
                      readOnlyMode
                          ? FirebaseSnapHelper<DocumentSnapshot<ItemType>>(
                              future: homeTypeDocument(
                                      newsController.selectedExpertItem.fold(
                                          (l) => l.type, (r) => r?.type ?? ""))
                                  .get(),
                              onSuccess: (snapshot) {
                                final item = snapshot.data();
                                return TextFormField(
                                  validator: (v) =>
                                      stringValidator("Rating", v),
                                  initialValue: item?.name ?? "",
                                  readOnly: readOnlyMode,
                                  decoration: InputDecoration(
                                    border: dropDownBorder(),
                                    disabledBorder: dropDownBorder(),
                                    focusedBorder: dropDownBorder(),
                                    enabledBorder: dropDownBorder(),
                                    labelText: "Select Type",
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                  ),
                                );
                              },
                            )
                          : FirebaseSnapHelper<QuerySnapshot<ItemType>>(
                              future: homeTypeCollection().get(),
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
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                  ),
                                  validator: (value) =>
                                      stringValidator("Type", value),
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
                      newsController.selectedExpertItem.isLeft()
                          ? const SizedBox()
                          : SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  //TODO:UPLOAD ITEM
                                  if (formKey.currentState?.validate() ==
                                      true) {
                                    List<String> subName = [];
                                    var subList =
                                        nameTextController.text.split('');
                                    for (var i = 0; i < subList.length; i++) {
                                      subName.add(nameTextController.text
                                          .substring(0, i + 1)
                                          .toLowerCase());
                                    }
                                    if (newsController.selectedExpertItem
                                            .getOrElse(() => null) ==
                                        null) {
                                      final item = ExpertModel(
                                        id: Uuid().v1(),
                                        photolink: photoOneTextController.text,
                                        photolink2: photoTwoTextController.text,
                                        photolink3:
                                            photoThreeTextController.text,
                                        name: nameTextController.text,
                                        type: _typeController
                                            .dropDownValue?.value,
                                        description:
                                            descriptionTextController.text,
                                        job: "",
                                        rate: '',
                                        rating: ratingTextController.text,
                                        rating2: '',
                                        jobTitle: "",
                                        jobDescription: "",
                                        propertyAddress: "",
                                        nameList: subName,
                                        dateTime: DateTime.now(),
                                      );
                                      upload<ExpertModel>(
                                          expertsDocument(item.id!),
                                          item,
                                          "Item uploading is successful.",
                                          "Item uploading is failed.", () {
                                        refresh(true);
                                      });

                                      debugPrint("******Uploading...Slider");
                                    } else {
                                      final item = ExpertModel(
                                        id: newsController.selectedExpertItem
                                            .getOrElse(() => null)!
                                            .id,
                                        photolink: photoOneTextController.text,
                                        photolink2: photoTwoTextController.text,
                                        photolink3:
                                            photoThreeTextController.text,
                                        name: nameTextController.text,
                                        type: _typeController
                                            .dropDownValue?.value,
                                        description:
                                            descriptionTextController.text,
                                        job: "",
                                        rate: '',
                                        rating: ratingTextController.text,
                                        rating2: '',
                                        jobTitle: "",
                                        jobDescription: "",
                                        propertyAddress: "",
                                        nameList: subName,
                                        dateTime: newsController
                                                .selectedExpertItem
                                                .getOrElse(() => null)
                                                ?.dateTime ??
                                            DateTime.now(),
                                      );
                                      edit<ExpertModel>(
                                          expertsDocument(item.id!),
                                          item,
                                          "Item updating is successful.",
                                          "Item updating is failed.",
                                          () {});
                                      debugPrint("******Uploading...Slider");
                                    }
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Center(
                                    child: Text(
                                      newsController.selectedExpertItem
                                                  .getOrElse(() => null) ==
                                              null
                                          ? "Save"
                                          : "Update",
                                      style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
                horizontalSpace(),
                //Right Form
                //Description
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    validator: (v) => stringValidator("Description", v),
                    controller: descriptionTextController,
                    minLines: 20,
                    maxLines: 500,
                    decoration: InputDecoration(
                      border: dropDownBorder(),
                      disabledBorder: dropDownBorder(),
                      focusedBorder: dropDownBorder(),
                      enabledBorder: dropDownBorder(),
                      labelText: "Description",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
