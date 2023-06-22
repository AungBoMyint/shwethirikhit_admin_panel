import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:get/get.dart';
import 'package:pizza/models/object_models/music.dart';
import '../../models/object_models/category.dart';
import '../../models/object_models/expert.dart';
import '../../models/object_models/type.dart';
import '../../service/query.dart';
import '../utils/debouncer.dart';

class AffirmationsController extends GetxController {
  //Left refer to View
  //Right refer to Upload,Update
  Rxn<Query<Category>> sliderQuery =
      Rxn<Query<Category>>(affirmationsCategoryQuery);
  Rxn<Query<ItemType>> typeQuery = Rxn<Query<ItemType>>(affirmationsTypeQuery);
  Rxn<Query<Music>> itemsQuery =
      Rxn<Query<Music>>(allAffirmationsMusicsQuery());
  final debouncer = Debouncer(milliseconds: 800);
  FirestoreQueryBuilderSnapshot<Category>? sliderSnapshot;
  FirestoreQueryBuilderSnapshot<ItemType>? typeSnapshot;
  FirestoreQueryBuilderSnapshot<Music>? itemsSnapshot;

  final ScrollController sliderScrollController =
      ScrollController(initialScrollOffset: 0);
  final ScrollController typeScrollController =
      ScrollController(initialScrollOffset: 0);
  final ScrollController itemScrollController =
      ScrollController(initialScrollOffset: 0);

  RxList<String> sliderSelectedRow = <String>[].obs;
  RxList<String> typeSelectedRow = <String>[].obs;
  RxList<String> itemsSelectedRow = <String>[].obs;
  var sliderSelectedAll = false.obs;
  var typeSelectedAll = false.obs;
  var itemsSelectedAll = false.obs;

  void startSliderSearch(String value) {
    if (value.isNotEmpty) {
      sliderQuery.value = affirmationsCategoryQuery.where("nameList",
          arrayContains: value.toLowerCase());
    } else {
      sliderQuery.value = affirmationsCategoryQuery;
    }
  }

  void startTypeSearch(String value) {
    if (value.isNotEmpty) {
      typeQuery.value = affirmationsTypeQuery.where("nameList",
          arrayContains: value.toLowerCase());
    } else {
      typeQuery.value = affirmationsTypeQuery;
    }
  }

  void startItemSearch(String value) {
    if (value.isNotEmpty) {
      itemsQuery.value = allAffirmationsMusicsQuery()
          .where("nameList", arrayContains: value.toLowerCase());
    } else {
      itemsQuery.value = allAffirmationsMusicsQuery();
    }
  }

  void setSliderSnapshot(FirestoreQueryBuilderSnapshot<Category> v) =>
      sliderSnapshot = v;
  void setTypeSnapshot(FirestoreQueryBuilderSnapshot<ItemType> v) =>
      typeSnapshot = v;
  void setItemsSnapshot(FirestoreQueryBuilderSnapshot<Music> v) =>
      itemsSnapshot = v;

  void setSliderSelectedRow(Category item) {
    if (sliderSelectedRow.contains(item.id)) {
      sliderSelectedRow.remove(item.id);
    } else {
      sliderSelectedRow.add(item.id);
    }
  }

  void setTypeSelectedRow(ItemType item) {
    if (typeSelectedRow.contains(item.id)) {
      typeSelectedRow.remove(item.id);
    } else {
      typeSelectedRow.add(item.id);
    }
  }

  void setItemsSelectedRow(Music item) {
    if (itemsSelectedRow.contains(item.id)) {
      itemsSelectedRow.remove(item.id);
    } else {
      itemsSelectedRow.add(item.id);
    }
  }

  void setSliderSelectedAll(List<QueryDocumentSnapshot<Category>>? items) {
    sliderSelectedAll.value = items == null ? false : true;
    sliderSelectedRow.value =
        items == null ? [] : items.map((e) => e.data().id).toList();
  }

  void setTypeSelectedAll(List<QueryDocumentSnapshot<ItemType>>? items) {
    typeSelectedAll.value = items == null ? false : true;
    typeSelectedRow.value =
        items == null ? [] : items.map((e) => e.data().id).toList();
  }

  void setItemsSelectedAll(List<QueryDocumentSnapshot<Music>>? items) {
    itemsSelectedAll.value = items == null ? false : true;
    itemsSelectedRow.value =
        items == null ? [] : items.map((e) => e.data().id).toList();
  }

  @override
  void onInit() {
    sliderScrollController.addListener(() {
      if (sliderScrollController.position.pixels ==
          sliderScrollController.position.maxScrollExtent) {
        if (!(sliderSnapshot == null) && sliderSnapshot!.hasMore) {
          sliderSnapshot!.fetchMore();
        }
      }
    });
    typeScrollController.addListener(() {
      if (typeScrollController.position.pixels ==
          typeScrollController.position.maxScrollExtent) {
        if (!(typeSnapshot == null) && typeSnapshot!.hasMore) {
          typeSnapshot!.fetchMore();
        }
      }
    });
    itemScrollController.addListener(() {
      if (itemScrollController.position.pixels ==
          itemScrollController.position.maxScrollExtent) {
        if (!(itemsSnapshot == null) && itemsSnapshot!.hasMore) {
          itemsSnapshot!.fetchMore();
        }
      }
    });
    super.onInit();
  }
}
