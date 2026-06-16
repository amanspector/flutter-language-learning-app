import 'dart:math';
import 'dart:developer' as dev;
import 'package:chatbot_app/core/widgets/app_loading_screen.dart';
import 'package:chatbot_app/generated/l10n.dart';
import 'package:chatbot_app/modules/exercisepage/model/exercise_model.dart';
import 'package:chatbot_app/modules/vocabularypage/provider/vocab_provider.dart';
import 'package:provider/provider.dart';
import '../screen/resultscreen.dart';
import 'package:chatbot_app/modules/vocabularypage/service/firebase_vocab_service.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import '../../vocabularypage/model/word_model.dart';

class LessonProvider extends ChangeNotifier {
  List<WordModel> lessonWords = [];
  List<ExerciseModel> exercises = [];

  int currentWordIndex = 0;
  bool showMeaning = false;
  LessonPhase currentPhase = LessonPhase.introduction;

  int currentExerciseIndex = 0;
  int score = 0;
  bool isAnswered = false;
  // bool isnextword = false;
  String? selectedAnswer;
  bool isCorrect = false;

  Set<String> masteredWords = {};
  Set<String> needReviewWords = {};

  bool isLoading = false;
  bool isDragable = false;
  String? errorMessage;

  int dailyGoalMinutes = 10;
  // bool get isIntroductionComplete => currentWordIndex >= lessonWords.length;
  // bool get isLessonComplete => currentExerciseIndex >= exercises.length;
  // int get totalWords => lessonWords.length;
  int get totalExercises => exercises.length;
  int get xpEarned => score * 10;
  List<String?> arrangedSentence = [];
  bool hasAnimatedResult = false;

  List<String> animatedWords = [];
  int? _lastAnimatedExerciseIndex;

  bool shouldAnimateQuestion(int exerciseIndex) {
    return _lastAnimatedExerciseIndex != exerciseIndex;
  }

  void markQuestionAnimated(int exerciseIndex) {
    _lastAnimatedExerciseIndex = exerciseIndex;
  }

  WordModel? get currentWord {
    if (lessonWords.isEmpty || currentWordIndex >= lessonWords.length) {
      return null;
    }
    return lessonWords[currentWordIndex];
  }

  ExerciseModel? get currentExercise {
    if (exercises.isEmpty || currentExerciseIndex >= exercises.length) {
      return null;
    }
    return exercises[currentExerciseIndex];
  }

  Map<int, String> placedWords = {}; // index -> word mapping

  void placeWordInSlot(int slotIndex, int wordIndex) {
    if (placedWords.containsKey(wordIndex)) {
      dev.log("⚠️ Word at index $wordIndex is already placed");
      return; // Don't allow placing same word instance twice
    }
    final word = currentExercise!.options[wordIndex];
    arrangedSentence[slotIndex] = word;
    placedWords[wordIndex] = word; // Track which word index is used
    notifyListeners();
  }

  void removeWordFromSlot(int slotIndex) {
    final wordIndexToRemove = placedWords.entries
        .firstWhere(
          (entry) => arrangedSentence[slotIndex] == entry.value,
          orElse: () => MapEntry(-1, ''),
        )
        .key;

    if (wordIndexToRemove != -1) {
      placedWords.remove(wordIndexToRemove); // Free the word
    }

    arrangedSentence[slotIndex] = null; // Clear the slot
    notifyListeners();
  }

  void checkSentenceArrangement(BuildContext context) {
    final userSentence = arrangedSentence.join(' ');
    isAnswered = true;
    isCorrect = userSentence == currentExercise!.correctAnswer;
    String text = currentExercise!.questionWithoutBlank;
    String lang = context.read<VocabProvider>().currentlanguage!;
    String speaker = context.read<VocabProvider>().currentspeaker;

    if (isCorrect) {
      dev.log("Text : $text");
      dev.log("Language : $lang");
      score++;
    } else {
      Vibration.vibrate(pattern: [0, 100, 50, 100]);
    }

    context.read<VocabProvider>().speak(
      text: text,
      language: lang,
      speaker: speaker,
    );

    final testedWord = _getTestedWord(currentExercise!);
    dev.log(testedWord.toString());
    if (testedWord != null) {
      dev.log("SRS card updated............");
      _updateSrsCard(testedWord, isCorrect);
    }
    dev.log("✅ isCorrect: $isCorrect");
    dev.log("📊 score: $score");
    dev.log("📝 testedWord: ${currentExercise!.questionWithoutBlank}");
    notifyListeners();
  }

