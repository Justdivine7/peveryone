import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'package:peveryone/data/model/app_user_model/app_user_model.dart';
import 'package:peveryone/presentation/widgets/toast_widget.dart';

class AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;
  final ToastWidget _toast;
  AuthRepository(this._auth, this._firestore, this._googleSignIn, this._toast);

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  Future<User?> signUp({
    required String email,
    required String password,
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
          uid: user.uid,
          email: email,
          displayName: displayName ?? user.displayName,
          photoUrl: null,
        );
        await _firestore
            .collection('users')
            .doc(user.uid)
            .set(appUser.toJson());
        _toast.show('Account created successfully', type: ToastType.success);
        return user;
      } else {
        _toast.show(
          'Registration failed. User is null.',
          type: ToastType.error,
        );
        return null; // Explicitly return null if user is null
      }
    } catch (e) {
      //   String errorMessage = 'Registration failed';

      // if (e is FirebaseAuthException) {
      // switch (e.code) {
      //   case 'email-already-in-use':
      //     errorMessage = 'The email address is already in use.';
      //     break;
      //   case 'weak-password':
      //     errorMessage = 'The password is too weak.';
      //     break;
      //   case 'invalid-email':
      //     errorMessage = 'The email address is not valid.';
      //     break;
      //   default:
      //     errorMessage = 'Registration failed. Please try again.';
      // }
      // }
      _toast.show('Registration failed', type: ToastType.error);
      print(e.toString());
      return null;
    }
  }

  Future<User?> login({required String email, required String password}) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _toast.show('Login successfully', type: ToastType.success);
      return userCredential.user;
    } catch (e) {
      _toast.show('Login failed', type: ToastType.error);
      return null;
    }
  }

  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      _toast.show('Password reset email sent', type: ToastType.success);

      print('Password reset email sent');
      return true;
    } on FirebaseAuthException catch (e) {
      _toast.show('Failed to send reset email', type: ToastType.error);

      print('Failed to send reset email: ${e.message}');
      return false;
    }
  }

  Future<void> emailVerificationAndMonitor({
    required BuildContext context,
    required User user,
    required VoidCallback onVerified,
    required VoidCallback onTimeout,
  }) async {
    await user.sendEmailVerification();
    _toast.show(
      'Verification email sent. Please check your mail',
      type: ToastType.info,
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => Center(
            child: SizedBox(
              height: 100,
              width: 100,
              child: Lottie.asset('assets/animations/loading.json'),
            ),
          ),
    );

    final timer = Timer.periodic(Duration(seconds: 3), (timer) async {
      await user.reload();
      final currentUser = _auth.currentUser;
      if (currentUser != null && currentUser.emailVerified) {
        timer.cancel();
        Navigator.of(context).pop();
        _toast.show('Email verified', type: ToastType.success);
        onVerified();
      }
    });

    Future.delayed(Duration(seconds: 30), () {
      if (timer.isActive) {
        timer.cancel();
        Navigator.of(context).pop();
        _toast.show(
          "Verification timed out. Try again.",
          type: ToastType.error,
        );
        onTimeout();
      }
    });
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
