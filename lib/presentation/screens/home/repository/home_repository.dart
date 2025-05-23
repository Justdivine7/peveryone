import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:peveryone/data/model/app_user_model/app_user_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

class HomeRepository {
  final FirebaseFirestore _firestore;
  final FirebaseStorage storage;

  HomeRepository(this._firestore, this.storage);

  Stream<List<AppUserModel>> fetchAllUsers() {
    return _firestore.collection('users').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => AppUserModel.fromJson(doc.data()))
          .toList();
    });
  }

  Future<AppUserModel> fetchUserById(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    return AppUserModel.fromJson(doc.data()!);
  }
}
