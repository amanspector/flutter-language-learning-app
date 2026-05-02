import 'package:flutter/material.dart';

class OnboardProvider extends ChangeNotifier {
  String? selectedlanguage;
  String? selectedgoal;
  String? error_message;
  String? selectedDailyGoal;
  String? selectedExperienceLevel;
  int currentPage = 0;

  void setSelectedLanguage(String value) {
    selectedlanguage = value;
    error_message = null;
    notifyListeners();
  }

  void setGoal(String value) {
    selectedgoal = value;
    error_message = null;
    notifyListeners();
  }

  void setDailyGoal(String value) {
    selectedDailyGoal = value;
    error_message = null;
    notifyListeners();
  }

  void setExperienceLevel(String value) {
    selectedExperienceLevel = value;
    error_message = null;
    notifyListeners();
  }

  void validate(int pageIndex) {
    switch (pageIndex) {
      case 0:
        if (selectedlanguage == null) {
          error_message = "Select language to continue";
        }
        break;
      case 1:
        if (selectedgoal == null) {
          error_message = "Select your goal";
        }
        break;
      case 2:
        if (selectedDailyGoal == null) {
          error_message = "Select your daily goal";
        }
        break;
      case 3:
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
}
