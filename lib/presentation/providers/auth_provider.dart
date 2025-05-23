import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:peveryone/data/model/app_user_model/app_user_model.dart';
import 'package:peveryone/presentation/providers/general_providers/global_providers.dart';
import 'package:peveryone/presentation/screens/auth/repository/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    FirebaseAuth.instance,
    FirebaseFirestore.instance,
    GoogleSignIn(),
    ref.read(toastProvider),
  );
});

final authStateChangesProvider = StreamProvider<User?>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return repo.authStateChanges;
});

final appUserProvider = StreamProvider<AppUserModel?>((ref) {
  final authChanges = ref.watch(authStateChangesProvider);

  return authChanges.when(
    data: (user) {
      if (user == null) return Stream.value(null);

      final docStream =
          FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .snapshots();

      return docStream.map((doc) {
        if (doc.exists) {
          return AppUserModel.fromJson(doc.data()!);
        } else {
          return null;
        }
      });
    },
    loading: () => const Stream.empty(),
    error: (_, __) => const Stream.empty(),
  );
});
