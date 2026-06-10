class ChatModel {
  String chatid;
  String title;
  DateTime timestamp;

  ChatModel({
    required this.chatid,
    required this.title,
    required this.timestamp,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      chatid: json['chatid'] as String,
      title: json['title'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chatid': chatid,
      'title': title,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
