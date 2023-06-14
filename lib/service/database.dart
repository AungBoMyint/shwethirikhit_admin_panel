import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class Database {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> watch(String collectionPath) =>
      _firebaseFirestore.collection(collectionPath).snapshots();

  Future<DocumentSnapshot<Map<String, dynamic>>> read(
    String collectionPath, {
    String? path,
  }) =>
      _firebaseFirestore.collection(collectionPath).doc(path).get();

  Future<void> write(
    String collectionPath, {
    String? path,
    required Map<String, dynamic> data,
  }) =>
      _firebaseFirestore.collection(collectionPath).doc(path).set(data);

  Future<void> update(
    String collectionPath, {
    required String path,
    required Map<String, dynamic> data,
  }) =>
      _firebaseFirestore.collection(collectionPath).doc(path).update(data);

  Future<void> delete(
    String collectionPath, {
    required String path,
  }) =>
      _firebaseFirestore.collection(collectionPath).doc(path).delete();

  Future<String> uploadImage(String path, String image) async {
    Reference storageReference = _firebaseStorage.ref().child('$path/$image');
    UploadTask uploadTask =
        storageReference.putData(await XFile(image).readAsBytes());
    final snapshot = await uploadTask;

    return await snapshot.ref.getDownloadURL();
  }
}
