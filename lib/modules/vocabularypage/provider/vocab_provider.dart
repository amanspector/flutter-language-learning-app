import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
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

  Future<List<WordModel>> _loadVocabFromJson(
    String languageCode,
    String level,
    String category,
  ) async {
    try {
      final filename =
          "${languageCode.toLowerCase()}_${level.toLowerCase()}_${category.toLowerCase()}.json";
      log("Attempting to load vocab JSON from filesystem: $filename");

      // Helper function to extract list of word models from dynamic JSON content
      List<dynamic> extractWords(dynamic decodedJson) {
        if (decodedJson is Map) {
          return decodedJson['words'] as List? ?? [];
        } else if (decodedJson is List) {
          return decodedJson;
        }
        return [];
      }

      // 1. Try host directory path
      try {
        final hostFile = File(
          'd:/folder/Flutter/chatbot_app/assets/data/$filename',
        );
        if (await hostFile.exists()) {
          final content = await hostFile.readAsString();
          final decodedJson = jsonDecode(content);
          final List decoded = extractWords(decodedJson);
          log("Loaded vocab from host path: ${hostFile.path}");
          return decoded.map((e) => WordModel.fromJson(e)).toList();
        }
      } catch (e) {
        log("Could not check/read from host path: $e");
      }

      // 2. Try relative directory path
      try {
        final relativeFile = File('assets/data/$filename');
        if (await relativeFile.exists()) {
          final content = await relativeFile.readAsString();
          final decodedJson = jsonDecode(content);
          final List decoded = extractWords(decodedJson);
          log("Loaded vocab from relative path: ${relativeFile.path}");
          return decoded.map((e) => WordModel.fromJson(e)).toList();
        }
      } catch (e) {
        log("Could not check/read from relative path: $e");
      }

      // 3. Try systemTemp directory path
      try {
        final tempFile = File('${Directory.systemTemp.path}/$filename');
        if (await tempFile.exists()) {
          final content = await tempFile.readAsString();
          final decodedJson = jsonDecode(content);
          final List decoded = extractWords(decodedJson);
          log("Loaded vocab from temp path: ${tempFile.path}");
          return decoded.map((e) => WordModel.fromJson(e)).toList();
        }
      } catch (e) {
        log("Could not check/read from temp path: $e");
      }

      // 4. Fallback to rootBundle assets
      try {
        final jsonString = await rootBundle.loadString('assets/data/$filename');
        final decodedJson = jsonDecode(jsonString);
        final List decoded = extractWords(decodedJson);
        log("Loaded vocab from rootBundle asset: assets/data/$filename");
        return decoded.map((e) => WordModel.fromJson(e)).toList();
      } catch (e) {
        log("Asset not found or failed to load via rootBundle: $e");
      }
    } catch (e) {
      log("Error loading vocab from JSON: $e");
    }
    return [];
  }

  Future<void> _saveVocabToJson(
    String languageCode,
    String level,
    String category,
    List<WordModel> words,
  ) async {
    try {
      final filename =
          "${languageCode.toLowerCase()}_${level.toLowerCase()}_${category.toLowerCase()}.json";
      final jsonList = words.map((w) => w.toJson()).toList();
      final jsonString = jsonEncode(jsonList);

      // 1. Try to save to host directory (if it exists)
      final hostDir = Directory('d:/folder/Flutter/chatbot_app/assets/data');
      if (hostDir.existsSync()) {
        try {
          final hostFile = File(
            'd:/folder/Flutter/chatbot_app/assets/data/$filename',
          );
          await hostFile.writeAsString(jsonString);
          log(
            "Successfully saved vocabulary data to host path: ${hostFile.path}",
          );
        } catch (e) {
          log("Failed to write to host path: $e");
        }
      }

      // 2. Try to save to relative directory (if it exists or can be created)
      final relativeDir = Directory('assets/data');
      bool canWriteRelative = false;
      try {
        if (!relativeDir.existsSync()) {
          relativeDir.createSync(recursive: true);
        }
        canWriteRelative = true;
      } catch (e) {
        log("Could not access relative assets directory: $e");
      }

      if (canWriteRelative) {
        try {
          final relativeFile = File('assets/data/$filename');
          await relativeFile.writeAsString(jsonString);
          log(
            "Successfully saved vocabulary data to relative path: ${relativeFile.path}",
          );
        } catch (e) {
          log("Failed to write to relative path: $e");
        }
      }

      // 3. Save to systemTemp directory as a robust fallback for all platforms (e.g. mobile/emulators)
      try {
        final tempFile = File('${Directory.systemTemp.path}/$filename');
        await tempFile.writeAsString(jsonString);
        log(
          "Successfully saved vocabulary data to temp path: ${tempFile.path}",
        );
      } catch (e) {
        log("Failed to write to temp path: $e");
      }

      // 4. Try sending to the local save-vocab server running on host PC (highly recommended for emulators/devices)
      try {
        final client = HttpClient();
        client.connectionTimeout = const Duration(seconds: 3);
        final uris = [
          Uri.parse('http://192.168.1.49:8080/save-vocab'),
          Uri.parse('http://10.0.2.2:8080/save-vocab'),
          Uri.parse('http://localhost:8080/save-vocab'),
        ];
        for (final uri in uris) {
          try {
            final request = await client.postUrl(uri);
            request.headers.contentType = ContentType.json;
            request.write(
              jsonEncode({'filename': filename, 'content': jsonList}),
            );
            final response = await request.close();
            if (response.statusCode == 200) {
              log(
                "Successfully pushed vocabulary data to local host server: $uri",
              );
              break;
            }
          } catch (e) {
            log("Local save server not available at $uri: $e");
          }
        }
        client.close();
      } catch (e) {
        log("Error sending to local save server: $e");
      }
    } catch (e) {
      log("Error saving vocab to JSON: $e");
    }
  }

  Future<List<WordModel>> _getUnlearnedWords(
    List<WordModel> wordsList,
    String language,
  ) async {
    // Commented out Firebase learned words:
    // final learnedIds = await FirebaseVocabService().getLearnedWords(language);
    final learnedIds = <String>[];
    return wordsList.where((w) => !learnedIds.contains(w.word)).toList();
  }

  Future<List<WordModel>> _fetchUntilUnlearnedTarget(
    int target,
    OnboardProvider onboard,
    String experienceLevel,
    String category,
  ) async {
    List<WordModel> unlearnedWords = [];
    // Commented out Firebase learned words fetch:
    // List<String> learnedIds = await FirebaseVocabService().getLearnedWords(
    //   onboard.learningLanguageCode,
    // );
    List<String> learnedIds = [];

    // Check cached words first
    final cachedUnlearned = allWords
        .where((w) => !learnedIds.contains(w.word))
        .toList();
    unlearnedWords.addAll(cachedUnlearned);

    // Fetch from JSON instead of Firebase until we have enough
    if (unlearnedWords.length < target) {
      final localWords = await _loadVocabFromJson(
        onboard.learningLanguageCode,
        experienceLevel,
        category,
      );

      for (var w in localWords) {
        if (!allWords.any((existing) => existing.word == w.word)) {
          allWords.add(w);
        }
      }

      final filtered = localWords
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

      dailygoalString = onboard.selectedDailyGoal;
      maxWordsForLevel = DailyGoal.getMaxWordsForGoal(dailygoalString);

      log("maxWordsForLevel: $maxWordsForLevel");
      log("dailygoalString: $dailygoalString");

      // final unlearnedStaticWords = await _getUnlearnedStaticWords(onboard);
      // if (unlearnedStaticWords.isNotEmpty) {
      //   log("Serving ${unlearnedStaticWords.length} unlearned static words.");
      //   todaywords = unlearnedStaticWords.take(maxWordsForLevel).toList();

      //   await FirebaseVocabService.saveVocab(
      //     languageCode: onboard.learningLanguageCode,
      //     level: onboard.selectedExperienceLevel ?? 'Beginner',
      //     category: onboard.selectedgoal ?? 'travel',
      //     words: todaywords,
      //   );
      //   await FirebaseVocabService().seedSrsCards(
      //     todaywords,
      //     onboard.learningLanguageCode,
      //   );

      //   allWords = List.from(todaywords);
      //   currentIndex = 0;
      //   showMeaning = false;
      //   iscompleted = false;

      //   log("todaywords (static) :- $todaywords");
      //   await initTTS();
      //   await _ttsService.stopPlayer();
      //   if (todaywords.isNotEmpty) {
      //     preloadWordByIndex(currentIndex, ttslangauage, speaker);
      //     preloadWordByIndex(currentIndex + 1, ttslangauage, speaker);
      //   }

      //   isloadingAidata = false;
      //   notifyListeners();
      //   return;
      // }

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

        // Commented out Firebase call:
        // final newUnlearnedWords = await FirebaseVocabService()
        //     .getUnlearnedWords(
        //       allWords: allWords,
        //       language: onboard.learningLanguageCode,
        //     );
        final newUnlearnedWords = await _getUnlearnedWords(
          allWords,
          onboard.learningLanguageCode,
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
            // Commented out Firebase call:
            // final newUnlearnedWords = await FirebaseVocabService()
            //     .getUnlearnedWords(
            //       allWords: allWords,
            //       language: onboard.learningLanguageCode,
            //     );
            final newUnlearnedWords = await _getUnlearnedWords(
              allWords,
              onboard.learningLanguageCode,
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

    // Commented out Firebase call:
    // final dueWords = await FirebaseVocabService().getDueSrsWords(
    //   langaugeCode,
    //   level: level,
    //   category: category,
    // );
    final dueWords = <WordModel>[];

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
    // Commented out Firebase call:
    // List<String> learnedIds = await FirebaseVocabService().getLearnedWords(
    //   onboard.learningLanguageCode,
    // );
    List<String> learnedIds = [];

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

          // Commented out Firebase calls:
          // await FirebaseVocabService.saveVocab(
          //   languageCode: onboard.learningLanguageCode,
          //   level: onboard.selectedExperienceLevel!,
          //   category: onboard.selectedgoal!,
          //   words: words,
          // );
          // await FirebaseVocabService().seedSrsCards(
          //   words,
          //   onboard.learningLanguageCode,
          // );

          // Save vocabulary to JSON file:
          await _saveVocabToJson(
            onboard.learningLanguageCode,
            onboard.selectedExperienceLevel!,
            onboard.selectedgoal!,
            words,
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

      // final unlearnedStaticWords = await _getUnlearnedStaticWords(onboard);
      // if (unlearnedStaticWords.isNotEmpty) {
      //   log("Serving ${unlearnedStaticWords.length} unlearned static words in next batch.");
      //   todaywords = unlearnedStaticWords.take(maxWordsForLevel).toList();

      //   await FirebaseVocabService.saveVocab(
      //     languageCode: onboard.learningLanguageCode,
      //     level: onboard.selectedExperienceLevel ?? 'Beginner',
      //     category: onboard.selectedgoal ?? 'travel',
      //     words: todaywords,
      //   );
      //   await FirebaseVocabService().seedSrsCards(
      //     todaywords,
      //     onboard.learningLanguageCode,
      //   );

      //   allWords = List.from(todaywords);
      //   currentIndex = 0;
      //   iscompleted = false;
      //   notifyListeners();
      //   return;
      // }

      final unlearnedWords = await _fetchUntilUnlearnedTarget(
        maxWordsForLevel,
        onboard,
        currentExperienceLevel!,
        currentCategory!,
      );

      if (unlearnedWords.isEmpty || unlearnedWords.length < maxWordsForLevel) {
        todaywords.clear();

        await generateWordsFromAI(onboard);

        // Commented out Firebase call:
        // final newUnlearnedWords = await FirebaseVocabService()
        //     .getUnlearnedWords(
        //       allWords: allWords,
        //       language: onboard.learningLanguageCode,
        //     );
        final newUnlearnedWords = await _getUnlearnedWords(
          allWords,
          onboard.learningLanguageCode,
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
