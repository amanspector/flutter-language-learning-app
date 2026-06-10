import 'package:chatbot_app/core/extensions/localization_extension.dart';
import 'package:flutter/material.dart';

class DailyGoal {
  final String code;
  final int words;
  static const String txt_casual = "Casual";
  static const String txt_regular = "Regular";
  static const String txt_serious = "Serious";
  static const String txt_intense = "Intense";

  const DailyGoal({required this.code, required this.words});

  String get promptLabel => '$code ($words words/session)';

  String localizedLabel(BuildContext context) {
    switch (code) {
      case "Casual":
        return '${context.l10n.casual} ($words ${context.l10n.wordsExercise})';
      case "Regular":
        return '${context.l10n.regular} ($words ${context.l10n.wordsExercise})';
      case "Serious":
        return '${context.l10n.serious} ($words ${context.l10n.wordsExercise})';
      case "Intense":
        return '${context.l10n.intense} ($words ${context.l10n.wordsExercise})';
      default:
        return '$code ($words words)';
    }
  }

  static int getMaxWordsForGoal(String? dailyGoal) {
    switch (dailyGoal) {
      case txt_casual:
        return 10;
      case txt_regular:
        return 20;
      case txt_serious:
        return 25;
      case txt_intense:
        return 30;
      default:
        return 10;
    }
  }

  static const List<DailyGoal> all = [
    DailyGoal(code: "Casual", words: 10),
    DailyGoal(code: "Regular", words: 20),
    DailyGoal(code: "Serious", words: 25),
    DailyGoal(code: "Intense", words: 30),
  ];

  static DailyGoal fromCode(String code) =>
      all.firstWhere((g) => g.code == code, orElse: () => all.first);
}