  // Initialize when starting exercise
  void _initializeArrangement() {
    final exercise = currentExercise;
    if (exercise == null) return;
    dev.log("Exercise type : ${exercise.type}");

    if (exercise.type == ExerciseType.sentenceArrangement) {
      arrangedSentence = List.filled(currentExercise!.options.length, null);
      dev.log(
        "✅ Initialized arrangedSentence with ${exercise.options.length} slots",
      );
    } else {
      arrangedSentence = [];
    }
  }

  Future<void> startLesson({
    required BuildContext con,
    required int userDailyGoalMinutes,
    required List<WordModel> words,
  }) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();
      dailyGoalMinutes = userDailyGoalMinutes;
      resetLesson();
      lessonWords = words;
      if (lessonWords.isEmpty) {
        throw Exception("No words available.");
      }

      generateExercises(con);
      currentPhase = LessonPhase.introduction;
      isLoading = false;
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }

  void _updateSrsCard(WordModel word, bool isEasy) {
    if (isEasy) {
      word.srsInterval = switch (word.srsRepetitions) {
        0 => 1,
        1 => 3,
        _ => (word.srsInterval * 2).clamp(1, 60),
      };
      word.srsRepetitions++;
    } else {
      word.srsInterval = 1;
      word.srsRepetitions = 0;
    }
    word.srsNextReview = DateTime.now().add(Duration(days: word.srsInterval));
    FirebaseVocabService().updateSrsCard(word);
  }

  void initWordsFromVocab(List<WordModel> words) {
    lessonWords = List.from(words);
    currentWordIndex = 0;
    notifyListeners();
  }

  void nextWord() {
    animatedWords.clear();
    if (currentWordIndex < lessonWords.length - 1) {
      currentWordIndex++;
      showMeaning = false;
      hasAnimatedResult = false;
      notifyListeners();
    }
  }

  void previousWord() {
    if (currentWordIndex > 0) {
      currentWordIndex--;
      showMeaning = false;
      notifyListeners();
    }
  }

  void toggleMeaning() {
    showMeaning = !showMeaning;
    notifyListeners();
  }

  void startPractice(BuildContext con) {
    generateExercises(con);
    currentPhase = LessonPhase.exercise;
    currentExerciseIndex = 0;
    _initializeArrangement();
    notifyListeners();
  }

  // void generateExercises(BuildContext con) {
  //   exercises.clear();
  //   masteredWords.clear();
  //   needReviewWords.clear();
  //   notifyListeners();

  //   // for (int i = 0; i < lessonWords.length; i++) {
  //   //   final word = lessonWords[i];

  //   //   if (i % 3 == 0) {
  //   //     exercises.add(_createFillInBlank(word, i, con));
  //   //   } else if (i % 3 == 1) {
  //   //     exercises.add(_createSentenceArrangement(word, i, con));
  //   //   } else {
  //   //     exercises.add(_createTranslationMCQ(word, i));
  //   //   }
  //   // }

  //   for (final word in lessonWords) {
  //     // final rep = word.srsRepetitions;

  //     // All 3 types every session, but sentence difficulty scales with rep
  //     exercises.add(_createFillInBlank(word, exercises.length, con));
  //     exercises.add(_createSentenceArrangement(word, exercises.length, con));
  //     exercises.add(_createTranslationMCQ(word, exercises.length));
  //   }
  //   exercises.shuffle(Random());
  //   notifyListeners();
  //   dev.log("✅ Generated ${exercises.length} exercises");
  // }

  void generateExercises(BuildContext con) {
    exercises.clear();
    masteredWords.clear();
    needReviewWords.clear();

    final shuffledWords = List<WordModel>.from(lessonWords)..shuffle(Random());
    final totalWords = shuffledWords.length;

    // Add new exercise types here in future — everything auto-adjusts
    final exerciseTypes = [
      ExerciseType.fillInBlank,
      ExerciseType.sentenceArrangement,
      ExerciseType.translationMCQ,
    ];

    final typeCount = exerciseTypes.length;
    final baseSize = totalWords ~/ typeCount;
    final remainder = totalWords % typeCount;

    final typeForWord = <ExerciseType>[];
    for (int t = 0; t < typeCount; t++) {
      final count = baseSize + (t < remainder ? 1 : 0);
      typeForWord.addAll(List.filled(count, exerciseTypes[t]));
    }
    typeForWord.shuffle(Random()); // random order, equal count

    dev.log(
      "📊 Distribution: ${exerciseTypes.map((t) => '${t.name}:${typeForWord.where((x) => x == t).length}').join(', ')}",
    );

    for (int i = 0; i < totalWords; i++) {
      final word = shuffledWords[i];
      final type = typeForWord[i];

      switch (type) {
        case ExerciseType.fillInBlank:
          exercises.add(_createFillInBlank(word, i, con));
        case ExerciseType.sentenceArrangement:
          exercises.add(_createSentenceArrangement(word, i, con));
        case ExerciseType.translationMCQ:
          exercises.add(_createTranslationMCQ(word, i));
      }
    }

    notifyListeners();
    dev.log("✅ ${totalWords} words → ${exercises.length} exercises");
  }

  ExerciseModel _createSentenceArrangement(
    WordModel word,
    int index,
    BuildContext con,
  ) {
    try {
      _initializeArrangement();

      final currentExample = word.exampleForRep(word.srsRepetitions);
      final currentSentence = currentExample?.sentence ?? word.example;
      final currentTranslation =
          currentExample?.translationNative ?? word.exampleTranslation;

      final sentenceParts = (currentExample?.sentenceParts.isNotEmpty == true)
          ? currentExample!.sentenceParts
          : currentSentence.split(' ');
      final shuffledParts = List<String>.from(sentenceParts)..shuffle(Random());

      return ExerciseModel(
        id: 'ex_${index}_arrange',
        type: ExerciseType.sentenceArrangement,
        question: S.of(con).arrangeWordsToForm(currentTranslation), // ← updated
        questionWithoutBlank: currentSentence, // ← updated
        options: shuffledParts,
        correctAnswer: currentSentence, // ← updated
        explanation: "Correct order: $currentSentence", // ← updated
      );
    } catch (e) {
      throw Error();
    }
  }

  ExerciseModel _createFillInBlank(
    WordModel word,
    int index,
    BuildContext con,
  ) {
    try {
      final currentExample = word.exampleForRep(word.srsRepetitions);
      final sentence = currentExample?.sentence ?? word.example;
      String question;
      String questionWithoutBlank;
      dev.log("sentence : $sentence");
      dev.log("Word : ${word.word}");

      if (sentence.toLowerCase().contains(word.word.toLowerCase())) {
        question = sentence.replaceFirst(
          RegExp(RegExp.escape(word.word), caseSensitive: false),
          "_____",
        );
        questionWithoutBlank = sentence;
      }
      // if (sentence.contains(word.word)) {
      //   question = sentence.replaceFirst(word.word, "_____");
      //   questionWithoutBlank = sentence;
      // }
      else {
        question = S.of(con).fillInTheBlank(word.translation);
        questionWithoutBlank = word.word;
      }

      final allOptions = List<String>.from(word.options)..shuffle(Random());

      String exactMatchingOption = word.correctAnswer.isNotEmpty
          ? word.correctAnswer
          : word.word;

      List<String> answerParts = word.word.trim().split(' ');

      for (String part in answerParts) {
        if (allOptions.any(
          (option) => option.toLowerCase().trim() == part.toLowerCase().trim(),
        )) {
          exactMatchingOption = part;
          break;
        }
      }

      return ExerciseModel(
        id: 'ex_${index}_fill',
        type: ExerciseType.fillInBlank,
        question: question,
        questionWithoutBlank: questionWithoutBlank,
        options: allOptions,
        correctAnswer: exactMatchingOption,
        explanation: "${word.correctAnswer} : ${word.translation}",
        nativeTranslation: word.exampleTranslation,
      );
    } catch (e) {
      throw Error();
    }
  }

  void setIsDragable(bool isdrag) {
    isDragable = isdrag;
    notifyListeners();
  }

  void selectAnswer(String answer) {
    dev.log(answer);

    if (!isAnswered) {
      selectedAnswer = answer;
      dev.log("inside condiiton : $answer");
      notifyListeners();
    }
  }

  void checkAnswer(VocabProvider vocabprovider) {
    if (selectedAnswer == null || isAnswered) return;

    isAnswered = true;
    final universalRegex = RegExp(r'[¿¡!?,.\-\s\u064B-\u0652]');
    String sanitize(String input) {
      return input.characters
          .toString()
          .toLowerCase()
          .replaceAll(universalRegex, '') // Removes trailing/leading symbols
          .trim(); // Extra space protection
    }

    isCorrect =
        sanitize(selectedAnswer!) == sanitize(currentExercise!.correctAnswer);
    // selectedAnswer?.trim().toLowerCase() ==
    //     currentExercise?.correctAnswer.trim().toLowerCase();
    dev.log(selectedAnswer ?? "selectedAnswer is null");
    dev.log(
      currentExercise?.correctAnswer.toLowerCase() ??
          "currentExercise correctAnswer is null",
    );

    final testword = _getTestedWord(currentExercise!);

    if (testword == null) {
      dev.log("------------------------------lesson_provider testword is null");
      notifyListeners();
      return;
    }

    if (isCorrect) {
      score += 1;

      if (!masteredWords.contains(testword.word)) {
        masteredWords.add(testword.word);
      }
      needReviewWords.remove(testword.word);
    } else {
      if (!needReviewWords.contains(testword.word)) {
        needReviewWords.add(testword.word);
      }
      masteredWords.remove(testword.word);
    }

    _updateSrsCard(testword, isCorrect);

    dev.log("🎯 correctAnswer: ${currentExercise?.correctAnswer}");
    dev.log("👆 selectedAnswer: $selectedAnswer");
    dev.log(
      "🔤 sanitized correct: ${sanitize(currentExercise!.correctAnswer)}",
    );
    dev.log("🔤 sanitized selected: ${sanitize(selectedAnswer!)}");
    dev.log("✅ isCorrect: $isCorrect");
    dev.log("📊 score: $score");
    dev.log("🏆 masteredWords: $masteredWords");
    dev.log("🔄 needReviewWords: $needReviewWords");
    dev.log("📝 testedWord: ${testword.word}");
    hasAnimatedResult = true;

    vocabprovider.speak(
      text: currentExercise!.questionWithoutBlank,
      language: vocabprovider.currentlanguage!,
      speaker: vocabprovider.currentspeaker,
    );
    notifyListeners();
  }

  WordModel? _getTestedWord(ExerciseModel exercise) {
    dev.log("Exercise id : ${exercise.id}");
    dev.log("Exercise question : ${exercise.question}");
    dev.log("Exercise correctAnswer : ${exercise.correctAnswer}");
    dev.log(
      "Exercise question without blank : ${exercise.questionWithoutBlank}",
    );
    dev.log("Exercise options : ${exercise.options.toString()}");
    dev.log("Exercise type :${exercise.type.toString()}");

    try {
      final word = lessonWords.firstWhere(
        (w) =>
            w.word == exercise.correctAnswer ||
            w.correctAnswer == exercise.correctAnswer ||
            w.translation == exercise.correctAnswer ||
            w.options.contains(exercise.correctAnswer) ||
            w.translationNative == exercise.correctAnswer || // ✅ add
            w.examples.any(
              (e) => e.translationNative == exercise.correctAnswer,
            ), // ✅ add
      );
      return word;
    } catch (_) {
      dev.log("_getTestedWord returned null for: ${exercise.correctAnswer}");
      return null;
    }
  }

  ExerciseModel _createTranslationMCQ(WordModel word, int index) {
    try {
      final currentExample = word.exampleForRep(word.srsRepetitions);
      dev.log("current example : $currentExample");

      dev.log("srsRepetitions: ${word.srsRepetitions}");
      dev.log("examples length: ${word.examples.length}");
      dev.log("examples: ${word.examples.map((e) => e.sentence).toList()}");
      final correctAnswer =
          currentExample?.translationNative ?? word.exampleTranslation;
      dev.log("Correct Answer : $correctAnswer");

      final nativeSentence = currentExample?.sentence ?? word.example;
      dev.log("Native sentence : $nativeSentence");

      final otherWords = lessonWords.where((w) => w.word != word.word).toList()
        ..shuffle(Random());

      dev.log("other words : $otherWords");

      final wrongOptions = otherWords
          .take(3)
          .map(
            (w) =>
                w.exampleForRep(w.srsRepetitions)?.translationNative ??
                w.translationEnglish,
          )
          .where((s) => s != correctAnswer && s.isNotEmpty)
          .take(3)
          .toList();
      dev.log("wrong options : $wrongOptions");
      while (wrongOptions.length < 3) {
        wrongOptions.add("None of the above");
      }

      final allOptions = [correctAnswer, ...wrongOptions]..shuffle(Random());

      return ExerciseModel(
        id: 'ex_${index}_translation',
        type: ExerciseType.translationMCQ,
        question: nativeSentence,
        questionWithoutBlank: correctAnswer,
        options: allOptions,
        correctAnswer: correctAnswer,
        explanation: "Translation : $correctAnswer",
      );
    } catch (e) {
      throw Error();
    }
  }

  Future<void> nextExercise(BuildContext context) async {
    if (currentExerciseIndex < exercises.length - 1) {
      currentExerciseIndex++;
      _resetExerciseState();
      _initializeArrangement();
      notifyListeners();
    } else {
      AppLoadingScreen();
      try {
        await saveLessonResults();

        currentPhase = LessonPhase.result;
        notifyListeners();

        if (!context.mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => ResultScreen()),
        );
      } catch (e) {
        if (context.mounted) Navigator.pop(context);
        dev.log("Error saving results: $e");
      }
    }
  }

  Future<void> saveLessonResults() async {
    try {
      final totalQuestions = exercises.length;
      dev.log("📊 Lesson Results:");
      await FirebaseVocabService().saveLessonResults(
        masteredWords: masteredWords.toList(),
        needReviewWords: needReviewWords.toList(),
        score: score,
        totalQuestions: totalQuestions,
        xpEarned: xpEarned,
      );
      dev.log("✅ Lesson results saved to Firestore");
      dev.log("xpEarned : $xpEarned");
      dev.log("Score : $score");
    } catch (e) {
      dev.log("❌ Error saving results: $e");
    }
  }

  void _resetExerciseState() {
    isAnswered = false;
    selectedAnswer = null;
    isCorrect = false;
    arrangedSentence = [];
    placedWords = {};
  }

  void resetProgress() {
    currentExerciseIndex = 0;
    selectedAnswer = null;
    isAnswered = false;
    notifyListeners();
  }

  void resetLesson() {
    lessonWords.clear();
    exercises.clear();
    currentWordIndex = 0;
    currentExerciseIndex = 0;
    score = 0;
    showMeaning = false;
    masteredWords.clear();
    needReviewWords.clear();
    _resetExerciseState();
    currentPhase = LessonPhase.introduction;
  }

  void restartLesson() {
    currentExerciseIndex = 0;
    score = 0;
    masteredWords.clear();
    needReviewWords.clear();
    _resetExerciseState();
    _lastAnimatedExerciseIndex = null;
    currentPhase = LessonPhase.exercise;
    notifyListeners();
  }

  bool shouldAnimateWord(String word) {
    if (animatedWords.contains(word)) return false;
    animatedWords.add(word);
    return true;
  }

  void submitAnswer(String option, VocabProvider vocabprovider) {
    selectedAnswer = option;

    isCorrect = option == currentExercise!.correctAnswer;
    isAnswered = true;

    hasAnimatedResult = true;

    vocabprovider.speak(
      text: currentExercise!.question,
      language: vocabprovider.currentlanguage!,
      speaker: vocabprovider.currentspeaker,
    );

    notifyListeners();
  }
}

enum LessonPhase { introduction, exercise, result }
