import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mime/mime.dart';
import 'package:peveryone/core/constants/chat_helpers.dart';
import 'package:peveryone/core/constants/media_compresser.dart';
import 'package:peveryone/core/constants/message_enum.dart';
import 'package:peveryone/data/model/app_user_model/app_user_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:peveryone/data/model/message_model/message_model.dart';
import 'package:uuid/uuid.dart';

class HomeRepository {
  final FirebaseFirestore _firestore;
  final FirebaseStorage storage;

  HomeRepository(this._firestore, this.storage);

  Future<List<AppUserModel>> fetchAllUsers() async {
    final snapshot = await _firestore.collection('users').get();
    return snapshot.docs
        .map((doc) => AppUserModel.fromJson(doc.data()))
        .toList();
  }

  String _getChatId(String user1, String user2) {
    final ids = [user1, user2]..sort();
    return '${ids[0]}_${ids[1]}';
  }

  Future<void> sendMessage({
    required String senderId,
    required String receiverId,
    required String content,
    required MessageType type,
  }) async {
    final chatId = _getChatId(senderId, receiverId);
    final messageId = const Uuid().v4();

    final message = MessageModel(
      id: messageId,
      senderId: senderId,
      receiverId: receiverId,
      content: content,
      type: type,
      sentAt: DateTime.now(),
      seen: true,
    );

    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .set(message.toJson());
  }

  Future<String> uploadFile(File file, MessageType type) async {
    final fileName = const Uuid().v4();
    final ref = storage.ref().child('messages/${type.name}/$fileName');
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  Stream<List<MessageModel>> getMessages(String senderId, String receiverId) {
    final chatId = _getChatId(senderId, receiverId);
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => MessageModel.fromJson(doc.data()))
                  .toList(),
        );
  }

  Future<void> pickMediaAndSend(
    BuildContext context,
    WidgetRef ref,
    String senderId,
    String receiverId,
  ) async {
    final result = await FilePicker.platform.pickFiles(type: FileType.media);
    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      final mime = lookupMimeType(file.path);
      final isVideo = mime != null && mime.startsWith('video');
      File compressedFile;

      if (isVideo) {
        compressedFile = await compressVideo(file);
      } else {
        compressedFile = await compressImage(file);
      }

      await sendMedia(
        compressedFile,
        isVideo ? MessageType.video : MessageType.image,
        senderId,
        receiverId,
        ref,
      );
    }
  }
}
