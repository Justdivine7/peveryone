// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inbox_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InboxModel {

 String get chatId; String get chatWith; String get chatWithName; String? get chatWithPhotoUrl; String get lastMessage; String get lastSenderId; DateTime get lastTimestamp; int get unreadCount;
/// Create a copy of InboxModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InboxModelCopyWith<InboxModel> get copyWith => _$InboxModelCopyWithImpl<InboxModel>(this as InboxModel, _$identity);

  /// Serializes this InboxModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InboxModel&&(identical(other.chatId, chatId) || other.chatId == chatId)&&(identical(other.chatWith, chatWith) || other.chatWith == chatWith)&&(identical(other.chatWithName, chatWithName) || other.chatWithName == chatWithName)&&(identical(other.chatWithPhotoUrl, chatWithPhotoUrl) || other.chatWithPhotoUrl == chatWithPhotoUrl)&&(identical(other.lastMessage, lastMessage) || other.lastMessage == lastMessage)&&(identical(other.lastSenderId, lastSenderId) || other.lastSenderId == lastSenderId)&&(identical(other.lastTimestamp, lastTimestamp) || other.lastTimestamp == lastTimestamp)&&(identical(other.unreadCount, unreadCount) || other.unreadCount == unreadCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,chatId,chatWith,chatWithName,chatWithPhotoUrl,lastMessage,lastSenderId,lastTimestamp,unreadCount);

@override
String toString() {
  return 'InboxModel(chatId: $chatId, chatWith: $chatWith, chatWithName: $chatWithName, chatWithPhotoUrl: $chatWithPhotoUrl, lastMessage: $lastMessage, lastSenderId: $lastSenderId, lastTimestamp: $lastTimestamp, unreadCount: $unreadCount)';
}


}

