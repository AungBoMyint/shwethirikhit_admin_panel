import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/object_models/category.dart' as app;
import '../../models/object_models/expert.dart';
import '../../models/object_models/type.dart';
import '../../service/query.dart';
import '../utils/debouncer.dart';
import '../utils/show_loading.dart';

class NewsController extends GetxController {
  Either<ExpertModel, ExpertModel?> selectedExpertItem = right(null);
  //Left refer to View
  //Right refer to Upload,Update
  RxList<app.Category> sliderCategories = <app.Category>[].obs;
  RxList<ItemType> types = <ItemType>[].obs;
  RxList<ExpertModel> expertModels = <ExpertModel>[].obs;
  RxList<app.Category> searchSliderCategories = <app.Category>[].obs;
  RxList<ItemType> searchTypes = <ItemType>[].obs;
  RxList<ExpertModel> searchExpertModels = <ExpertModel>[].obs;
  Rxn<Query<app.Category>> sliderQuery = Rxn<Query<app.Category>>();
  Rxn<Query<ItemType>> typeQuery = Rxn<Query<ItemType>>();
  Rxn<Query<ExpertModel>> itemsQuery = Rxn<Query<ExpertModel>>();
  final debouncer = Debouncer(milliseconds: 800);
  /* FirestoreQueryBuilderSnapshot<Category>? sliderSnapshot;
  FirestoreQueryBuilderSnapshot<ItemType>? typeSnapshot;
  FirestoreQueryBuilderSnapshot<ExpertModel>? itemsSnapshot; */

  var sliderScrollLoading = false.obs;
  var typeScrollLoading = false.obs;
  var itemsScrollLoading = false.obs;
  var sliderFetchLoading = false.obs;
  var typeFetchLoading = false.obs;
  var itemsFetchLoading = false.obs;

  RxList<String> sliderSelectedRow = <String>[].obs;
  RxList<String> typeSelectedRow = <String>[].obs;
  RxList<String> itemsSelectedRow = <String>[].obs;
  var sliderSelectedAll = false.obs;
  var typeSelectedAll = false.obs;
  var itemsSelectedAll = false.obs;

  void setSelectedExpertItem(Either<ExpertModel, ExpertModel?> item) =>
      selectedExpertItem = item;

  void startSliderSearch(String value) {
    if (value.isNotEmpty) {
      getCategories(homeCategoryQuery.where("nameList",
          arrayContains: value.toLowerCase()));
    } else {
      getCategories(homeCategoryQuery);
    }
  }

  void startTypeSearch(String value) {
    if (value.isNotEmpty) {
      getTypes(
          homeTypeQuery.where("nameList", arrayContains: value.toLowerCase()));
    } else {
      getTypes(homeTypeQuery);
    }
  }

  void startItemSearch(String value) {
    if (value.isNotEmpty) {
      getItems(allExpertQuery()
          .where("nameList", arrayContains: value.toLowerCase()));
    } else {
      getItems(allExpertQuery());
    }
  }

  void setSliderSelectedRow(app.Category item) {
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

  void setItemsSelectedRow(ExpertModel item) {
    if (itemsSelectedRow.contains(item.id)) {
      itemsSelectedRow.remove(item.id);
    } else {
      itemsSelectedRow.add(item.id!);
    }
  }

  void setSliderSelectedAll(List<app.Category>? value) {
    sliderSelectedAll.value = value == null ? false : true;
    sliderSelectedRow.value =
        value == null ? [] : value.map((e) => e.id).toList();
  }

  void setTypeSelectedAll(List<ItemType>? items) {
    typeSelectedAll.value = items == null ? false : true;
    typeSelectedRow.value =
        items == null ? [] : items.map((e) => e.id).toList();
  }

  void setItemsSelectedAll(List<ExpertModel>? items) {
    itemsSelectedAll.value = items == null ? false : true;
    itemsSelectedRow.value =
        items == null ? [] : items.map((e) => e.id!).toList();
  }

  Future<void> getCategories(Query<app.Category> query) async {
    sliderQuery.value = query;
    sliderFetchLoading.value = true;
    final value = await query.get();
    sliderCategories.value = value.docs.map((e) => e.data()).toList();
    sliderFetchLoading.value = false;
  }

  Future<void> getTypes(Query<ItemType> query) async {
    typeQuery.value = query;
    typeFetchLoading.value = true;
    final value = await query.get();
    types.value = value.docs.map((e) => e.data()).toList();
    typeFetchLoading.value = false;
  }

  Future<void> getItems(Query<ExpertModel> query) async {
    itemsQuery.value = query;
    itemsFetchLoading.value = true;
    final value = await query.get();
    expertModels.value = value.docs.map((e) => e.data()).toList();
    itemsFetchLoading.value = false;
  }

  void setSliderScrollControllerListener(ScrollController scrollController) {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (!(sliderScrollLoading.value)) {
          sliderScrollLoading.value = true;
          debugPrint(
              "************Slider Categories Pagination are fetching......");
          homeCategoryQuery
              .startAfter([sliderCategories.last.dateTime.toIso8601String()])
              .get()
              .then((value) {
                sliderCategories
                    .addAll(value.docs.map((e) => e.data()).toList());
                sliderScrollLoading.value = false;
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
          homeTypeQuery
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
          allExpertQuery()
              .startAfter([
                expertModels.last.name,
                expertModels.last.dateTime /* ?.toIso8601String() */
              ])
              .get()
              .then((value) {
                expertModels.addAll(value.docs.map((e) => e.data()).toList());
                itemsScrollLoading.value = false;
              })
              .onError((error, stackTrace) {
                debugPrint("$error");
              });
        }
      }
    });
  }

  Future<void> startGetCategories() async {
    if (sliderCategories.isEmpty) {
      await getCategories(homeCategoryQuery);
    }
  }

  Future<void> startGetTypes() async {
    if (types.isEmpty) {
      await getTypes(homeTypeQuery);
    }
  }

  Future<void> deleteAllTestItems() async {
    showLoading(Get.context!);
    await Future.delayed(Duration(milliseconds: 100));
    try {
      Query<Map<String, dynamic>> users = FirebaseFirestore.instance
          .collection('experts')
          .where("description", isEqualTo: "description");

      WriteBatch batch = FirebaseFirestore.instance.batch();

      users.get().then((querySnapshot) {
        querySnapshot.docs.forEach((document) {
          batch.delete(document.reference);
        });

        return batch.commit();
      });
      hideLoading(Get.context!);
    } catch (e) {
      hideLoading(Get.context!);
      Get.snackbar("Error Deleting Batch", "$e",
          duration: Duration(minutes: 1));
    }
  }

  Future<void> startGetItems() async {
    if (expertModels.isEmpty) {
      await getItems(allExpertQuery());
    }
  }
}
