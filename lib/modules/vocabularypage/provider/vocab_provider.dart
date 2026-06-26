import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chatbot_app/core/extensions/daily_goal_extension.dart';
import 'package:chatbot_app/core/widgets/app_customContainer.dart';
import 'package:chatbot_app/modules/onboarding/provider/onboard_provider.dart';
import 'package:chatbot_app/modules/chatbotpage/repo/gemini_repo.dart';
import 'package:chatbot_app/modules/vocabularypage/model/word_model.dart';
import 'package:chatbot_app/modules/vocabularypage/screen/vocabCompletedScreen.dart';
import 'package:chatbot_app/modules/vocabularypage/service/firebase_vocab_service.dart';
import 'package:chatbot_app/modules/vocabularypage/service/tts_service.dart';
import 'package:chatbot_app/modules/vocabularypage/service/vocabulary_prompts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';

class VocabProvider extends ChangeNotifier {
  List<WordModel> allWords = [];
  List<WordModel> todaywords = [];
  DocumentSnapshot? lastFetchedDoc;
  String? currentExperienceLevel;
  String? currentCategory;
  final Map<String, Uint8List> cache = {};
  int currentIndex = 0;
  bool showMeaning = false;
  bool ismovingforward = true;
  bool iscompleted = false;
  bool isloadingAidata = false;
  bool isspeaking = false;
  bool generationFailed = false;
  String? speakingKey;
  String? currentlanguage;
  String currentspeaker = "ishita";
  String? dailygoalString;
  // int? length;
  GeminiRepo repo = GeminiRepo();
  final FlutterTts _tts = FlutterTts();
  final TTSService _ttsService = TTSService();
  final AudioPlayer _player = AudioPlayer();
  Timer? _navigationDebounceTimer;
  int maxWordsForLevel = 10;

  Future<void> speak({
    String? speaker,
    required String text,
    required String language,
    String type = "word",
  }) async {
    final key = "$text-$language-$type";
    if (speakingKey == key) return;
    speakingKey = key;
    log("speakingKey : $speakingKey!");
    log("key : $key");
    notifyListeners();

    try {
      isspeaking = true;
      notifyListeners();
      if (isspeaking) {
        await _tts.stop();
        await _player.stop();
      }
      final isIndianLang = _ttsService.isIndian(language);
      if (!isIndianLang) {
        await _ttsService.speakWithFlutterTts(text, language);
        return;
      }

      final cacheKey = "$text-$language";
      Uint8List? audio = cache[cacheKey];

      if (audio == null) {
        if (speaker == null) {
          throw Exception("Speaker required for Indian languages");
        }

        audio = await _ttsService.getAudioUrl(text, language, speaker);
        if (audio != null) {
          cache[cacheKey] = audio;
        }
      }
      if (audio != null) {
        await _ttsService.playAudio(audio);
      } else {
        await _ttsService.speakWithFlutterTts(text, language);
      }
    } catch (e) {
      log("Speak error: $e");
    } finally {
      speakingKey = null;
      isspeaking = false;
      notifyListeners();
    }
  }

  void setSpeaking(bool value) {
    isspeaking = value;
    notifyListeners();
  }

  Future<void> initTTS() async {
    await _tts.setLanguage("es-ES");
    await _tts.setSpeechRate(0.4);
  }

  Future<List<WordModel>> _fetchUntilUnlearnedTarget(
    int target,
    OnboardProvider onboard,
    String experienceLevel,
    String category,
  ) async {
    List<WordModel> unlearnedWords = [];
    List<String> learnedIds = await FirebaseVocabService().getLearnedWords(
      onboard.learningLanguageCode,
    );

    // Check cached words first
    final cachedUnlearned = allWords
        .where((w) => !learnedIds.contains(w.word))
        .toList();
    unlearnedWords.addAll(cachedUnlearned);

    // Fetch from Firebase until we have enough
    while (unlearnedWords.length < target) {
      final result = await FirebaseVocabService.fetchVocabfromai(
        onboard.learningLanguageCode,
        experienceLevel,
        category,
        startAfterDoc: lastFetchedDoc,
      );

      if (result.words.isEmpty) break;

      lastFetchedDoc = result.lastDoc;
      final newWords = result.words.map((e) => WordModel.fromJson(e)).toList();

      for (var w in newWords) {
        if (!allWords.any((existing) => existing.word == w.word)) {
          allWords.add(w);
        }
      }

      final filtered = newWords
          .where((w) => !learnedIds.contains(w.word))
          .toList();
      unlearnedWords.addAll(filtered);
    }

    return unlearnedWords;
  }

