import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:peveryone/data/model/app_user_model/app_user_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

 
class HomeRepository {
  final FirebaseFirestore _firestore;
  final FirebaseStorage storage;


  HomeRepository(this._firestore, this.storage,);

  Future<List<AppUserModel>> fetchAllUsers() async {
    final snapshot = await _firestore.collection('users').get();
    return snapshot.docs
        .map((doc) => AppUserModel.fromJson(doc.data()))
        .toList();
  }

  Future<AppUserModel> fetchUserById(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    return AppUserModel.fromJson(doc.data()!);
  }
}
