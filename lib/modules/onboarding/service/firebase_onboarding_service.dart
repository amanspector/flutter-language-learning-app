import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseOnboardingService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> setprovider(
    bool isOnBoarding,
    String language,
    String nativeLanguage,
    String level,
    String category,
    String dailygoal,
  ) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await _firestore.collection('users').doc(uid).set({
      "onboardingCompleted": true,
      "language": language,
      "nativeLanguage": nativeLanguage,
      "level": level,
      "category": category,
      "dailygoal": dailygoal,
    }, SetOptions(merge: true));
  }

  static Future<void> setAppLanguage(String languageCode) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    await _firestore.collection('users').doc(uid).set({
      "nativeLanguage": languageCode,
    }, SetOptions(merge: true)); // ← This is key
    log("updated app language");
  }

  static Future<void> setDailyGoal(String dailygoal) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    await _firestore.collection('users').doc(uid).set({
      "dailygoal": dailygoal,
    }, SetOptions(merge: true)); // ← This is key
    log("updated daily goal");
  }
}