  Future<void> loadWords({
    required String ttslangauage,
    required String experienceLevel,
    required String category,
    required OnboardProvider onboard,
    String? speaker,
  }) async {
    if (isloadingAidata || todaywords.isNotEmpty) {
      log("Already loading data, skipping...");
      return;
    }

    try {
      isloadingAidata = true;
      notifyListeners();
      log("LOAD WORDS CALLED");

      currentlanguage = ttslangauage;
      currentExperienceLevel = experienceLevel;
      currentCategory = category;

      allWords.clear();
      todaywords.clear();
      lastFetchedDoc = null;

      // Always update from the current language's goal (not stale from a previous language)
      dailygoalString = onboard.selectedDailyGoal;
      maxWordsForLevel = DailyGoal.getMaxWordsForGoal(dailygoalString);

      log("maxWordsForLevel: $maxWordsForLevel");
      log("dailygoalString: $dailygoalString");

      final unlearnedWords = await _fetchUntilUnlearnedTarget(
        maxWordsForLevel,
        onboard,
        experienceLevel,
        category,
      );

      if (unlearnedWords.length < maxWordsForLevel) {
        log(" Unlearned words length : ${unlearnedWords.length}");
        log("No unlearned words, generating new batch...");
        log("Maxwordforlvel : ${maxWordsForLevel.toString()}");
        log("dailygoalString : $dailygoalString");
        await generateWordsFromAI(onboard);
        if (generationFailed) {
          log("Generation failed, stopping loadWords");
          return;
        }
        if (allWords.isEmpty) {
          log("Failed to generate words");
          isloadingAidata = false;
          notifyListeners();
          return;
        }

        final newUnlearnedWords = await FirebaseVocabService()
            .getUnlearnedWords(
              allWords: allWords,
              language: onboard.learningLanguageCode,
            );
        log(
          "✅ New unlearn words after generation: ${newUnlearnedWords.length}",
        );
        todaywords = await _mixSrsAndNewWords(
          newUnlearnedWords,
          onboard.learningLanguageCode,
          level: experienceLevel,
          category: category,
        );
        todaywords.shuffle();
        log("✅ Today's words after generation: ${todaywords.length}");
      } else {
        todaywords = await _mixSrsAndNewWords(
          unlearnedWords,
          onboard.learningLanguageCode,
          level: experienceLevel,
          category: category,
        );
        todaywords.shuffle();
        if (todaywords.length < maxWordsForLevel) {
          log("Mixed words still less than goal, generating more...");
          await generateWordsFromAI(onboard);
          if (!generationFailed && allWords.isNotEmpty) {
            final newUnlearnedWords = await FirebaseVocabService()
                .getUnlearnedWords(
                  allWords: allWords,
                  language: onboard.learningLanguageCode,
                );
            todaywords = await _mixSrsAndNewWords(
              newUnlearnedWords,
              onboard.learningLanguageCode,
              level: experienceLevel,
              category: category,
            );
            todaywords.shuffle();
          }
        }
      }

      currentIndex = 0;
      showMeaning = false;
      iscompleted = false;

      log("todaywords :- $todaywords");
      log(todaywords.toString());
      await initTTS();
      await _ttsService.stopPlayer();
      if (todaywords.isNotEmpty) {
        preloadWordByIndex(currentIndex, ttslangauage, speaker);
        preloadWordByIndex(currentIndex + 1, ttslangauage, speaker);
      }
    } catch (e) {
      log("Error loading words: $e");
    } finally {
      isloadingAidata = false;
      notifyListeners();
    }
  }

