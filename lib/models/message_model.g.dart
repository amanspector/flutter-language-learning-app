// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageModel _$MessageModelFromJson(Map<String, dynamic> json) => MessageModel(
  timestamp: DateTime.parse(json['timestamp'] as String),
  content: json['content'] as String,
  isUser: json['isUser'] as bool,
  istyping: json['istyping'] as bool,
  isStopped: json['isStopped'] as bool? ?? false,
  isanimated: json['isanimated'] as bool? ?? false,
  isSkipped: json['isSkipped'] as bool? ?? false,
);

Map<String, dynamic> _$MessageModelToJson(MessageModel instance) =>
    <String, dynamic>{
      'timestamp': instance.timestamp.toIso8601String(),
      'content': instance.content,
      'isUser': instance.isUser,
      'istyping': instance.istyping,
      'isanimated': instance.isanimated,
      'isStopped': instance.isStopped,
      'isSkipped': instance.isSkipped,
    };
