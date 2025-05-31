import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TokenManager{
  static Future<void> fcmToken(String token)async{
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if(uid == null) return;

    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'fcmToken': token,
    });
  }
}