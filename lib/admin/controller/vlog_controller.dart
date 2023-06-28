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
  RxList<VlogVideo> vlogVideos = <VlogVideo>[].obs;
  final debouncer = Debouncer(milliseconds: 800);
  var videoDuration = "".obs;
  Rxn<Query<VlogVideo>> vlogQuery = Rxn<Query<VlogVideo>>();
  var scrollLoading = false.obs;
  var vlogVideoFetching = false.obs;

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
      getVlogVideos(
          vlogVideoQuery.where("nameList", arrayContains: value.toLowerCase()));
    } else {
      getVlogVideos(vlogVideoQuery);
    }
  }

  void setSelectedRow(VlogVideo item) {
    if (selectedRow.contains(item.id)) {
      selectedRow.remove(item.id);
    } else {
      selectedRow.add(item.id);
    }
  }

  void setSelectedAll(List<VlogVideo>? items) {
    selectedAll.value = items == null ? false : true;
    selectedRow.value = items == null ? [] : items.map((e) => e.id).toList();
  }

  void setScrollListener(ScrollController scroll) {
    scroll.addListener(() {
      if (scroll.position.pixels == scroll.position.maxScrollExtent) {
        if (!(scrollLoading.value)) {
          scrollLoading.value = true;
          debugPrint("************News Types Pagination are fetching......");
          vlogVideoQuery
              .startAfter([vlogVideos.last.dateTime.toIso8601String()])
              .get()
              .then((value) {
                vlogVideos.addAll(value.docs.map((e) => e.data()).toList());
                scrollLoading.value = false;
              })
              .onError((error, stackTrace) {
                debugPrint("$error");
              });
        }
      }
    });
  }

  Future<void> startGetVlog() async {
    if (vlogVideos.isEmpty) {
      await getVlogVideos(vlogVideoQuery);
    }
  }

  Future<void> getVlogVideos(Query<VlogVideo> query) async {
    vlogQuery.value = query;
    vlogVideoFetching.value = true;
    final value = await query.get();
    vlogVideos.value = value.docs.map((e) => e.data()).toList();
    vlogVideoFetching.value = false;
  }
}
