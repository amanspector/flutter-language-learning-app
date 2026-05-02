import 'package:json_annotation/json_annotation.dart';

part 'chat_model.g.dart';

@JsonSerializable()
class ChatModel {
  String chatid;
  String title;
  DateTime timestamp;

  ChatModel({
    required this.chatid,
    required this.title,
    required this.timestamp,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) =>
      _$ChatModelFromJson(json);
  Map<String, dynamic> tojson() => _$ChatModelToJson(this);
}
