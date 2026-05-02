import 'package:json_annotation/json_annotation.dart';

part 'word_model.g.dart';

@JsonSerializable()
class WordModel {
  final String word;
  final String translation;
  final String example;

  WordModel({
    required this.word,
    required this.translation,
    required this.example,
  });

  factory WordModel.fromJson(Map<String, dynamic> json) =>
      _$WordModelFromJson(json);

  Map<String, dynamic> toJson() => _$WordModelToJson(this);
}
