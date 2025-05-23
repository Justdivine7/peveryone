import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peveryone/data/model/app_user_model/app_user_model.dart';
 import 'package:peveryone/presentation/screens/home/repository/home_repository.dart';
 
final homeViewProvider = Provider<HomeRepository>((ref) {
  return HomeRepository(
    FirebaseFirestore.instance,
    FirebaseStorage.instance,
 
  );
});

final allUsersProvider = StreamProvider<List<AppUserModel>>((ref)  {
  final repository = ref.watch(homeViewProvider);
  return repository.fetchAllUsers();
});



