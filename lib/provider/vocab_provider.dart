import 'package:chatbot_app/provider/onboard_provider.dart';
import 'package:chatbot_app/services/tts_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../models/word_model.dart';

class VocabProvider extends ChangeNotifier {
  List<WordModel> allWords = [];
  int currentIndex = 0;
  bool showMeaning = false;

  final FlutterTts _tts = FlutterTts();
  final TTSService _ttsService = TTSService();
  Future<void> speak({
    String? speaker,
    required String text,
    required String language,
  }) async {
    await _ttsService.speak(speaker: speaker, text: text, language: language);
  }

  Future<void> initTTS() async {
    await _tts.setLanguage("es-ES");
    await _tts.setSpeechRate(0.4);
  }

  Future<void> loadWords({
    required String langauage,
    required String experienceLevel,
    required String category,
  }) async {
    if (allWords.isNotEmpty) return;
    try {
      debugPrint("LOAD WORDS CALLED");

      final path = FirebaseFirestore.instance
          .collection('languages')
          .doc(langauage.toLowerCase())
          .collection('levels')
          .doc(experienceLevel.toLowerCase())
          .collection('categories')
          .doc(category.toLowerCase());

      print("PATH CHECK: ${path.path}");

      final snapshot = await FirebaseFirestore.instance
          .collection('languages')
          .doc(langauage.toLowerCase())
          .collection('levels')
          .doc(experienceLevel.toLowerCase())
          .collection('categories')
          .doc(category.toLowerCase())
          .collection('words')
          .get();

      if (snapshot.docs.isEmpty) {
        debugPrint("Document not found");
        return;
      }

      // final data = doc.data();
      // final List wordsJson = data?['words'];
      // final List wordsJson = data?['words'] ?? [];

      print(
        "-------------------------------------------------------------wordsJson${snapshot.docs}",
      );
      // await rootBundle.loadString('assets/json/hindi_beginner.json');

      // final data = jsonDecode(response);
      // final List<dynamic> wordsJson = data['hindi']['beginner']['travel'];
      // allWords = wordsJson.map((e) => WordModel.fromJson(e)).toList();
      allWords = snapshot.docs
          .map((e) => WordModel.fromJson(e.data()))
          .toList();

      print(
        "-------------------------------------------------------------allWords${allWords}",
      );
      await initTTS();
      notifyListeners();
    } catch (e) {
      debugPrint("Error loading words: $e");
    }
  }

  WordModel? get currentWord {
    if (allWords.isEmpty || currentIndex >= allWords.length) {
      return null;
    }
    return allWords[currentIndex];
  }

  void nextWord() {
    if (currentIndex < allWords.length - 1) {
      currentIndex++;
      showMeaning = false;
      notifyListeners();
    }
  }

  void toggleMeaning() {
    showMeaning = !showMeaning;
    notifyListeners();
  }

  // Future<void> speak(String text) async {
  //   await _tts.stop();
  //   await _tts.speak(text);
  // }
}
