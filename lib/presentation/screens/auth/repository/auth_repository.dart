import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:peveryone/data/model/app_user_model/app_user_model.dart';
import 'package:peveryone/presentation/widgets/toast_widget.dart';
import 'package:toastification/toastification.dart';

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
          firstName: firstName,
          lastName: lastName,
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
        return user;
      } else {
        _toast.show(
          message: 'Registration failed',
          type: ToastificationType.error,
        );
        return null; // Explicitly return null if user is null
      }
    } catch (e) {
      String errorMessage = 'Registration failed';

      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'email-already-in-use':
            errorMessage = 'The email address is already in use.';
            break;
          case 'weak-password':
            errorMessage = 'The password is too weak.';
            break;
          case 'invalid-email':
            errorMessage = 'The email address is not valid.';
            break;
          default:
            errorMessage = 'Registration failed. Please try again.';
        }
      }
      _toast.show(message: errorMessage, type: ToastificationType.error);
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
      if (userCredential.user?.emailVerified != null) {
        _toast.show(
          message: 'Login successfully',
          type: ToastificationType.success,
        );
      } else if (userCredential.user != null) {
        _toast.show(
          message: 'Login awaiting email verification',
          type: ToastificationType.success,
        );
      }
      return userCredential.user;
    } catch (e) {
      _toast.show(message: 'Login failed', type: ToastificationType.error);
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

      print('Password reset email sent');
      return true;
    } on FirebaseAuthException catch (e) {
      _toast.show(
        message: 'Failed to send reset email',
        type: ToastificationType.error,
      );

      print('Failed to send reset email: ${e.message}');
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

  // Future<void> emailVerificationAndMonitor({
  //   required BuildContext context,
  //   required User user,
  //   required VoidCallback onVerified,
  //   required VoidCallback onTimeout,
  // }) async {
  //   await user.sendEmailVerification();
  //   _toast.show(
  //     'Verification email sent. Please check your mail',
  //     type: ToastificationType.info,
  //   );

  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder:
  //         (_) => Center(
  //           child: SizedBox(
  //             height: 100,
  //             width: 100,
  //             child: Lottie.asset('assets/animations/loading.json'),
  //           ),
  //         ),
  //   );

  //   final timer = Timer.periodic(Duration(seconds: 3), (timer) async {
  //     await user.reload();
  //     final currentUser = _auth.currentUser;
  //     if (currentUser != null && currentUser.emailVerified) {
  //       timer.cancel();
  //       Navigator.of(context).pop();
  //       _toast.show('Email verified', type: ToastificationType.success);
  //       onVerified();
  //     }
  //   });

  //   Future.delayed(Duration(seconds: 30), () {
  //     if (timer.isActive) {
  //       timer.cancel();
  //       Navigator.of(context).pop();
  //       _toast.show(
  //         "Verification timed out. Try again.",
  //         type: ToastificationType.error,
  //       );
  //       onTimeout();
  //     }
  //   });
  // }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
