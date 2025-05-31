import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:peveryone/data/model/app_user_model/app_user_model.dart';
import 'package:peveryone/main.dart';
import 'package:peveryone/presentation/providers/auth_provider.dart';
import 'package:peveryone/presentation/providers/general_providers/auth_loader.dart';
import 'package:peveryone/presentation/providers/general_providers/global_providers.dart';
import 'package:peveryone/presentation/widgets/toast_widget.dart';
import 'package:toastification/toastification.dart';

class AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;
  final ToastWidget _toast;
  AuthRepository(this._auth, this._firestore, this._googleSignIn, this._toast);

  User? get userDetails => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      User? user = userCredential.user;
      if (user == null) return null;
      final userDocRef = _firestore.collection('users').doc(user.uid);
      final userDoc = await userDocRef.get();

      if (!userDoc.exists) {
        String displayName = user.displayName ?? '';
        List<String> names = displayName.trim().split(" ");

        String firstName = "";
        String lastName = "";
        if (names.isNotEmpty) {
          firstName = names.first;
          if (names.length > 1) {
            lastName = names.sublist(1).join(" ");
          }
        }
        final appUser = AppUserModel(
          uid: user.uid,
          email: user.email ?? '',
          firstName: firstName.trim(),
          lastName: lastName.trim(),
          photoUrl: user.photoURL ?? '',
        );
        await _firestore
            .collection('users')
            .doc(user.uid)
            .set(appUser.toJson());
      }
      await saveUserToken(user.uid);
      _toast.show(
        message: 'Google sign in successful',
        type: ToastificationType.success,
      );

      return user;
    } catch (e) {
      debugPrint('Google sign-in failed: $e');
      _toast.show(
        message: 'Google sign in failed',
        type: ToastificationType.error,
      );
    }
    return null;
  }

  Future<User?> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? displayName,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;

      if (user != null) {
        final appUser = AppUserModel(
          firstName: firstName.trim(),
          lastName: lastName.trim(),
          uid: user.uid,
          email: email,

          photoUrl: null,
        );
        await _firestore
            .collection('users')
            .doc(user.uid)
            .set(appUser.toJson());
        _toast.show(
          message: 'Account created successfully',
          type: ToastificationType.success,
        );
        await saveUserToken(user.uid);
        return user;
      } else {
        _toast.show(
          message: 'Registration failed',
          type: ToastificationType.error,
        );
        return null; // Explicitly return null if user is null
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'network-request-failed') {
        _toast.show(
          message: 'No internet connection',
          type: ToastificationType.error,
        );
      } else if (e.code == 'email-already-in-use') {
        _toast.show(
          message: 'This email is already in use. Try logging in instead',
          type: ToastificationType.error,
        );
      } else {
        _toast.show(
          message: e.message ?? 'Registration failed',
          type: ToastificationType.error,
        );
      }
      return null;
    } catch (e) {
      _toast.show(message: 'Unexpected error', type: ToastificationType.error);
      debugPrint('Signup error: ${e.toString()}');
      return null;
    }
  }

  Future<void> saveUserToken(String userId) async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        await FirebaseFirestore.instance.collection('users').doc(userId).update(
          {'fcmToken': token},
        );
      } else {
        debugPrint('No FCM token available for user $userId');
      }
    } catch (e) {
      debugPrint('Error saving FCM token: $e');
    }
  }

  Future<User?> login({required String email, required String password}) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;

      if (user != null) {
        if (user.emailVerified) {
          _toast.show(
            message: 'Login successful',
            type: ToastificationType.success,
          );
        } else {
          _toast.show(
            message: 'Login awaiting email verification',
            type: ToastificationType.info,
          );
        }
      }

      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'network-request-failed') {
        _toast.show(
          message: 'No internet connection',
          type: ToastificationType.error,
        );
      } else {
        _toast.show(
          message: e.message ?? 'Login failed',
          type: ToastificationType.error,
        );
      }
      return null;
    } catch (e) {
      _toast.show(message: 'unexpected error', type: ToastificationType.error);
      return null;
    }
  }

  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      _toast.show(
        message: 'Password reset email sent, check your mailbox',
        type: ToastificationType.success,
      );

      debugPrint('Password reset email sent');
      return true;
    } on FirebaseAuthException catch (e) {
      _toast.show(
        message: 'Failed to send reset email',
        type: ToastificationType.error,
      );

      debugPrint('Failed to send reset email: ${e.message}');
      return false;
    }
  }

  Future<void> sendEmailVerification(User user) async {
    if (!user.emailVerified) {
      await user.sendEmailVerification();
      _toast.show(
        message: 'Verification email sent',
        type: ToastificationType.success,
      );
    }
  }

  Future<void> signOut(WidgetRef ref) async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    ref.invalidate(userProfileProvider);
    ref.invalidate(profileImageProvider);
    ref.invalidate(appUserProvider);
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      '/login-screen',
      (route) => false,
    );
    ref.invalidate(AuthLoader.selectedIndexProvider);
  }
}
