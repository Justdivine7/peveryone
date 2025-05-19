import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:peveryone/core/constants/message_enum.dart';
part 'message_model.freezed.dart';
part 'message_model.g.dart';

enum MessageStatus{sending, sent, delivered}
@freezed
abstract class MessageModel with _$MessageModel {
  const factory MessageModel({
    required String id,
    required String senderId,
    required String receiverId,
    required String content,
    required MessageType type,
    required DateTime sentAt,
    
    @Default(MessageStatus.sending) MessageStatus status,
    String? localFilePath,
    @Default(false)bool seen,
  }) = _MessageModel;

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);
}
