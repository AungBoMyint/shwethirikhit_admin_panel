import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/object_models/category.dart';
import '../models/object_models/expert.dart';
import '../models/object_models/music.dart';
import '../models/object_models/therapy_video.dart';
import '../models/object_models/type.dart';
import '../models/object_models/vlog_video.dart';
import 'reference.dart';

Query<ExpertModel> allExpertQuery() =>
    expertsCollection().orderBy('name').orderBy('dateTime').limit(10);
Query<ExpertModel> expertQuery(String typeID) =>
    expertsCollection().where("type", isEqualTo: typeID);
Query<Category> homeCategoryQuery = categoryCollection()
    .orderBy('dateTime', descending: true)
    .orderBy('name')
    .limit(10);
Query<Category> affirmationsCategoryQuery =
    affirmationsCategoryCollection().orderBy('dateTime').limit(10);
Query<ItemType> homeTypeQuery = homeTypeCollection().orderBy('order').limit(10);
Query<ItemType> affirmationsTypeQuery =
    affirmationsTypeCollection().orderBy('order');

Query<Music> affirmationsTypeMusicsQuery(String typeID) =>
    musicCollection().where("type", isEqualTo: typeID).orderBy("dateTime");
Query<Music> affirmationsCategoryMusicsQuery(String categoryID) =>
    musicCollection()
        .where("categoryID", isEqualTo: categoryID)
        .orderBy("dateTime");
Query<Music> allAffirmationsMusicsQuery() =>
    musicCollection().orderBy("dateTime").limit(10);

Query<VlogVideo> vlogVideoQuery =
    vlogVideoCollection().orderBy("dateTime", descending: true).limit(10);
Query<Category> therapyCategoryQuery =
    therapyCategoryCollection().orderBy("dateTime", descending: true).limit(10);
/* Query<TherapyVideo> therapyVideoQuery =
    therapyVideoCollection().orderBy("order", descending: true); */
Query<TherapyVideo> therapyVideosQuery(String categoryID) =>
    therapyVideoCollection()
        .where("parentID", isEqualTo: categoryID)
        .orderBy('order');
Query<TherapyVideo> allTherapyVideosQuery() =>
    therapyVideoCollection().orderBy('dateTime', descending: true).limit(10);