  Future<List<WordModel>> _mixSrsAndNewWords(
    List<WordModel> unlearnedWords,
    String langaugeCode, {
    String? level,
    String? category,
  }) async {
    final total = maxWordsForLevel;

    final dueWords = await FirebaseVocabService().getDueSrsWords(
      langaugeCode,
      level: level,
      category: category,
    );

    dueWords.sort((a, b) => a.srsRepetitions.compareTo(b.srsRepetitions));

    if (dueWords.isEmpty) {
      log("SRS mix → no due words, serving 100% new");
      return unlearnedWords.take(total).toList();
    }

    final srsCount = (total * 0.4).round();
    final newCount = total - srsCount;

    final srsSlice = dueWords.take(srsCount).toList();
    final newSlice = unlearnedWords.take(newCount).toList();
    final mixed = [...srsSlice, ...newSlice];

    if (mixed.length < total) {
      final remainingDue = dueWords
          .where((w) => !mixed.any((m) => m.word == w.word))
          .take(total - mixed.length)
          .toList();
      mixed.addAll(remainingDue);
    }

    if (mixed.length < total) {
      final remainingUnlearned = unlearnedWords
          .where((w) => !mixed.any((m) => m.word == w.word))
          .take(total - mixed.length)
          .toList();
      mixed.addAll(remainingUnlearned);
    }

    log(
      "SRS mix → ${srsSlice.length} review + ${newSlice.length} new = ${mixed.length} total (overall due: ${dueWords.length})",
    );
    return mixed;
  }

  Future<void> preloadText(
    String text,
    String language,
    String? speaker,
  ) async {
    try {
      if (speaker == null) return;
      final key = "$text-$language";
      if (!cache.containsKey(key)) {
        final audio = await _ttsService.getAudioUrl(text, language, speaker);
        if (audio != null) cache[key] = audio;
      }
    } catch (e) {
      log("Preload failed for text: $e");
    }
  }

  Future<void> preloadWordByIndex(
    int targetIndex,
    String language,
    String? speaker,
  ) async {
    try {
      if (targetIndex < 0 ||
          targetIndex >= todaywords.length ||
          speaker == null) {
        return;
      }

      final wordData = todaywords[targetIndex];
      final wordKey = "${wordData.word}-$language";
      final exampleKey = "${wordData.example}-$language";

      if (!cache.containsKey(wordKey)) {
        final audio = await _ttsService.getAudioUrl(
          wordData.word,
          language,
          speaker,
        );
        if (audio != null) {
          cache[wordKey] = audio;
        }
      }

      if (!cache.containsKey(exampleKey)) {
        final audio = await _ttsService.getAudioUrl(
          wordData.example,
          language,
          speaker,
        );
        if (audio != null) {
          cache[exampleKey] = audio;
        }
      }
    } catch (e) {
      log("Preload failed for index $targetIndex: $e");
    }
  }

  Future<void> generateWordsFromAI(OnboardProvider onboard) async {
    int retryCount = 0;
    generationFailed = false;
    isloadingAidata = true;
    notifyListeners();

    const maxRetries = 3;
    List<String> learnedIds = await FirebaseVocabService().getLearnedWords(
      onboard.learningLanguageCode,
    );

    try {
      while (retryCount < maxRetries) {
        try {
          log(learnedIds.toString());
          log(
            "Generating words from AI (attempt ${retryCount + 1}/$maxRetries)",
          );

          final prompt = VocabularyPrompts.buildVocabularyPrompt(
            language: onboard.selectedlanguage ?? 'English',
            nativeLanguage: onboard.selectedNativeLanguage ?? 'en',
            experienceLevel: onboard.selectedExperienceLevel ?? 'Beginner',
            learningGoal: onboard.selectedgoal ?? 'travel',
            wordCount: maxWordsForLevel + 10,
            learnedWords: learnedIds,
            age: onboard.age,
          );
          log("prompt : $prompt");

          final stopwatch = Stopwatch()..start();
          final words = await repo
              .generateVocabulary(prompt)
              .timeout(Duration(seconds: 120));
          stopwatch.stop();

          if (words.isEmpty) {
            throw Exception("Generated word list is empty");
          }

          log("AI generation completed in ${stopwatch.elapsed.inSeconds} s");
          log("api called and stored to words variable");

          if (allWords.isNotEmpty) {
            allWords.addAll(words);
            log("📚 Total words after adding: ${allWords.length}");
          } else {
            allWords = words;
            log("📚 New word list: ${allWords.length}");
          }

          currentIndex = 0;
          iscompleted = false;

          await FirebaseVocabService.saveVocab(
            languageCode: onboard.learningLanguageCode,
            level: onboard.selectedExperienceLevel!,
            category: onboard.selectedgoal!,
            words: words,
          );

          await FirebaseVocabService().seedSrsCards(
            words,
            onboard.learningLanguageCode,
          );

          notifyListeners();
          return; // success — exit
        } catch (e) {
          retryCount++;
          log("AI generation error (attempt $retryCount/$maxRetries): $e");

          if (retryCount >= maxRetries) {
            log("Max retries reached. AI generation failed.");
            generationFailed = true;
            notifyListeners();
            return;
          }

          await Future.delayed(Duration(seconds: retryCount * 2));
        }
      }
    } finally {
      isloadingAidata = false; // runs once ✓
      notifyListeners();
    }
  }

