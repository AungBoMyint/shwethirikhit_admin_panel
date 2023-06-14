import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:pizza/models/auth_user.dart';

import '../constant/collection_name.dart';

CollectionReference<AuthUser> userCollectionReference() =>
    FirebaseFirestore.instance
        .collection(userCollection)
        .withConverter<AuthUser>(
          fromFirestore: (snap, options) => AuthUser.fromJson(snap.data()!),
          toFirestore: (authUser, options) => authUser.toJson(),
        );

DocumentReference<AuthUser> userDocumentReference(String id) =>
    userCollectionReference().doc(id);

CollectionReference<Map<String, dynamic>>
    salesByCategoryCollectionReference() =>
        FirebaseFirestore.instance.collection("salesbycategory");
DocumentReference<Map<String, dynamic>> salesByCategoryDocumentReference(
        String id) =>
    salesByCategoryCollectionReference().doc(id);
