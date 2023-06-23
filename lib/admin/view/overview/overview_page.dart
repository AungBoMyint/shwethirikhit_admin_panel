import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pizza/admin/utils/widgets.dart';
import 'package:pizza/constant/collection_name.dart';
import 'package:pizza/core/firebase_reference.dart';
import 'package:pizza/models/auth_user.dart';
import 'package:pizza/models/object_models/category.dart';
import 'package:pizza/models/object_models/expert.dart';
import 'package:pizza/models/object_models/music.dart';
import 'package:pizza/models/object_models/therapy_video.dart';
import 'package:pizza/models/object_models/type.dart';
import 'package:pizza/models/object_models/vlog_video.dart';
import 'package:pizza/service/query.dart';
import 'package:pizza/service/reference.dart';

import '../../../constant/icon.dart';
import '../../../models/rbpoint.dart';
import '../../controller/admin_login_controller.dart';
import '../../controller/admin_ui_controller.dart';
import '../../controller/overview_related_controller.dart';
import '../../widgets/datacolumn_rowcontainer.dart';
import '../../widgets/overview/onloading.dart';

class OverviewPage extends GetView<AdminUiController> {
  const OverviewPage({
    super.key,
    required this.verticalSpace,
    required this.horizontalSpace,
    required this.girlNetworkImage,
    required this.textTheme,
  });

