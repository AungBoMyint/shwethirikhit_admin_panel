import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:get/get.dart';

import '../../models/object_models/category.dart';
import '../../models/object_models/expert.dart';
import '../../models/object_models/type.dart';
import '../../service/query.dart';
import '../utils/debouncer.dart';

class NewsController extends GetxController {
  Rxn<Query<Category>> sliderQuery = Rxn<Query<Category>>(homeCategoryQuery);
  TextEditingController searchTextController = TextEditingController();
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
  RxList<ItemType> typeSelectedRow = <ItemType>[].obs;
  RxList<ExpertModel> itemsSelectedRow = <ExpertModel>[].obs;
  var sliderSelectedAll = false.obs;
  var typeSelectedAll = false.obs;
  var itemsSelectedAll = false.obs;

  void startSliderSearch() => sliderQuery.value = homeCategoryQuery
      .where("nameList", arrayContains: [searchTextController.text]);
  void setSliderSnapshot(FirestoreQueryBuilderSnapshot<Category> v) =>
      sliderSnapshot = v;

  void setSliderSelectedRow(Category item) {
    if (sliderSelectedRow.contains(item.id)) {
      sliderSelectedRow.remove(item.id);
    } else {
      sliderSelectedRow.add(item.id);
    }
  }

  void setTypeSelectedRow(ItemType item) {
    if (typeSelectedRow.contains(item)) {
      typeSelectedRow.remove(item);
    } else {
      typeSelectedRow.add(item);
    }
  }

  void setItemsSelectedRow(ExpertModel item) {
    if (itemsSelectedRow.contains(item)) {
      itemsSelectedRow.remove(item);
    } else {
      itemsSelectedRow.add(item);
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
        items == null ? [] : items.map((e) => e.data()).toList();
  }

  void setItemsSelectedAll(List<QueryDocumentSnapshot<ExpertModel>>? items) {
    itemsSelectedAll.value = items == null ? false : true;
    itemsSelectedRow.value =
        items == null ? [] : items.map((e) => e.data()).toList();
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
