// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inbox_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InboxModel _$InboxModelFromJson(Map<String, dynamic> json) => _InboxModel(
  chatId: json['chatId'] as String,
  chatWith: json['chatWith'] as String,
  chatWithName: json['chatWithName'] as String,
  chatWithPhotoUrl: json['chatWithPhotoUrl'] as String?,
  lastMessage: json['lastMessage'] as String,
  lastSenderId: json['lastSenderId'] as String,
  lastTimestamp: DateTime.parse(json['lastTimestamp'] as String),
  unreadCount: (json['unreadCount'] as num).toInt(),
);

Map<String, dynamic> _$InboxModelToJson(_InboxModel instance) =>
    <String, dynamic>{
      'chatId': instance.chatId,
      'chatWith': instance.chatWith,
      'chatWithName': instance.chatWithName,
      'chatWithPhotoUrl': instance.chatWithPhotoUrl,
      'lastMessage': instance.lastMessage,
      'lastSenderId': instance.lastSenderId,
      'lastTimestamp': instance.lastTimestamp.toIso8601String(),
      'unreadCount': instance.unreadCount,
    };
