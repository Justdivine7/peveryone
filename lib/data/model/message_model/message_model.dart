import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:peveryone/core/constants/message_enum.dart';
part 'message_model.freezed.dart';
part 'message_model.g.dart';

@freezed
abstract class MessageModel with _$MessageModel {
  const factory MessageModel({
    required String id,
    required String senderId,
    required String receiverId,
    required String content,
    required MessageType type,
    required DateTime sentAt,
    required bool seen,
  }) = _MessageModel;

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);
}
