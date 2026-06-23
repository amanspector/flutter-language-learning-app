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
  String? gender;
  List<Map<String, dynamic>> myLanguages = [];
  String? activeLanguageCode;
  int? age;
  String? uid;
  int currentPage = 0;
  bool isCompleted = false;

  String get learningLanguageCode => Textconstant.learningLanguages.firstWhere(
    (element) => element['label'] == selectedlanguage,
    orElse: () => ({'code': 'en'}),
  )['code']!;

  TextDirection get learningTextDirection =>
      isRtl(learningLanguageCode) ? TextDirection.rtl : TextDirection.ltr;

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
    String? userGender,
    int? userAge,
  }) {
    selectedlanguage = language;
    selectedExperienceLevel = level;
    selectedgoal = category;
    selectedDailyGoal = dailygoal;
    isCompleted = true;
    selectedNativeLanguage = nativeLanguage;
    gender = userGender;
    age = userAge;
    notifyListeners();
  }

  Future<void> loadLanguages() async {
    myLanguages = await FirebaseOnboardingService.getLanguages();
    activeLanguageCode = await FirebaseOnboardingService.getActiveLanguage();
    notifyListeners();
  }

  Future<void> switchLanguage(String languageCode) async {
    await FirebaseOnboardingService.switchActiveLanguage(languageCode);
    activeLanguageCode = languageCode;

    // update local state from the switched language's config
    final lang = myLanguages.firstWhere(
      (l) => l['code'] == languageCode,
      orElse: () => {},
    );
    if (lang.isNotEmpty) {
      selectedlanguage = lang['languageLabel'];
      selectedExperienceLevel = lang['level'];
      selectedgoal = lang['category'];
      selectedDailyGoal = lang['dailygoal'];
    }

    notifyListeners();
  }

  Future<void> addNewLanguage({
    required String languageCode,
    required String languageLabel,
    required String level,
    required String category,
    required String dailygoal,
  }) async {
    await FirebaseOnboardingService.addLanguage(
      languageCode: languageCode,
      languageLabel: languageLabel,
      level: level,
      category: category,
      dailygoal: dailygoal,
    );
    await loadLanguages(); // refresh list
  }

  Future<void> updateNativeLanguage(String language) async {
    selectedNativeLanguage = language;
    await FirebaseOnboardingService.setAppLanguage(language);
    notifyListeners();
  }

  Future<void> updateDailygoal(String dailygoal) async {
    selectedDailyGoal = dailygoal;
    if (activeLanguageCode != null) {
      await FirebaseOnboardingService.setDailyGoal(dailygoal, languageCode: activeLanguageCode!);
      final index = myLanguages.indexWhere((l) => l['code'] == activeLanguageCode);
      if (index != -1) {
        myLanguages[index]['dailygoal'] = dailygoal;
      }
    } else {
      await FirebaseOnboardingService.setDailyGoal(dailygoal);
    }
    notifyListeners();
  }

  void setGender(String value) {
    gender = value;
    notifyListeners();
  }

  void setAge(int value) {
    age = value;
    notifyListeners();
  }

  void validate(int pageIndex, {bool isAddingLanguage = false}) {
    // When adding a language, the AppLanguageSelection page is skipped,
    // so all page indices are shifted down by 1.
    final adjustedIndex = isAddingLanguage ? pageIndex + 1 : pageIndex;
    switch (adjustedIndex) {
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

  void prepareForAddingLanguage() {
    selectedlanguage = null;
    selectedgoal = null;
    selectedExperienceLevel = null;
    selectedDailyGoal = null;
    currentPage = 0;
    error_message = null;
    notifyListeners();
  }

  void reset() {
    error_message = null;
    selectedlanguage = null;
    selectedgoal = null;
    selectedExperienceLevel = null;
    selectedDailyGoal = null;
    selectedDailyGoalDuration = null;
    selectedNativeLanguage = 'en';
    selectedNativeLanguageLabel = 'English';
    gender = null;
    age = null;
    isCompleted = false;
    currentPage = 0;
    myLanguages = [];
    activeLanguageCode = null;
    uid = null;
    notifyListeners();
  }
}
