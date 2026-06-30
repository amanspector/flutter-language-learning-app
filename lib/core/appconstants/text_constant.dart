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

  static const learningLanguages = [
    {'code': 'en', 'label': 'English', 'img': 'assets/icon/icon_uk_flag.png'},
    {'code': 'hi', 'label': 'Hindi', 'img': 'assets/icon/icon_india_flag.png'},
    {
      'code': 'gu',
      'label': 'Gujarati',
      'img': 'assets/icon/icon_india_flag.png',
    },
    {'code': 'ar', 'label': 'Arabic', 'img': 'assets/icon/icon_ar_flag.png'},
    {
      'code': 'es',
      'label': 'Spanish',
      'img': 'assets/icon/icon_spain_flag.png',
    },
    {
      'code': 'fr',
      'label': 'French',
      'img': 'assets/icon/icon_france_flag.png',
    },
  ];

  static const List<Map<String, String>> languages = [
    {'code': 'en', 'label': 'English'},
    {'code': 'hi', 'label': 'हिंदी - Hindi'},
    {'code': 'gu', 'label': 'ગુજરાતી - Gujarati'},
    {'code': 'ar', 'label': 'عربي - Arabic'},
    {'code': 'es', 'label': 'Spanish - española'},
    {'code': 'fr', 'label': 'French - français'},
  ];

  static const languageNames = {
    'en': 'English',
    'hi': 'हिन्दी - Hindi',
    'gu': 'ગુજરાતી - Gujarati',
    'ar': 'عربي - Arabic',
    'es': 'Spanish - española',
    'fr': 'French - français',
  };

  static const List<Map<String, dynamic>> genders = [
    {'label': 'Male', 'icon': Icons.male_rounded},
    {'label': 'Female', 'icon': Icons.female_rounded},
    {'label': 'Other', 'icon': Icons.transgender_rounded},
  ];
}
