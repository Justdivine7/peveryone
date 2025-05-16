import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peveryone/core/constants/message_enum.dart';
import 'package:peveryone/presentation/providers/home_view_provider.dart';

void sendText(String text, String senderId, String receiverId, WidgetRef ref) {
  ref
      .read(homeViewProvider)
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
  final url = await ref.read(homeViewProvider).uploadFile(file, type);
  await ref
      .read(homeViewProvider)
      .sendMessage(
        senderId: senderId,
        receiverId: receiverId,
        content: url,
        type: type,
      );
}