  WordModel? get currentWord {
    if (todaywords.isEmpty || currentIndex >= todaywords.length) {
      return null;
    }
    return todaywords[currentIndex];
  }

  Future<void> loadNextBatch(OnboardProvider onboard) async {
    try {
      if (currentExperienceLevel == null || currentCategory == null) return;

      final unlearnedWords = await _fetchUntilUnlearnedTarget(
        maxWordsForLevel,
        onboard,
        currentExperienceLevel!,
        currentCategory!,
      );

      if (unlearnedWords.isEmpty || unlearnedWords.length < maxWordsForLevel) {
        todaywords.clear();

        await generateWordsFromAI(onboard);

        final newUnlearnedWords = await FirebaseVocabService()
            .getUnlearnedWords(
              allWords: allWords,
              language: onboard.learningLanguageCode,
            );
        log(
          "✅ New unlearn words after generation: ${newUnlearnedWords.length}",
        );

        todaywords = await _mixSrsAndNewWords(
          newUnlearnedWords,
          onboard.learningLanguageCode,
          level: currentExperienceLevel,
          category: currentCategory,
        );
        todaywords.shuffle();
        log(
          "✅ New today words after newUnlearnedWords: ${newUnlearnedWords.length}",
        );
      } else {
        todaywords = await _mixSrsAndNewWords(
          unlearnedWords,
          onboard.learningLanguageCode,
          level: currentExperienceLevel,
          category: currentCategory,
        );
        todaywords.shuffle();
        log("✅ today words without generating: ${todaywords.length}");
      }

      currentIndex = 0;
      iscompleted = false;

      notifyListeners();
    } catch (e) {
      log("Error in loadNextBatch: $e");
    }
  }

  void nextWord(String? speaker, BuildContext context) {
    if (currentIndex < todaywords.length - 1) {
      ismovingforward = true;
      currentIndex++;
      showMeaning = false;
      _ttsService.stopAllAudio();
      _navigationDebounceTimer?.cancel();
      _navigationDebounceTimer = Timer(Duration(milliseconds: 300), () {
        if (currentlanguage != null) {
          preloadWordByIndex(currentIndex, currentlanguage!, speaker);
          preloadWordByIndex(currentIndex + 1, currentlanguage!, speaker);
        }
      });
    } else {
      iscompleted = true;
      _navigationDebounceTimer?.cancel();
      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => Dialog(
            insetPadding: EdgeInsets.all(24),
            backgroundColor: Colors.transparent,
            child: CustomPaint(
              painter: TicketPainter(cornerRadius: 30),
              child: const Vocabcompletedscreen(),
            ),
          ),
        );
      }
    }
    notifyListeners();
  }

  void previousWord(String? speaker) {
    if (currentIndex > 0) {
      currentIndex--;
      ismovingforward = false;
      showMeaning = false;
      _ttsService.stopAllAudio();
      _navigationDebounceTimer?.cancel();

      _navigationDebounceTimer = Timer(Duration(milliseconds: 300), () {
        if (currentlanguage != null) {
          preloadWordByIndex(
            currentIndex,
            currentlanguage!,
            speaker ?? currentspeaker,
          );
        }
      });
    }
    notifyListeners();
  }

  void toggleMeaning() {
    showMeaning = !showMeaning;
    notifyListeners();
  }

  void restartLearning() {
    currentIndex = 0;
    iscompleted = false;
    showMeaning = false;
    notifyListeners();
  }

  void reset() {
    allWords.clear();
    todaywords.clear();
    cache.clear();
    currentIndex = 0;
    showMeaning = false;
    speakingKey = null;
    isloadingAidata = false;
    iscompleted = false;
    generationFailed = false;
    dailygoalString = null; // reset so next language's goal is used
    notifyListeners();
  }

  void updateDailyLimit(String newGoal) {
    // length = OnboardProvider.getMaxWordsForGoal(newGoal);

    dailygoalString = newGoal;
    maxWordsForLevel = DailyGoal.getMaxWordsForGoal(newGoal);

    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _navigationDebounceTimer?.cancel();
    _ttsService.dispose();
  }
}
