import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:get/get.dart';
import 'package:pizza/models/object_models/vlog_video.dart';
import 'package:pizza/service/reference.dart';
import 'package:video_player/video_player.dart';
import '../../service/query.dart';
import '../utils/debouncer.dart';

class VlogController extends GetxController {
  //Left refer to View
  //Right refer to Upload,Update
  Rxn<Query<VlogVideo>> vlogQuery = Rxn<Query<VlogVideo>>(vlogVideoQuery);
  final debouncer = Debouncer(milliseconds: 800);
  var videoDuration = "".obs;
  FirestoreQueryBuilderSnapshot<VlogVideo>? vlogSnapshot;

  final ScrollController scrollController =
      ScrollController(initialScrollOffset: 0);

  RxList<String> selectedRow = <String>[].obs;

  var selectedAll = false.obs;

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

  void startVlogSearch(String value) {
    if (value.isNotEmpty) {
      vlogQuery.value = vlogVideoCollection().where(
        "nameList",
        arrayContains: value.toLowerCase(),
      );
    } else {
      vlogQuery.value = vlogVideoQuery;
    }
  }

  void setVlogSnapshot(FirestoreQueryBuilderSnapshot<VlogVideo> v) =>
      vlogSnapshot = v;

  void setSelectedRow(VlogVideo item) {
    if (selectedRow.contains(item.id)) {
      selectedRow.remove(item.id);
    } else {
      selectedRow.add(item.id);
    }
  }

  void setSelectedAll(List<QueryDocumentSnapshot<VlogVideo>>? items) {
    selectedAll.value = items == null ? false : true;
    selectedRow.value =
        items == null ? [] : items.map((e) => e.data().id).toList();
  }

  @override
  void onInit() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (!(vlogSnapshot == null) && vlogSnapshot!.hasMore) {
          vlogSnapshot!.fetchMore();
        }
      }
    });
    super.onInit();
  }
}
