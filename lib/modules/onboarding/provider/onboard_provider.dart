import 'dart:developer';

import 'package:chatbot_app/core/appconstants/text_constant.dart';
import 'package:chatbot_app/modules/onboarding/service/firebase_onboarding_service.dart';
import 'package:flutter/material.dart';

class OnboardProvider extends ChangeNotifier {
  String? selectedNativeLanguage = Textconstant.languages.first['code'];
  String selectedNativeLanguageLabel = 'English';
  String? selectedlanguage;
  String? selectedgoal;
  String? error_message;
  String? selectedDailyGoal;
  String? selectedDailyGoalDuration;
  String? selectedExperienceLevel;
  String? uid;
  int currentPage = 0;
  bool isCompleted = false;
  TextDirection get learningTextDirection =>
      isRtl(selectedNativeLanguage ?? 'en')
      ? TextDirection.rtl
      : TextDirection.ltr;

  void setSelectedNativeLanguage(String value) {
    selectedNativeLanguage = value;
    log(selectedNativeLanguage!);
    error_message = null;
    notifyListeners();
  }

  void setSelectedNativeLanguageLabel(String value) {
    selectedNativeLanguageLabel = value;
    log(selectedNativeLanguageLabel);
    error_message = null;
    notifyListeners();
  }

  void setSelectedLanguage(String value) {
    selectedlanguage = value;
    log(selectedlanguage!);
    error_message = null;
    notifyListeners();
  }

  void setGoal(String value) {
    selectedgoal = value;
    error_message = null;
    notifyListeners();
  }

  void setDailyGoal(String dailyGoal) {
    selectedDailyGoal = dailyGoal;
    error_message = null;
    notifyListeners();
  }

  void setExperienceLevel(String value) {
    selectedExperienceLevel = value;
    error_message = null;
    notifyListeners();
  }

  void setError() {
    error_message = null;
    notifyListeners();
  }

  void setData({
    required String language,
    required String level,
    required String category,
    required String dailygoal,
    required String nativeLanguage,
  }) {
    selectedlanguage = language;
    selectedExperienceLevel = level;
    selectedgoal = category;
    selectedDailyGoal = dailygoal;
    isCompleted = true;
    selectedNativeLanguage = nativeLanguage;
    notifyListeners();
  }

  Future<void> updateNativeLanguage(String language) async {
    selectedNativeLanguage = language;
    await FirebaseOnboardingService.setAppLanguage(language);
    notifyListeners();
  }

  Future<void> updateDailygoal(String dailygoal) async {
    selectedDailyGoal = dailygoal;
    await FirebaseOnboardingService.setDailyGoal(dailygoal);
    notifyListeners();
  }

  void validate(int pageIndex) {
    switch (pageIndex) {
      case 0:
        if (selectedNativeLanguage == null) {
          error_message = "Select Native language to continue";
        }
        break;
      case 1:
        if (selectedlanguage == null) {
          error_message = "Select language to continue";
        }
        break;
      case 2:
        if (selectedgoal == null) {
          error_message = "Select your goal";
        }
        break;
      case 3:
        if (selectedDailyGoal == null) {
          error_message = "Select your daily goal";
        }
        break;
      case 4:
        if (selectedExperienceLevel == null) {
          error_message = "Select your experience level";
        }
        break;
    }
    notifyListeners();
  }

  void setCurrentPageIndex(int index) {
    currentPage = index;
    notifyListeners();
  }

  void setUserId(String userid) {
    uid = userid;
    notifyListeners();
  }

  static bool isRtl(String langCode) =>
      ['ar', 'he', 'ur', 'fa'].contains(langCode);

  void reset() {
    error_message = null;
    selectedlanguage = null;
    selectedgoal = null;
    selectedExperienceLevel = null;
    selectedDailyGoal = null;
    selectedNativeLanguage = 'en';
    isCompleted = false;
    currentPage = 0;
    notifyListeners();
  }
}
