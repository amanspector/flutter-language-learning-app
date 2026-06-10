import 'package:flutter/material.dart';

class Textconstant {
  static const String txtRegistersucess = "Register successfully ";
  static const String txtRegister = "Register";
  static const String appName = 'Multilingo';
  static const String whatsYourNativeLanguage =
      "What is your native language ?";
  static const String nativeLanguageSubtitle =
      "Selected language will be sets to application language";

  static const String syncingProgress = "SYNCING PROGRESS...";

  static const List<Map<String, String>> languages = [
    {'code': 'en', 'label': 'English'},
    {'code': 'hi', 'label': 'हिंदी - Hindi'},
    {'code': 'gu', 'label': 'ગુજરાતી - Gujarati'},
    {'code': 'ar', 'label': 'عربي - Arabic'},
    {'code': 'es', 'label': 'Spanish - española'},
  ];

  static const languageNames = {
    'en': 'English',
    'hi': 'हिन्दी - Hindi',
    'gu': 'ગુજરાતી - Gujarati',
    'ar': 'عربي - Arabic',
    'es': 'Spanish - española',
  };

  static const List<Map<String, dynamic>> genders = [
    {'label': 'Male', 'icon': Icons.male_rounded},
    {'label': 'Female', 'icon': Icons.female_rounded},
    {'label': 'Other', 'icon': Icons.transgender_rounded},
  ];
}
