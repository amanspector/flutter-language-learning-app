import 'dart:developer';

import 'package:chatbot_app/modules/homepage/provider/homescreen_provider.dart';
import 'package:chatbot_app/modules/onboarding/provider/onboard_provider.dart';
import 'package:chatbot_app/modules/vocabularypage/provider/vocab_provider.dart';
import 'package:chatbot_app/modules/auth/service/firebase_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Sessionmanage {
  static Future<bool> loadAndInitializeUser(
    BuildContext context,
    String uid,
  ) async {
    try {
      log("SessionManager: Fetching user data for uid: $uid");
      final snap = await FirebaseAuthService().getUserData(uid);

      if (snap.exists && snap.data() != null) {
        final data = snap.data() as Map<String, dynamic>;
        final isOnboardingCompleted = data['onboardingCompleted'] ?? false;

        if (isOnboardingCompleted) {
          log("SessionManager: Onboarding completed. Loading Providers...");

          if (!context.mounted) return false;

          final onboard = context.read<OnboardProvider>();
          final vocab = context.read<VocabProvider>();
          final home = context.read<HomescreenProvider>();

          onboard.setData(
            language: data['language'],
            nativeLanguage: data['nativeLanguage'],
            level: data['level'],
            category: data['category'],
            dailygoal: data['dailygoal'],
            userGender: data['gender'] as String?,
            userAge: data['age'] as int?,
          );

          await home.initializeOnce(
            onboardprovider: onboard,
            vocabprovider: vocab,
          );

          log("SessionManager: Success! Ready for Home Screen.");
          return true;
        }
      }

      log("SessionManager: User data empty or onboarding not completed.");
      return false;
    } catch (e) {
      log("SessionManager ERROR: $e");
      return false;
    }
  }
}
