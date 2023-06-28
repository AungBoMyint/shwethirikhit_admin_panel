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
  RxList<Category> categories = <Category>[].obs;
  RxList<TherapyVideo> therapyVideos = <TherapyVideo>[].obs;
  final debouncer = Debouncer(milliseconds: 800);
  Rxn<Query<Category>> categoryQuery = Rxn<Query<Category>>();
  Rxn<Query<TherapyVideo>> therapyVideoQuery = Rxn<Query<TherapyVideo>>();
  var categoryFetchLoading = false.obs;
  var therapyFetchLoading = false.obs;
  var categoryScrollLoading = false.obs;
  var therapyScrollLoading = false.obs;
/*   final ScrollController categoriesScrollController =
      ScrollController(initialScrollOffset: 0);
  final ScrollController therapyVideosScrollController =
      ScrollController(initialScrollOffset: 0); */

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
      getCategories(therapyCategoryQuery.where("nameList",
          arrayContains: value.toLowerCase()));
    } else {
      getCategories(therapyCategoryQuery);
    }
  }

  void startTherapyVideosSearch(String value) {
    if (value.isNotEmpty) {
      getTherapyVideo(allTherapyVideosQuery()
          .where("nameList", arrayContains: value.toLowerCase()));
    } else {
      getTherapyVideo(allTherapyVideosQuery());
    }
  }

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

  void setcategoriesSelectedAll(List<Category>? items) {
    categoriesSelectedAll.value = items == null ? false : true;
    categoriesSelectedRow.value =
        items == null ? [] : items.map((e) => e.id).toList();
  }

  void settherapyVideosSelectedAll(List<TherapyVideo>? items) {
    therapyVideosSelectedAll.value = items == null ? false : true;
    therapyVideosSelectedRow.value =
        items == null ? [] : items.map((e) => e.id).toList();
  }

  Future<void> getCategories(Query<Category> query) async {
    categoryQuery.value = query;
    categoryFetchLoading.value = true;
    final value = await query.get();
    categories.value = value.docs.map((e) => e.data()).toList();
    categoryFetchLoading.value = false;
  }

  Future<void> getTherapyVideo(Query<TherapyVideo> query) async {
    therapyVideoQuery.value = query;
    therapyFetchLoading.value = true;
    final value = await query.get();
    therapyVideos.value = value.docs.map((e) => e.data()).toList();
    therapyFetchLoading.value = false;
  }

  void setCategoryScrollController(ScrollController scroll) {
    scroll.addListener(() {
      if (scroll.position.pixels == scroll.position.maxScrollExtent) {
        if (!(categoryScrollLoading.value)) {
          categoryScrollLoading.value = true;
          debugPrint("************News Types Pagination are fetching......");
          therapyCategoryQuery
              .startAfter([categories.last.dateTime.toIso8601String()])
              .get()
              .then((value) {
                categories.addAll(value.docs.map((e) => e.data()).toList());
                categoryScrollLoading.value = false;
              })
              .onError((error, stackTrace) {
                debugPrint("$error");
              });
        }
      }
    });
  }

  void setTherapyScrollListener(ScrollController scroll) {
    scroll.addListener(() {
      if (scroll.position.pixels == scroll.position.maxScrollExtent) {
        if (!(therapyScrollLoading.value)) {
          therapyScrollLoading.value = true;
          debugPrint("************News Types Pagination are fetching......");
          allTherapyVideosQuery()
              .startAfter([categories.last.dateTime.toIso8601String()])
              .get()
              .then((value) {
                therapyVideos.addAll(value.docs.map((e) => e.data()).toList());
                therapyScrollLoading.value = false;
              })
              .onError((error, stackTrace) {
                debugPrint("$error");
              });
        }
      }
    });
  }

  Future<void> startGetCategories() async {
    if (categories.isEmpty) {
      await getCategories(therapyCategoryQuery);
    }
  }

  Future<void> startGetTherapyVideos() async {
    if (therapyVideos.isEmpty) {
      await getTherapyVideo(allTherapyVideosQuery());
    }
  }
}
