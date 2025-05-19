import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mime/mime.dart';
import 'package:peveryone/core/constants/media_compresser.dart';
import 'package:peveryone/core/constants/message_enum.dart';
import 'package:peveryone/data/model/app_user_model/app_user_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:peveryone/data/model/message_model/message_model.dart';
import 'package:peveryone/data/model/inbox_model/inbox_model.dart';
import 'package:peveryone/presentation/widgets/toast_widget.dart';
import 'package:toastification/toastification.dart';
import 'package:uuid/uuid.dart';

class HomeRepository {
  final FirebaseFirestore _firestore;
  final FirebaseStorage storage;
  final ToastWidget _toast;

  HomeRepository(this._firestore, this.storage, this._toast);

  Future<List<AppUserModel>> fetchAllUsers() async {
    final snapshot = await _firestore.collection('users').get();
    return snapshot.docs
        .map((doc) => AppUserModel.fromJson(doc.data()))
        .toList();
  }

  Future<AppUserModel> fetchUserById(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    return AppUserModel.fromJson(doc.data()!);
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
    final sentAt = DateTime.now();

    final message = MessageModel(
      id: messageId,
      senderId: senderId,
      receiverId: receiverId,
      content: content,
      type: type,
      sentAt: sentAt,
      status: MessageStatus.sending,
      seen: false,
    );

    final messageRef = _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId);

    final chatRef = _firestore.collection('chats').doc(chatId);

    await _firestore.runTransaction((transaction) async {
      transaction.set(messageRef, message.toJson());
      transaction.set(chatRef, {
        'lastMessage': content,
        'lastSenderId': senderId,
        'lastTimestamp': sentAt,
        'participants': [senderId, receiverId],
        'unreadCounts.$receiverId': FieldValue.increment(1),
        'unreadCounts.$senderId': 0, // Reset sender's unread count
        'lastMessageType': type.name,
      }, SetOptions(merge: true));
    });
      await messageRef.update({'status': MessageStatus.sent.name});

  }

  Future<void> markMessagesAsDelivered(
    String receiverId,
    String senderId,
  ) async {
    try {
      final chatId = _getChatId(senderId, receiverId);
      final messagesRef = _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages');
      final querySnapshot =
          await messagesRef
              .where('receiverId', isEqualTo: receiverId)
              .where('status', isEqualTo: MessageStatus.sent.name)
              .get();
      final batch = _firestore.batch();

      for (var doc in querySnapshot.docs) {
        batch.update(doc.reference, {'status': MessageStatus.delivered.name});
      }
      await batch.commit();
    } catch (e) {
      debugPrint('error occured: $e');
      _toast.show(
        message: 'An update error occured',
        type: ToastificationType.info,
      );
    }
  }

  Stream<List<InboxModel>> getInbox(String userId) async* {
    await for (final snapshot
        in _firestore
            .collection('chats')
            .where('participants', arrayContains: userId)
            .orderBy('lastTimestamp', descending: true)
            .snapshots()) {
      final List<InboxModel> list = [];

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final chatId = doc.id;
        final otherUserId = chatId
            .split('_')
            .firstWhere((id) => id != userId, orElse: () => '');
        final messageCount = (data['messageCount'] ?? 0) as int;
        if (otherUserId.isEmpty) continue;

        try {
          final user = await fetchUserById(otherUserId);
          final unreadCounts =
              data['unreadCounts'] as Map<String, dynamic>? ?? {};
          final unreadCount = unreadCounts[otherUserId] as int? ?? 0;

          list.add(
            InboxModel(
              chatId: chatId,
              chatWith: otherUserId,
              chatWithName: user.firstName,
              chatWithPhotoUrl: user.photoUrl ?? '',
              lastMessage: data['lastMessage'] ?? '',
              lastSenderId: data['lastSenderId'] ?? '',
              lastTimestamp:
                  (data['lastTimestamp'] as Timestamp?)?.toDate() ??
                  DateTime.now(),
              unreadCount: unreadCount,
              messageCount: messageCount,
              lastMessageType: MessageType.values.byName(
                data['lastMessageType'] ?? 'text',
              ),
            ),
          );
        } catch (e) {
          debugPrint('Error parsing inbox for chat $chatId: $e');
          _toast.show(
            message: 'Something went wrong',
            type: ToastificationType.error,
          );
          continue;
        }
      }

      yield list;
    }
  }

  Future<String> uploadFile(File file, MessageType type) async {
    try {
      final fileName = const Uuid().v4();
      final ref = storage.ref().child('messages/${type.name}s/$fileName');
      await ref.putFile(file);
      return await ref.getDownloadURL();
    } catch (e) {
      debugPrint('Upload failed: $e');
      _toast.show(message: 'Upload failed', type: ToastificationType.error);
      rethrow;
    }
  }

  Stream<List<MessageModel>> getMessages(String senderId, String receiverId) {
    final chatId = _getChatId(senderId, receiverId);
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('sentAt')
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
      final compressedFile =
          isVideo ? await compressVideo(file) : await compressImage(file);

      final chatId = _getChatId(senderId, receiverId);
      final messageId = const Uuid().v4();
      final sentAt = DateTime.now();
      final localMessage = MessageModel(
        id: messageId,
        senderId: senderId,
        receiverId: receiverId,
        content: '',
        type: isVideo ? MessageType.video : MessageType.image,
        sentAt: sentAt,
        localFilePath: compressedFile.path,
        status: MessageStatus.sending,
        seen: false,
      );

      final messageRef = _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(messageId);

      await messageRef.set(localMessage.toJson());

      try {
        final downloadUrl = await uploadFile(
          compressedFile,
          isVideo ? MessageType.video : MessageType.image,
        );
        final updatedMessage = localMessage.copyWith(
          content: downloadUrl,
          status: MessageStatus.sent,
        );
        await messageRef.update(updatedMessage.toJson());

        await _firestore.collection('chats').doc(chatId).set({
          'lastMessage': isVideo ? '📹 video' : '🖼️ image',
          'lastSenderId': senderId,
          'lastTimestamp': sentAt,
          'participants': [senderId, receiverId],
          'unreadCounts.$receiverId': FieldValue.increment(1),
          'unreadCounts.$senderId': 0,
          'lastMessageType':
              isVideo ? MessageType.video.name : MessageType.image.name,
        }, SetOptions(merge: true));
      } catch (e) {
        debugPrint('Upload failed: $e');
      }
    }
  }
}
