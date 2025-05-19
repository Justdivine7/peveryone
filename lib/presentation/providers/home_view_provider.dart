import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peveryone/data/model/app_user_model/app_user_model.dart';
import 'package:peveryone/data/model/message_model/message_model.dart';
import 'package:peveryone/presentation/providers/general_providers/toast_provider.dart';
import 'package:peveryone/presentation/screens/home/repository/home_repository.dart';
 
final homeViewProvider = Provider<HomeRepository>((ref) {
  return HomeRepository(
    FirebaseFirestore.instance,
    FirebaseStorage.instance,
    ref.read(toastProvider),
  );
});

final allUsersProvider = FutureProvider<List<AppUserModel>>((ref) async {
  final repository = ref.watch(homeViewProvider);
  return repository.fetchAllUsers();
});

final messagesStreamProvider =
    StreamProvider.family<List<MessageModel>, String>((ref, chatId) {
      final ids = chatId.split('_');
      return ref.read(homeViewProvider).getMessages(ids[0], ids[1]);
    });
