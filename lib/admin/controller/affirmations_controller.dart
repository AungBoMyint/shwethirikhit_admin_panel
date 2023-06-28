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
  RxList<Category> categories = <Category>[].obs;
  RxList<ItemType> types = <ItemType>[].obs;
  RxList<Music> musics = <Music>[].obs;
  Rxn<Query<Category>> categoryQuery = Rxn<Query<Category>>();
  Rxn<Query<ItemType>> typeQuery = Rxn<Query<ItemType>>();
  Rxn<Query<Music>> musicQuery = Rxn<Query<Music>>();
  final debouncer = Debouncer(milliseconds: 800);

/*   final ScrollController sliderScrollController =
      ScrollController(initialScrollOffset: 0);
  final ScrollController typeScrollController =
      ScrollController(initialScrollOffset: 0);
  final ScrollController itemScrollController =
      ScrollController(initialScrollOffset: 0); */

  RxList<String> sliderSelectedRow = <String>[].obs;
  RxList<String> typeSelectedRow = <String>[].obs;
  RxList<String> itemsSelectedRow = <String>[].obs;
  var sliderSelectedAll = false.obs;
  var typeSelectedAll = false.obs;
  var itemsSelectedAll = false.obs;

  var categoryScrollLoading = false.obs;
  var typeScrollLoading = false.obs;
  var itemsScrollLoading = false.obs;
  var categoryFetchLoading = false.obs;
  var typeFetchLoading = false.obs;
  var itemsFetchLoading = false.obs;

  void startSliderSearch(String value) {
    if (value.isNotEmpty) {
      getCategories(affirmationsCategoryQuery.where("nameList",
          arrayContains: value.toLowerCase()));
    } else {
      getCategories(affirmationsCategoryQuery);
    }
  }

  void startTypeSearch(String value) {
    if (value.isNotEmpty) {
      getTypes(affirmationsTypeQuery.where("nameList",
          arrayContains: value.toLowerCase()));
    } else {
      getTypes(affirmationsTypeQuery);
    }
  }

  void startItemSearch(String value) {
    if (value.isNotEmpty) {
      getItems(allAffirmationsMusicsQuery()
          .where("nameList", arrayContains: value.toLowerCase()));
    } else {
      getItems(allAffirmationsMusicsQuery());
    }
  }

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

  void setSliderSelectedAll(List<Category>? items) {
    sliderSelectedAll.value = items == null ? false : true;
    sliderSelectedRow.value =
        items == null ? [] : items.map((e) => e.id).toList();
  }

  void setTypeSelectedAll(List<ItemType>? items) {
    typeSelectedAll.value = items == null ? false : true;
    typeSelectedRow.value =
        items == null ? [] : items.map((e) => e.id).toList();
  }

  void setItemsSelectedAll(List<Music>? items) {
    itemsSelectedAll.value = items == null ? false : true;
    itemsSelectedRow.value =
        items == null ? [] : items.map((e) => e.id).toList();
  }

  void setCategoryScrollController(ScrollController scrollController) {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (!(categoryScrollLoading.value)) {
          categoryScrollLoading.value = true;

          affirmationsCategoryQuery
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

  void setTypeScrollControllerListener(ScrollController scroll) {
    scroll.addListener(() {
      if (scroll.position.pixels == scroll.position.maxScrollExtent) {
        if (!(typeScrollLoading.value)) {
          typeScrollLoading.value = true;
          debugPrint("************News Types Pagination are fetching......");
          affirmationsTypeQuery
              .startAfter([types.last.dateTime.toIso8601String()])
              .get()
              .then((value) {
                types.addAll(value.docs.map((e) => e.data()).toList());
                typeScrollLoading.value = false;
              })
              .onError((error, stackTrace) {
                debugPrint("$error");
              });
        }
      }
    });
  }

  void setItemScrollControllerListener(ScrollController scroll) {
    scroll.addListener(() {
      if (scroll.position.pixels == scroll.position.maxScrollExtent) {
        if (!(itemsScrollLoading.value)) {
          itemsScrollLoading.value = true;
          debugPrint("************ExpertModels Pagination are fetching......");
          allAffirmationsMusicsQuery()
              .startAfter([musics.last.dateTime.toIso8601String()])
              .get()
              .then((value) {
                musics.addAll(value.docs.map((e) => e.data()).toList());
                itemsScrollLoading.value = false;
              })
              .onError((error, stackTrace) {
                debugPrint("$error");
              });
        }
      }
    });
  }

  Future<void> getCategories(Query<Category> query) async {
    categoryQuery.value = query;
    categoryFetchLoading.value = true;
    final value = await query.get();
    categories.value = value.docs.map((e) => e.data()).toList();
    categoryFetchLoading.value = false;
  }

  Future<void> getTypes(Query<ItemType> query) async {
    typeQuery.value = query;
    typeFetchLoading.value = true;
    final value = await query.get();
    types.value = value.docs.map((e) => e.data()).toList();
    typeFetchLoading.value = false;
  }

  Future<void> getItems(Query<Music> query) async {
    musicQuery.value = query;
    itemsFetchLoading.value = true;
    final value = await query.get();
    musics.value = value.docs.map((e) => e.data()).toList();
    itemsFetchLoading.value = false;
  }

  Future<void> startGetCategories() async {
    if (categories.isEmpty) {
      await getCategories(affirmationsCategoryQuery);
    }
  }

  Future<void> startGetTypes() async {
    if (types.isEmpty) {
      await getTypes(affirmationsTypeQuery);
    }
  }

  Future<void> startGetItems() async {
    if (musics.isEmpty) {
      await getItems(allAffirmationsMusicsQuery());
    }
  }
}
