// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WordModel _$WordModelFromJson(Map<String, dynamic> json) => WordModel(
  word: json['word'] as String,
  translation: json['translation'] as String,
  example: json['example'] as String,
);

Map<String, dynamic> _$WordModelToJson(WordModel instance) => <String, dynamic>{
  'word': instance.word,
  'translation': instance.translation,
  'example': instance.example,
};