  final SizedBox Function({double? v}) verticalSpace;
  final SizedBox Function({double? v}) horizontalSpace;
  final String girlNetworkImage;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    final AdminLoginController alController = Get.find();
    final OverviewRelatedController orController = Get.find();
    final textTheme = Theme.of(context).textTheme;
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      debugPrint("*******Overview Width: $width");
      return SizedBox(
        width: width,
        child: Card(
          color: Theme.of(context).cardTheme.color,
          //padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text(
                      "Here's what's happening with your app today.",
                      style: textTheme.displayMedium?.copyWith(
                        fontSize: controller.rbPoint.value!
                            .getOrElse(() => RBPoint.xl())
                            .map(
                                xl: (_) => 25,
                                desktop: (_) => 22,
                                tablet: (_) => 18,
                                mobile: (_) => 16),
                        color: !alController.isLightTheme.value
                            ? Colors.grey.shade50
                            : Colors.grey.shade700,
                      ),
                    ),
                  ),
                  verticalSpace(),
                  //Container Row
                  Wrap(
                    children: [
                      FirebaseSnapHelper<QuerySnapshot<Category>>(
                        future: categoryCollection().get(),
                        onLoading: () => onLoading(),
                        onSuccess: (snap) {
                          return DataColumnRowContainer(
                            horizontalSpace: horizontalSpace,
                            verticalSpace: verticalSpace,
                            topImageIcon: AdminIcon.news,
                            containerBackgroundColor:
                                alController.isLightTheme.value
                                    ? const Color(0XFFCFF466)
                                    : Colors.black,
                            topData: "News Slider",
                            titleData: "${snap.docs.length}",
                            subTitleData: "",
                          );
                        },
                      ),
                      FirebaseSnapHelper<QuerySnapshot<ItemType>>(
                        future: homeTypeCollection().get(),
                        onLoading: () => onLoading(),
                        onSuccess: (snap) {
                          return DataColumnRowContainer(
                            horizontalSpace: horizontalSpace,
                            verticalSpace: verticalSpace,
                            topImageIcon: AdminIcon.news,
                            containerBackgroundColor:
                                alController.isLightTheme.value
                                    ? const Color(0XFFCFF466)
                                    : Colors.black,
                            topData: "News Type",
                            titleData: "${snap.docs.length}",
                            subTitleData: "",
                          );
                        },
                      ),
                      FirebaseSnapHelper<QuerySnapshot<ExpertModel>>(
                        future: allExpertQuery().get(),
                        onLoading: () => onLoading(),
                        onSuccess: (snap) {
                          return DataColumnRowContainer(
                            horizontalSpace: horizontalSpace,
                            verticalSpace: verticalSpace,
                            topImageIcon: AdminIcon.news,
                            containerBackgroundColor:
                                alController.isLightTheme.value
                                    ? const Color(0XFFCFF466)
                                    : Colors.black,
                            topData: "News Items",
                            titleData: "${snap.docs.length}",
                            subTitleData: "",
                          );
                        },
                      ),
                      //Vlog
                      FirebaseSnapHelper<QuerySnapshot<VlogVideo>>(
                        future: vlogVideoCollection().get(),
                        onLoading: () => onLoading(),
                        onSuccess: (snap) {
                          return DataColumnRowContainer(
                            horizontalSpace: horizontalSpace,
                            verticalSpace: verticalSpace,
                            topImageIcon: AdminIcon.news,
                            containerBackgroundColor:
                                alController.isLightTheme.value
                                    ? const Color(0XFFCFF466)
                                    : Colors.black,
                            topData: "Vlog Videos",
                            titleData: "${snap.docs.length}",
                            subTitleData: "",
                          );
                        },
                      ),
                      //Therapy Categories
                      FirebaseSnapHelper<QuerySnapshot<Category>>(
                        future: therapyCategoryCollection().get(),
                        onLoading: () => onLoading(),
                        onSuccess: (snap) {
                          return DataColumnRowContainer(
                            horizontalSpace: horizontalSpace,
                            verticalSpace: verticalSpace,
                            topImageIcon: AdminIcon.news,
                            containerBackgroundColor:
                                alController.isLightTheme.value
                                    ? const Color(0XFFCFF466)
                                    : Colors.black,
                            topData: "Therapy Categories",
                            titleData: "${snap.docs.length}",
                            subTitleData: "",
                          );
                        },
                      ),
                      //Therapy Items
                      FirebaseSnapHelper<QuerySnapshot<TherapyVideo>>(
                        future: therapyVideoCollection().get(),
                        onLoading: () => onLoading(),
                        onSuccess: (snap) {
                          return DataColumnRowContainer(
                            horizontalSpace: horizontalSpace,
                            verticalSpace: verticalSpace,
                            topImageIcon: AdminIcon.news,
                            containerBackgroundColor:
                                alController.isLightTheme.value
                                    ? const Color(0XFFCFF466)
                                    : Colors.black,
                            topData: "Therapy Videos",
                            titleData: "${snap.docs.length}",
                            subTitleData: "",
                          );
                        },
                      ),
                      //Affirmations Categories
                      FirebaseSnapHelper<QuerySnapshot<Category>>(
                        future: affirmationsCategoryCollection().get(),
                        onLoading: () => onLoading(),
                        onSuccess: (snap) {
                          return DataColumnRowContainer(
                            horizontalSpace: horizontalSpace,
                            verticalSpace: verticalSpace,
                            topImageIcon: AdminIcon.news,
                            containerBackgroundColor:
                                alController.isLightTheme.value
                                    ? const Color(0XFFCFF466)
                                    : Colors.black,
                            topData: "Affirmations Categories",
                            titleData: "${snap.docs.length}",
                            subTitleData: "",
                          );
                        },
                      ),
                      //Affirmations Type
                      FirebaseSnapHelper<QuerySnapshot<ItemType>>(
                        future: affirmationsTypeCollection().get(),
                        onLoading: () => onLoading(),
                        onSuccess: (snap) {
                          return DataColumnRowContainer(
                            horizontalSpace: horizontalSpace,
                            verticalSpace: verticalSpace,
                            topImageIcon: AdminIcon.news,
                            containerBackgroundColor:
                                alController.isLightTheme.value
                                    ? const Color(0XFFCFF466)
                                    : Colors.black,
                            topData: "Affirmations Type",
                            titleData: "${snap.docs.length}",
                            subTitleData: "",
                          );
                        },
                      ),
                      //Affirmations Items
                      FirebaseSnapHelper<QuerySnapshot<Music>>(
                        future: allAffirmationsMusicsQuery().get(),
                        onLoading: () => onLoading(),
                        onSuccess: (snap) {
                          return DataColumnRowContainer(
                            horizontalSpace: horizontalSpace,
                            verticalSpace: verticalSpace,
                            topImageIcon: AdminIcon.news,
                            containerBackgroundColor:
                                alController.isLightTheme.value
                                    ? const Color(0XFFCFF466)
                                    : Colors.black,
                            topData: "Affirmations Music",
                            titleData: "${snap.docs.length}",
                            subTitleData: "",
                          );
                        },
                      ),
                      //Users
                      FirebaseSnapHelper<QuerySnapshot<AuthUser>>(
                        future: userCollectionReference().get(),
                        onLoading: () => onLoading(),
                        onSuccess: (snap) {
                          return DataColumnRowContainer(
                            horizontalSpace: horizontalSpace,
                            verticalSpace: verticalSpace,
                            topImageIcon: AdminIcon.news,
                            containerBackgroundColor:
                                alController.isLightTheme.value
                                    ? const Color(0XFFCFF466)
                                    : Colors.black,
                            topData: "Total Users",
                            titleData: "${snap.docs.length}",
                            subTitleData: "",
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
