import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/object_models/category.dart';
import '../models/object_models/expert.dart';
import '../models/object_models/music.dart';
import '../models/object_models/therapy_video.dart';
import '../models/object_models/type.dart';
import '../models/object_models/vlog_video.dart';

CollectionReference<Category> categoryCollection() => FirebaseFirestore.instance
    .collection("home_category")
    .withConverter<Category>(
        fromFirestore: (snap, __) => Category.fromJson(snap.data()!),
        toFirestore: (cat, snap) => cat.toJson());
DocumentReference<Category> categoryDocument(String id) =>
    categoryCollection().doc(id);

CollectionReference<Music> musicCollection() =>
    FirebaseFirestore.instance.collection("music").withConverter<Music>(
        fromFirestore: (snap, __) => Music.fromJson(snap.data()!),
        toFirestore: (music, snap) => music.toJson());
DocumentReference<Music> musicDocument(String id) => musicCollection().doc(id);
CollectionReference<ItemType> affirmationsTypeCollection() =>
    FirebaseFirestore.instance
        .collection("affirmations_type")
        .withConverter<ItemType>(
            fromFirestore: (snap, __) => ItemType.fromJson(snap.data()!),
            toFirestore: (itemType, snap) => itemType.toJson());

DocumentReference<ItemType> affirmationsTypeDocument(String id) =>
    affirmationsTypeCollection().doc(id);
CollectionReference<ItemType> homeTypeCollection() =>
    FirebaseFirestore.instance.collection("home_type").withConverter<ItemType>(
        fromFirestore: (snap, __) => ItemType.fromJson(snap.data()!),
        toFirestore: (itemType, snap) => itemType.toJson());
DocumentReference<ItemType> homeTypeDocument(String id) =>
    homeTypeCollection().doc(id);
CollectionReference<ExpertModel> expertsCollection() =>
    FirebaseFirestore.instance.collection("experts").withConverter<ExpertModel>(
        fromFirestore: (snap, __) =>
            ExpertModel.fromJson(snap.data()!, snap.id),
        toFirestore: (itemType, snap) => itemType.toJson());

DocumentReference<ExpertModel> expertsDocument(String id) =>
    expertsCollection().doc(id);

CollectionReference<VlogVideo> vlogVideoCollection() => FirebaseFirestore
    .instance
    .collection("vlog_videos")
    .withConverter<VlogVideo>(
        fromFirestore: (snapshot, __) => VlogVideo.fromJson(snapshot.data()!),
        toFirestore: (vlog, __) => vlog.toJson());

DocumentReference<VlogVideo> vlogVideoDocument(String id) =>
    vlogVideoCollection().doc(id);

CollectionReference<Category> therapyCategoryCollection() =>
    FirebaseFirestore.instance
        .collection("therapy_category")
        .withConverter<Category>(
          fromFirestore: (snap, __) => Category.fromJson(snap.data()!),
          toFirestore: (cat, __) => cat.toJson(),
        );
DocumentReference<Category> therapyCategoryDocument(String id) =>
    therapyCategoryCollection().doc(id);
CollectionReference<TherapyVideo> therapyVideoCollection() =>
    FirebaseFirestore.instance
        .collection("therapy_video")
        .withConverter<TherapyVideo>(
          fromFirestore: (snap, __) => TherapyVideo.fromJson(snap.data()!),
          toFirestore: (cat, __) => cat.toJson(),
        );
DocumentReference<TherapyVideo> therapyVideoDocument(String id) =>
    therapyVideoCollection().doc(id);

CollectionReference<Category> affirmationsCategoryCollection() =>
    FirebaseFirestore.instance
        .collection("affirmations_category")
        .withConverter<Category>(
          fromFirestore: (snap, __) => Category.fromJson(snap.data()!),
          toFirestore: (cat, __) => cat.toJson(),
        );
DocumentReference<Category> affirmationsCategoryDocument(String id) =>
    affirmationsCategoryCollection().doc(id);