/// @nodoc
abstract mixin class $InboxModelCopyWith<$Res>  {
  factory $InboxModelCopyWith(InboxModel value, $Res Function(InboxModel) _then) = _$InboxModelCopyWithImpl;
@useResult
$Res call({
 String chatId, String chatWith, String chatWithName, String? chatWithPhotoUrl, String lastMessage, String lastSenderId, DateTime lastTimestamp, int unreadCount
});




}
/// @nodoc
class _$InboxModelCopyWithImpl<$Res>
    implements $InboxModelCopyWith<$Res> {
  _$InboxModelCopyWithImpl(this._self, this._then);

  final InboxModel _self;
  final $Res Function(InboxModel) _then;

/// Create a copy of InboxModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? chatId = null,Object? chatWith = null,Object? chatWithName = null,Object? chatWithPhotoUrl = freezed,Object? lastMessage = null,Object? lastSenderId = null,Object? lastTimestamp = null,Object? unreadCount = null,}) {
  return _then(_self.copyWith(
chatId: null == chatId ? _self.chatId : chatId // ignore: cast_nullable_to_non_nullable
as String,chatWith: null == chatWith ? _self.chatWith : chatWith // ignore: cast_nullable_to_non_nullable
as String,chatWithName: null == chatWithName ? _self.chatWithName : chatWithName // ignore: cast_nullable_to_non_nullable
as String,chatWithPhotoUrl: freezed == chatWithPhotoUrl ? _self.chatWithPhotoUrl : chatWithPhotoUrl // ignore: cast_nullable_to_non_nullable
as String?,lastMessage: null == lastMessage ? _self.lastMessage : lastMessage // ignore: cast_nullable_to_non_nullable
as String,lastSenderId: null == lastSenderId ? _self.lastSenderId : lastSenderId // ignore: cast_nullable_to_non_nullable
as String,lastTimestamp: null == lastTimestamp ? _self.lastTimestamp : lastTimestamp // ignore: cast_nullable_to_non_nullable
as DateTime,unreadCount: null == unreadCount ? _self.unreadCount : unreadCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _InboxModel implements InboxModel {
  const _InboxModel({required this.chatId, required this.chatWith, required this.chatWithName, required this.chatWithPhotoUrl, required this.lastMessage, required this.lastSenderId, required this.lastTimestamp, required this.unreadCount});
  factory _InboxModel.fromJson(Map<String, dynamic> json) => _$InboxModelFromJson(json);

@override final  String chatId;
@override final  String chatWith;
@override final  String chatWithName;
@override final  String? chatWithPhotoUrl;
@override final  String lastMessage;
@override final  String lastSenderId;
@override final  DateTime lastTimestamp;
@override final  int unreadCount;

/// Create a copy of InboxModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InboxModelCopyWith<_InboxModel> get copyWith => __$InboxModelCopyWithImpl<_InboxModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InboxModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InboxModel&&(identical(other.chatId, chatId) || other.chatId == chatId)&&(identical(other.chatWith, chatWith) || other.chatWith == chatWith)&&(identical(other.chatWithName, chatWithName) || other.chatWithName == chatWithName)&&(identical(other.chatWithPhotoUrl, chatWithPhotoUrl) || other.chatWithPhotoUrl == chatWithPhotoUrl)&&(identical(other.lastMessage, lastMessage) || other.lastMessage == lastMessage)&&(identical(other.lastSenderId, lastSenderId) || other.lastSenderId == lastSenderId)&&(identical(other.lastTimestamp, lastTimestamp) || other.lastTimestamp == lastTimestamp)&&(identical(other.unreadCount, unreadCount) || other.unreadCount == unreadCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,chatId,chatWith,chatWithName,chatWithPhotoUrl,lastMessage,lastSenderId,lastTimestamp,unreadCount);

@override
String toString() {
  return 'InboxModel(chatId: $chatId, chatWith: $chatWith, chatWithName: $chatWithName, chatWithPhotoUrl: $chatWithPhotoUrl, lastMessage: $lastMessage, lastSenderId: $lastSenderId, lastTimestamp: $lastTimestamp, unreadCount: $unreadCount)';
}


}

/// @nodoc
abstract mixin class _$InboxModelCopyWith<$Res> implements $InboxModelCopyWith<$Res> {
  factory _$InboxModelCopyWith(_InboxModel value, $Res Function(_InboxModel) _then) = __$InboxModelCopyWithImpl;
@override @useResult
$Res call({
 String chatId, String chatWith, String chatWithName, String? chatWithPhotoUrl, String lastMessage, String lastSenderId, DateTime lastTimestamp, int unreadCount
});




}
/// @nodoc
class __$InboxModelCopyWithImpl<$Res>
    implements _$InboxModelCopyWith<$Res> {
  __$InboxModelCopyWithImpl(this._self, this._then);

  final _InboxModel _self;
  final $Res Function(_InboxModel) _then;

/// Create a copy of InboxModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? chatId = null,Object? chatWith = null,Object? chatWithName = null,Object? chatWithPhotoUrl = freezed,Object? lastMessage = null,Object? lastSenderId = null,Object? lastTimestamp = null,Object? unreadCount = null,}) {
  return _then(_InboxModel(
chatId: null == chatId ? _self.chatId : chatId // ignore: cast_nullable_to_non_nullable
as String,chatWith: null == chatWith ? _self.chatWith : chatWith // ignore: cast_nullable_to_non_nullable
as String,chatWithName: null == chatWithName ? _self.chatWithName : chatWithName // ignore: cast_nullable_to_non_nullable
as String,chatWithPhotoUrl: freezed == chatWithPhotoUrl ? _self.chatWithPhotoUrl : chatWithPhotoUrl // ignore: cast_nullable_to_non_nullable
as String?,lastMessage: null == lastMessage ? _self.lastMessage : lastMessage // ignore: cast_nullable_to_non_nullable
as String,lastSenderId: null == lastSenderId ? _self.lastSenderId : lastSenderId // ignore: cast_nullable_to_non_nullable
as String,lastTimestamp: null == lastTimestamp ? _self.lastTimestamp : lastTimestamp // ignore: cast_nullable_to_non_nullable
as DateTime,unreadCount: null == unreadCount ? _self.unreadCount : unreadCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
