import 'package:json_annotation/json_annotation.dart';
part 'message_model.g.dart';

@JsonSerializable()
class MessageModel {
  DateTime timestamp;
  String content;
  bool isUser;
  bool istyping;
  bool isanimated;
  bool isStopped;
  bool isSkipped;

  MessageModel({
    required this.timestamp,
    required this.content,
    required this.isUser,
    required this.istyping,
    this.isStopped = false,
    this.isanimated = false,
    this.isSkipped = false,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);
  Map<String, dynamic> toJson() => _$MessageModelToJson(this);
}
