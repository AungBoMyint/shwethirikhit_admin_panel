import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pizza/admin/utils/show_loading.dart';
import 'package:pizza/service/database.dart';

import '../../models/object_models/category.dart';
import '../../models/object_models/expert.dart';
import '../../models/object_models/type.dart';
import '../../service/query.dart';
import '../utils/debouncer.dart';

class NewsController extends GetxController {
  Either<ExpertModel, ExpertModel?> selectedExpertItem = right(null);
  //Left refer to View
  //Right refer to Upload,Update
  Rxn<Query<Category>> sliderQuery = Rxn<Query<Category>>(homeCategoryQuery);
  Rxn<Query<ItemType>> typeQuery = Rxn<Query<ItemType>>(homeTypeQuery);
  Rxn<Query<ExpertModel>> itemsQuery =
      Rxn<Query<ExpertModel>>(allExpertQuery());
  final debouncer = Debouncer(milliseconds: 800);
  FirestoreQueryBuilderSnapshot<Category>? sliderSnapshot;
  FirestoreQueryBuilderSnapshot<ItemType>? typeSnapshot;
  FirestoreQueryBuilderSnapshot<ExpertModel>? itemsSnapshot;

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

  void setSelectedExpertItem(Either<ExpertModel, ExpertModel?> item) =>
      selectedExpertItem = item;

  void startSliderSearch(String value) {
    if (value.isNotEmpty) {
      sliderQuery.value = homeCategoryQuery.where("nameList",
          arrayContains: value.toLowerCase());
    } else {
      sliderQuery.value = homeCategoryQuery;
    }
  }

  void startTypeSearch(String value) {
    if (value.isNotEmpty) {
      typeQuery.value =
          homeTypeQuery.where("nameList", arrayContains: value.toLowerCase());
    } else {
      typeQuery.value = homeTypeQuery;
    }
  }

  void startItemSearch(String value) {
    if (value.isNotEmpty) {
      itemsQuery.value = allExpertQuery()
          .where("nameList", arrayContains: value.toLowerCase());
    } else {
      itemsQuery.value = allExpertQuery();
    }
  }

  void setSliderSnapshot(FirestoreQueryBuilderSnapshot<Category> v) =>
      sliderSnapshot = v;
  void setTypeSnapshot(FirestoreQueryBuilderSnapshot<ItemType> v) =>
      typeSnapshot = v;
  void setItemsSnapshot(FirestoreQueryBuilderSnapshot<ExpertModel> v) =>
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

  void setItemsSelectedRow(ExpertModel item) {
    if (itemsSelectedRow.contains(item.id)) {
      itemsSelectedRow.remove(item.id);
    } else {
      itemsSelectedRow.add(item.id!);
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

  void setItemsSelectedAll(List<QueryDocumentSnapshot<ExpertModel>>? items) {
    itemsSelectedAll.value = items == null ? false : true;
    itemsSelectedRow.value =
        items == null ? [] : items.map((e) => e.data().id!).toList();
  }

  void deleteItems<T>(List<String> idList, CollectionReference<T> reference) {
    if (idList.isNotEmpty) {
      deleteItemsWithBatch(idList, reference);
    }
  }

  Future<void> deleteItemsWithBatch<T>(
      List<String> idList, CollectionReference<T> reference) async {
    final batch = FirebaseFirestore.instance.batch();

    try {
      showLoading(Get.context!);
      Future.delayed(Duration.zero);
      for (var id in idList) {
        batch.delete(reference.doc(id));
      }
      await batch.commit();
      hideLoading(Get.context!);
    } catch (error) {
      hideLoading(Get.context!);
      log("Item Document Delete Error: $error");
    }
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

  final Database database = Database();
  Future<void> upload<T>(
    DocumentReference<T> reference,
    T object,
    String success,
    String error,
    void Function() successCallBack,
  ) async {
    showLoading(Get.context!);
    try {
      await reference.set(object);
      hideLoading(Get.context!);
      successSnap(success);
      if (!Get.isSnackbarOpen) {
        successSnap(success);
      }
      successCallBack();
    } catch (e) {
      hideLoading(Get.context!);
      if (!Get.isSnackbarOpen) {
        errorSnap(error);
      }
    }
  }

  Future<void> edit<T>(
    DocumentReference<T> reference,
    T object,
    String success,
    String error,
    void Function() successCallBack,
  ) async {
    showLoading(Get.context!);
    try {
      await reference.set(object);
      hideLoading(Get.context!);
      successSnap(success);
      if (!Get.isSnackbarOpen) {
        successSnap(success);
      }
      successCallBack();
    } catch (e) {
      hideLoading(Get.context!);
      if (!Get.isSnackbarOpen) {
        errorSnap(error);
      }
    }
  }

  Future<void> delete<T>(
      DocumentReference<T> reference, String success, String error) async {
    showLoading(Get.context!);
    try {
      await reference.delete();
      hideLoading(Get.context!);
      if (!Get.isSnackbarOpen) {
        successSnap(success);
      }
    } catch (e) {
      hideLoading(Get.context!);
      if (!Get.isSnackbarOpen) {
        errorSnap(error);
      }
    }
  }
}
