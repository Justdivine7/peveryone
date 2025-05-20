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

final appUserProvider = FutureProvider<AppUserModel?>((ref) async {
  final user = await ref.read(authStateChangesProvider.future);
  if (user == null) return null;

  final doc =
      await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
  if (doc.exists) {
    return AppUserModel.fromJson(doc.data()!);
  } else {
    return null;
  }
});
