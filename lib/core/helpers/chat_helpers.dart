import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peveryone/core/constants/message_enum.dart';
import 'package:peveryone/presentation/providers/inbox_provider.dart';

void sendText(String text, String senderId, String receiverId, WidgetRef ref) {
  ref
      .read(inboxChatRepositoryProvider)
      .sendMessage(
        senderId: senderId,
        receiverId: receiverId,
        content: text,
        type: MessageType.text,
      );
}

Future<void> sendMedia(
  File file,
  MessageType type,
  String senderId,
  String receiverId,
  WidgetRef ref,
) async {
  final url = await ref
      .read(inboxChatRepositoryProvider)
      .uploadFile(file, type);
  await ref
      .read(inboxChatRepositoryProvider)
      .sendMessage(
        senderId: senderId,
        receiverId: receiverId,
        content: url,
        type: type,
      );
}

String getChatId(String user1, String user2) {
  final ids = [user1, user2]..sort();
  return '${ids[0]}_${ids[1]}';
}
