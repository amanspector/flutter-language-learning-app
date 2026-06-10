class MessageModel {
  DateTime timestamp;
  String content;
  bool isUser;
  bool isTyping;
  bool isAnimated;
  bool isStopped;
  bool isSkipped;

  MessageModel({
    required this.timestamp,
    required this.content,
    required this.isUser,
    required this.isTyping,
    this.isStopped = false,
    this.isAnimated = false,
    this.isSkipped = false,
  });

  factory MessageModel.fromjson(Map<String, dynamic> json) => MessageModel(
    timestamp: DateTime.parse(json['timestamp'] as String),
    content: json['content'] as String,
    isUser: json['isUser'] as bool,
    isTyping: json['isTyping'] as bool,
    isStopped: json['isStopped'] as bool? ?? false,
    isAnimated: json['isAnimated'] as bool? ?? false,
    isSkipped: json['isSkipped'] as bool? ?? false,
  );

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'content': content,
      'isUser': isUser,
      'isTyping': isTyping,
      'isAnimated': isAnimated,
      'isStopped': isStopped,
      'isSkipped': isSkipped,
    };
  }
}
