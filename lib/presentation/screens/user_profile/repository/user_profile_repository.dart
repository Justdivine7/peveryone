

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfileRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> updateUserProfile({
    required String uid,
    String? firstName,
    String? lastName,
    String? email,
    String? photoUrl,
  }) async {
    final updates = <String, dynamic>{};

    if (firstName != null) updates['firstName'] = firstName;
    if (lastName != null) updates['lastName'] = lastName;
    if (email != null) updates['email'] = email;
    if (photoUrl != null) updates['photoUrl'] = photoUrl;

    await _firestore.collection('users').doc(uid).update(updates);
  }

  Future<String> uploadProfilePhoto(File file, String uid) async {
    final ref = _storage.ref().child('profile_photos').child('$uid.jpg');
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }
}
