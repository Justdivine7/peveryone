import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:peveryone/main.dart';
import 'package:peveryone/presentation/widgets/toast_widget.dart';
import 'package:toastification/toastification.dart';

class UserProfileRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ToastWidget _toast = ToastWidget(navigatorKey);
  Future<void> updateUserProfile({
    required String uid,
    String? firstName,
    String? lastName,

    String? photoUrl,
  }) async {
    final updates = <String, dynamic>{};

    try {
      if (firstName != null) updates['firstName'] = firstName;
      if (lastName != null) updates['lastName'] = lastName;
      if (photoUrl != null) updates['photoUrl'] = photoUrl;

      await _firestore.collection('users').doc(uid).update(updates);
      // _toast.show(
      //   message: 'Updated successfully',
      //   type: ToastificationType.success,
      // );
      debugPrint('Upload successfully');
    } catch (e) {
      _toast.show(
        message: 'Profile update failed',
        type: ToastificationType.error,
      );
      debugPrint('Error updating profile:${e.toString()}');
    }
  }

  Future<String> uploadProfilePhoto(File file, String uid) async {
    try {
      final ref = _storage.ref().child('profile_photos').child('$uid.jpg');
      await ref.putFile(file);
      _toast.show(
        message: 'Upload successful',
        type: ToastificationType.success,
      );
      debugPrint('Image picked');
      return await ref.getDownloadURL();
    } catch (e) {
      _toast.show(
        message: 'Profile update failed',
        type: ToastificationType.error,
      );
      debugPrint(e.toString());
      throw e.toString();
    }
  }
}
