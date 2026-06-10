import 'package:cloud_firestore/cloud_firestore.dart';

class VocabularyProgressModel {
  final int lastIndex;
  final Set<String> seenWords;
  final int streakDays;
  final int totalXP;
  final DateTime? lastUpdated;

  VocabularyProgressModel({
    required this.lastIndex,
    required this.seenWords,
    required this.streakDays,
    required this.totalXP,
    this.lastUpdated,
  });

  factory VocabularyProgressModel.fromJson(Map<String, dynamic> json) {
    return VocabularyProgressModel(
      lastIndex: json['lastIndex'] ?? 0,
      seenWords: Set<String>.from(json['seenWords'] ?? []),
      streakDays: json['streakDays'] ?? 0,
      totalXP: json['totalXP'] ?? 0,
      lastUpdated: (json['lastUpdated'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "lastIndex": lastIndex,
      "seenWords": seenWords.toList(),
      "streakDays": streakDays,
      "totalXP": totalXP,
      "lastUpdated": lastUpdated,
    };
  }
}
