import 'dart:developer';

import 'package:chatbot_app/modules/vocabularypage/model/word_example.dart';

class WordModel {
  final String word;
  final String translationEnglish;
  final String translationNative;
  final String partOfSpeech;
  final String pronunciation;
  final List<WordExample> examples;
  // final String difficulty;
  final String theme;
  final String question;
  final String correctAnswer;
  int srsInterval;
  int srsRepetitions;
  DateTime srsNextReview;
  final List<String> options;
  final List<String> sentenceParts;

  WordModel({
    required this.word,
    required this.translationEnglish,
    required this.translationNative,
    required this.partOfSpeech,
    required this.pronunciation,
    required this.examples,
    // required this.difficulty,
    required this.theme,
    required this.question,
    required this.correctAnswer,
    this.srsInterval = 1,
    this.srsRepetitions = 0,
    required this.options,
    required this.sentenceParts,
    DateTime? srsNextReview,
  }) : srsNextReview = srsNextReview ?? DateTime.now();

  factory WordModel.fromJson(Map<String, dynamic> json) {
    return WordModel(
      word: json['word']?.toString() ?? '',
      translationEnglish: json['translation_english']?.toString() ?? '',
      translationNative: json['translation_native']?.toString() ?? '',
      partOfSpeech: json['part_of_speech']?.toString() ?? '',
      pronunciation: json['pronunciation']?.toString() ?? '',
      examples:
          (json['examples'] as List<dynamic>?)
              ?.map((e) => WordExample.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      // difficulty: json['difficulty']?.toString() ?? '',
      theme: json['theme']?.toString() ?? '',
      question: json['question']?.toString() ?? '',
      options:
          (json['options'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          <String>[],
      correctAnswer: json['correct_answer']?.toString() ?? '',
      // In fromJson:
      srsInterval: json['srs_interval'] ?? 1,
      srsRepetitions: json['srs_repetitions'] ?? 0,
      srsNextReview: json['srs_next_review'] != null
          ? DateTime.parse(json['srs_next_review'])
          : DateTime.now(),
      sentenceParts:
          (json['sentence_parts'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          <String>[],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'word': word,
      'translation_english': translationEnglish,
      'translation_native': translationNative,
      'part_of_speech': partOfSpeech,
      'pronunciation': pronunciation,
      'examples': examples.map((e) => e.toJson()).toList(),
      // 'difficulty': difficulty,
      'theme': theme,
      'srs_interval': srsInterval,
      'srs_repetitions': srsRepetitions,
      'srs_next_review': srsNextReview.toIso8601String(),
      'question': question,
      'options': options,
      'correct_answer': correctAnswer,
      'sentence_parts': sentenceParts,
    };
  }

  WordExample? exampleForRep(int rep) {
    if (examples.isEmpty) return null;
    if (rep <= 1) {
      log("SRS: easy example, rep=$rep");
      return examples[0];
    }
    if (rep <= 4) {
      log("SRS: medium example, rep=$rep");
      return examples.length > 1 ? examples[1] : examples[0];
    }
    log("SRS: hard example, rep=$rep");
    return examples.last;
  }

  // Keep these for backward compatibility:
  String get example => examples.isNotEmpty ? examples[0].sentence : '';
  String get exampleTranslation =>
      examples.isNotEmpty ? examples[0].translationNative : '';

  String get translation => translationNative; // Falls back to native
  // String get exampleTranslation => exampleTranslationNative;
}
