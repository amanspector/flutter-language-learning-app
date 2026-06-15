class WordExample {
  final String sentence;
  String? translationEnglish;
  final String translationNative;
  final String level; // easy, medium, hard
  final List<String> sentenceParts;

  WordExample({
    required this.sentence,
    this.translationEnglish,
    required this.translationNative,
    required this.level,
    required this.sentenceParts,
  });

  factory WordExample.fromJson(Map<String, dynamic> json) => WordExample(
    sentence: json['sentence']?.toString() ?? '',
    translationEnglish: json['translation_english']?.toString() ?? '',
    translationNative: json['translation_native']?.toString() ?? '',
    level: json['level']?.toString() ?? 'easy',
    sentenceParts:
        (json['sentence_parts'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        <String>[],
  );

  Map<String, dynamic> toJson() => {
    'sentence': sentence,
    'translation_english': translationEnglish ?? " ",
    'translation_native': translationNative,
    'level': level,
    'sentence_parts': sentenceParts,
  };
}
