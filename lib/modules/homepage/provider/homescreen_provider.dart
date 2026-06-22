import 'dart:developer';
import 'package:chatbot_app/modules/homepage/service/homescreen_service.dart';
import 'package:chatbot_app/modules/onboarding/provider/onboard_provider.dart';
import 'package:chatbot_app/modules/vocabularypage/provider/vocab_provider.dart';
import 'package:chatbot_app/modules/auth/service/firebase_auth_service.dart';
import 'package:chatbot_app/modules/vocabularypage/service/tts_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomescreenProvider extends ChangeNotifier {
  int currentStreak = 0;
  int totalXP = 0;
  String? langauge;
  int seletectedIndex = 0;
  bool isInitLoading = false;
  bool isLoadUserState = false;
  bool _hasInitializedSession = false;
  final PageController pageController = PageController();
  List<Map<String, dynamic>> lastLessonExercises = [];
  List<Map<String, dynamic>> lessonHistory = [];

  final FocusNode focus = FocusNode();
  Future<void> loadUserStats(String uid) async {
    if (isLoadUserState) return;
    isLoadUserState = true;
    notifyListeners();
    try {
      final snapshot = await FirebaseAuthService().getUserData(uid);
      log("Users data snapshot fetched successfully.");

      final data = snapshot.data() as Map<String, dynamic>?;
      log("Users data : $data");
      currentStreak = data?['current_streak'] ?? 0;
      totalXP = data?['total_xp'] ?? 0;
      langauge = data?['language'] ?? "Not Found";

      final activeLanguageCode = data?['active_language'] as String?;
      if (activeLanguageCode != null) {
        await loadLessonHistory(activeLanguageCode);
        await loadLastLesson(activeLanguageCode);
      }

      log("✅ Current Streak : $currentStreak days");
      log("✅ Stats Loaded: XP $totalXP");
      notifyListeners();
    } catch (e) {
      log(e.toString());
    } finally {
      isLoadUserState = false;
      notifyListeners();
    }
  }

  Future<void> initializeOnce({
    required OnboardProvider onboardprovider,
    required VocabProvider vocabprovider,
  }) async {
    if (_hasInitializedSession) return;
    _hasInitializedSession = true;

    await initSession(
      onboardprovider: onboardprovider,
      vocabprovider: vocabprovider,
    );
    await loadLessonHistory(onboardprovider.learningLanguageCode);
    await loadLastLesson(onboardprovider.learningLanguageCode);
  }

  int lastLessonScore = 0;
  int lastLessonTotal = 0;
  DateTime? lastLessonDate;

  Future<void> loadLastLesson(String languageCode) async {
    try {
      final data = await HomescreenService().getLastLesson(languageCode);
      if (data == null) return;

      lastLessonScore = data['score'] ?? 0;
      lastLessonTotal = data['total_questions'] ?? 0;
      lastLessonDate = (data['completed_at'] as Timestamp).toDate();
      lastLessonExercises = List<Map<String, dynamic>>.from(
        data['exercises'] ?? [],
      );
      log("✅ Last lesson: $lastLessonScore/$lastLessonTotal");
      log("✅ Exercises count: ${lastLessonExercises.length}");
    } catch (e) {
      log("❌ Error loading last lesson: $e");
    }
  }

  Future<void> loadLessonHistory(String languageCode) async {
    try {
      lessonHistory = await HomescreenService().getLessonHistory(languageCode);
      notifyListeners();
    } catch (e) {
      log("❌ Error loading lesson history: $e");
    }
  }

  void resetUserState() {
    _hasInitializedSession = false;
    isInitLoading = false;
    isLoadUserState = false;
    currentStreak = 0;
    totalXP = 0;
    notifyListeners();
  }

  Future<void> initSession({
    required OnboardProvider onboardprovider,
    required VocabProvider vocabprovider,
  }) async {
    if (isInitLoading) return;
    try {
      isInitLoading = true;
      notifyListeners();

      String uid = FirebaseAuthService.getuid();
      log("User id : $uid");
      await loadUserStats(uid);
      log("Data is loaded");

      final uilangauage = onboardprovider.selectedlanguage;

      if (uilangauage == null) {
        log("language not found from onboardprovider");
        isInitLoading = false;
        return;
      }

      final ttslanguage = TTSService.getCode(uilangauage);
      if (vocabprovider.todaywords.isEmpty && !vocabprovider.isloadingAidata) {
        await vocabprovider.loadWords(
          ttslangauage: ttslanguage,
          experienceLevel: onboardprovider.selectedExperienceLevel!,
          category: onboardprovider.selectedgoal!,
          onboard: onboardprovider,
        );
        log("Loadword is loaded !!");
      } else {
        log("Words already loaded or loading in progress");
      }
    } catch (e) {
      log("Init error : $e");
    } finally {
      isInitLoading = false;
      notifyListeners();
    }
  }

  void bottomNavBarIndex(int index) {
    seletectedIndex = index;
    pageController.jumpToPage(index);
    notifyListeners();
  }

  void keyboardUnfocus() {
    focus.unfocus();
    notifyListeners();
  }

  void keyboardfocus() {
    focus.requestFocus();
    notifyListeners();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
