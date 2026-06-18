enum ExerciseType { fillInBlank, sentenceArrangement, translationMCQ }

class ExerciseModel {
  final String id;
  final ExerciseType type;
  final String question;
  final String questionWithoutBlank;
  final List<String> options;
  final String correctAnswer;
  final String explanation;
  String? nativeTranslation;
  String? userAnswer; // 👈
  bool? isCorrect;

  ExerciseModel({
    required this.id,
    required this.type,
    required this.question,
    required this.questionWithoutBlank,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
    this.nativeTranslation,
    this.userAnswer,
    this.isCorrect,
  });
}
