import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peveryone/data/model/inbox_model/inbox_model.dart';
import 'package:peveryone/data/model/message_model/message_model.dart';
import 'package:peveryone/presentation/providers/general_providers/global_providers.dart';
  import 'package:peveryone/presentation/screens/chat/repository/inbox_chat_repository.dart';

final inboxChatRepositoryProvider = Provider<InboxChatRepository>((ref) {
  return InboxChatRepository(
    FirebaseFirestore.instance,
    FirebaseStorage.instance,
    ref.read(toastProvider),
  );
});
final inboxProvider = StreamProvider.family<List<InboxModel>, String>((
  ref,
  userId,
) {
  final repo = ref.watch(inboxChatRepositoryProvider);
  return repo.getInbox(userId);
});
final messagesStreamProvider =
    StreamProvider.family<List<MessageModel>, String>((ref, chatId) {
      final ids = chatId.split('_');
      return ref.read(inboxChatRepositoryProvider).getMessages(ids[0], ids[1]);
    });
