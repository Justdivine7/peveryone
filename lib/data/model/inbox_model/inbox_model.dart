import 'package:freezed_annotation/freezed_annotation.dart';

part 'inbox_model.freezed.dart';
part 'inbox_model.g.dart';

@freezed
abstract class InboxModel with _$InboxModel {
  const factory InboxModel({
    required String chatId,
    required String chatWith,
    required String chatWithName,
    required String? chatWithPhotoUrl,
    required String lastMessage,
    required String lastSenderId,
    required DateTime lastTimestamp,
    required int unreadCount,
  }) = _InboxModel;

  factory InboxModel.fromJson(Map<String, dynamic> json) =>
      _$InboxModelFromJson(json);
}
