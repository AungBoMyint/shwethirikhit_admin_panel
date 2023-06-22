import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:get/get.dart';
import 'package:pizza/models/object_models/therapy_video.dart';
import 'package:video_player/video_player.dart';
import '../../models/object_models/category.dart';
import '../../models/object_models/expert.dart';
import '../../models/object_models/type.dart';
import '../../service/query.dart';
import '../utils/debouncer.dart';

class TherapyController extends GetxController {
  //Left refer to View
  //Right refer to Upload,Update
  var videoDuration = "".obs;
  Rxn<Query<Category>> categoriesQuery =
      Rxn<Query<Category>>(therapyCategoryQuery);
  Rxn<Query<TherapyVideo>> therapyVideoQuery =
      Rxn<Query<TherapyVideo>>(allTherapyVideosQuery());
  final debouncer = Debouncer(milliseconds: 800);
  FirestoreQueryBuilderSnapshot<Category>? categoriesSnapshot;
  FirestoreQueryBuilderSnapshot<TherapyVideo>? therapyVideosSnapshot;

  final ScrollController categoriesScrollController =
      ScrollController(initialScrollOffset: 0);
  final ScrollController therapyVideosScrollController =
      ScrollController(initialScrollOffset: 0);

  RxList<String> categoriesSelectedRow = <String>[].obs;
  RxList<String> therapyVideosSelectedRow = <String>[].obs;
  var categoriesSelectedAll = false.obs;
  var therapyVideosSelectedAll = false.obs;

  void startVideoDurationExtraction(String url) {
    try {
      videoDuration.value = "video minutes are processing.";
      VideoPlayerController _controller = VideoPlayerController.network(url);
      _controller.initialize().then((value) =>
          videoDuration.value = "${_controller.value.duration.inMinutes}");
    } catch (e) {
      videoDuration.value = "";
    }
  }

  void startCategoriesSearch(String value) {
    if (value.isNotEmpty) {
      categoriesQuery.value = therapyCategoryQuery.where("nameList",
          arrayContains: value.toLowerCase());
    } else {
      categoriesQuery.value = therapyCategoryQuery;
    }
  }

  void startTherapyVideosSearch(String value) {
    if (value.isNotEmpty) {
      therapyVideoQuery.value = allTherapyVideosQuery()
          .where("nameList", arrayContains: value.toLowerCase());
    } else {
      therapyVideoQuery.value = allTherapyVideosQuery();
    }
  }

  void setcategoriesSnapshot(FirestoreQueryBuilderSnapshot<Category> v) =>
      categoriesSnapshot = v;

  void settherapyVideosSnapshot(
          FirestoreQueryBuilderSnapshot<TherapyVideo> v) =>
      therapyVideosSnapshot = v;

  void setcategoriesSelectedRow(Category item) {
    if (categoriesSelectedRow.contains(item.id)) {
      categoriesSelectedRow.remove(item.id);
    } else {
      categoriesSelectedRow.add(item.id);
    }
  }

  void settherapyVideosSelectedRow(TherapyVideo item) {
    if (therapyVideosSelectedRow.contains(item.id)) {
      therapyVideosSelectedRow.remove(item.id);
    } else {
      therapyVideosSelectedRow.add(item.id);
    }
  }

  void setcategoriesSelectedAll(List<QueryDocumentSnapshot<Category>>? items) {
    categoriesSelectedAll.value = items == null ? false : true;
    categoriesSelectedRow.value =
        items == null ? [] : items.map((e) => e.data().id).toList();
  }

  void settherapyVideosSelectedAll(
      List<QueryDocumentSnapshot<TherapyVideo>>? items) {
    therapyVideosSelectedAll.value = items == null ? false : true;
    therapyVideosSelectedRow.value =
        items == null ? [] : items.map((e) => e.data().id).toList();
  }

  @override
  void onInit() {
    categoriesScrollController.addListener(() {
      if (categoriesScrollController.position.pixels ==
          categoriesScrollController.position.maxScrollExtent) {
        if (!(categoriesSnapshot == null) && categoriesSnapshot!.hasMore) {
          categoriesSnapshot!.fetchMore();
        }
      }
    });
    therapyVideosScrollController.addListener(() {
      if (therapyVideosScrollController.position.pixels ==
          therapyVideosScrollController.position.maxScrollExtent) {
        if (!(therapyVideosSnapshot == null) &&
            therapyVideosSnapshot!.hasMore) {
          therapyVideosSnapshot!.fetchMore();
        }
      }
    });

    super.onInit();
  }
}
