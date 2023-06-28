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

class OverviewPage extends StatefulWidget {
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
  State<OverviewPage> createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  final OverviewRelatedController orController = Get.find();

  @override
  void initState() {
    orController.getAll();
    debugPrint("*****************Overview init*******");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AdminUiController controller = Get.find();
    final AdminLoginController alController = Get.find();
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
                  widget.verticalSpace(),
                  //Container Row
                  Wrap(
                    children: [
                      Obx(
                        () {
                          final newsCategories =
                              orController.newsCategories.value!;
                          return newsCategories.fold(
                            (l) => onLoading(),
                            (r) => DataColumnRowContainer(
                              horizontalSpace: widget.horizontalSpace,
                              verticalSpace: widget.verticalSpace,
                              topImageIcon: AdminIcon.news,
                              containerBackgroundColor:
                                  alController.isLightTheme.value
                                      ? const Color(0XFFCFF466)
                                      : Colors.black,
                              topData: "News Slider",
                              titleData: "$r",
                              subTitleData: "",
                            ),
                          );
                        },
                      ),
                      Obx(
                        () {
                          final newsTypes = orController.newsTypes.value!;
                          return newsTypes.fold(
                            (l) => onLoading(),
                            (r) => DataColumnRowContainer(
                              horizontalSpace: widget.horizontalSpace,
                              verticalSpace: widget.verticalSpace,
                              topImageIcon: AdminIcon.news,
                              containerBackgroundColor:
                                  alController.isLightTheme.value
                                      ? const Color(0XFFCFF466)
                                      : Colors.black,
                              topData: "News Type",
                              titleData: "$r",
                              subTitleData: "",
                            ),
                          );
                        },
                      ),
                      Obx(
                        () {
                          final newsItems = orController.newsItems.value!;
                          return newsItems.fold(
                            (l) => onLoading(),
                            (r) => DataColumnRowContainer(
                              horizontalSpace: widget.horizontalSpace,
                              verticalSpace: widget.verticalSpace,
                              topImageIcon: AdminIcon.news,
                              containerBackgroundColor:
                                  alController.isLightTheme.value
                                      ? const Color(0XFFCFF466)
                                      : Colors.black,
                              topData: "News Items",
                              titleData: "$r",
                              subTitleData: "",
                            ),
                          );
                        },
                      ),
                      //Vlog
                      Obx(
                        () {
                          final vlogVideos = orController.vlogVideos.value!;
                          return vlogVideos.fold(
                            (l) => onLoading(),
                            (r) => DataColumnRowContainer(
                              horizontalSpace: widget.horizontalSpace,
                              verticalSpace: widget.verticalSpace,
                              topImageIcon: AdminIcon.news,
                              containerBackgroundColor:
                                  alController.isLightTheme.value
                                      ? const Color(0XFFCFF466)
                                      : Colors.black,
                              topData: "Vlog Videos",
                              titleData: "$r",
                              subTitleData: "",
                            ),
                          );
                        },
                      ),
                      //Therapy Categories
                      Obx(() {
                        final therapyCategories =
                            orController.therapyCategories.value!;
                        return therapyCategories.fold(
                          (l) => onLoading(),
                          (r) => DataColumnRowContainer(
                            horizontalSpace: widget.horizontalSpace,
                            verticalSpace: widget.verticalSpace,
                            topImageIcon: AdminIcon.news,
                            containerBackgroundColor:
                                alController.isLightTheme.value
                                    ? const Color(0XFFCFF466)
                                    : Colors.black,
                            topData: "Therapy Categories",
                            titleData: "$r",
                            subTitleData: "",
                          ),
                        );
                      }),
                      //Therapy Items
                      Obx(
                        () {
                          final therapyVideos =
                              orController.therapyVideos.value!;

                          return therapyVideos.fold(
                            (l) => onLoading(),
                            (r) => DataColumnRowContainer(
                              horizontalSpace: widget.horizontalSpace,
                              verticalSpace: widget.verticalSpace,
                              topImageIcon: AdminIcon.news,
                              containerBackgroundColor:
                                  alController.isLightTheme.value
                                      ? const Color(0XFFCFF466)
                                      : Colors.black,
                              topData: "Therapy Videos",
                              titleData: "$r",
                              subTitleData: "",
                            ),
                          );
                        },
                      ),
                      //Affirmations Categories
                      Obx(
                        () {
                          final affirmationCategories =
                              orController.affirmationsCategories.value!;
                          return affirmationCategories.fold(
                            (l) => onLoading(),
                            (r) => DataColumnRowContainer(
                              horizontalSpace: widget.horizontalSpace,
                              verticalSpace: widget.verticalSpace,
                              topImageIcon: AdminIcon.news,
                              containerBackgroundColor:
                                  alController.isLightTheme.value
                                      ? const Color(0XFFCFF466)
                                      : Colors.black,
                              topData: "Affirmations Categories",
                              titleData: "$r",
                              subTitleData: "",
                            ),
                          );
                        },
                      ),
                      //Affirmations Type
                      Obx(
                        () {
                          final affirmationTypes =
                              orController.affirmationsTypes.value!;
                          return affirmationTypes.fold(
                            (l) => onLoading(),
                            (r) => DataColumnRowContainer(
                              horizontalSpace: widget.horizontalSpace,
                              verticalSpace: widget.verticalSpace,
                              topImageIcon: AdminIcon.news,
                              containerBackgroundColor:
                                  alController.isLightTheme.value
                                      ? const Color(0XFFCFF466)
                                      : Colors.black,
                              topData: "Affirmations Type",
                              titleData: "$r",
                              subTitleData: "",
                            ),
                          );
                        },
                      ),
                      //Affirmations Items
                      Obx(
                        () {
                          final affirmationMusics =
                              orController.affirmationsMusics.value!;
                          return affirmationMusics.fold(
                            (l) => onLoading(),
                            (r) => DataColumnRowContainer(
                              horizontalSpace: widget.horizontalSpace,
                              verticalSpace: widget.verticalSpace,
                              topImageIcon: AdminIcon.news,
                              containerBackgroundColor:
                                  alController.isLightTheme.value
                                      ? const Color(0XFFCFF466)
                                      : Colors.black,
                              topData: "Affirmations Music",
                              titleData: "$r",
                              subTitleData: "",
                            ),
                          );
                        },
                      ),
                      //Users
                      Obx(
                        () {
                          final users = orController.users.value!;
                          return users.fold(
                            (l) => onLoading(),
                            (r) => DataColumnRowContainer(
                              horizontalSpace: widget.horizontalSpace,
                              verticalSpace: widget.verticalSpace,
                              topImageIcon: AdminIcon.news,
                              containerBackgroundColor:
                                  alController.isLightTheme.value
                                      ? const Color(0XFFCFF466)
                                      : Colors.black,
                              topData: "Total Users",
                              titleData: "$r O",
                              subTitleData: "",
                            ),
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
