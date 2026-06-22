import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseOnboardingService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> setprovider(
    bool isOnBoarding,
    String languageLabel,
    String languageCode,
    String nativeLanguage,
    String level,
    String category,
    String dailygoal,
  ) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final batch = _firestore.batch();
    final userRef = _firestore.collection('users').doc(uid);

    batch.set(userRef, {
      "onboardingCompleted": true,
      "nativeLanguage": nativeLanguage,
      "active_language": languageCode,
    }, SetOptions(merge: true));

    final langRef = userRef.collection('languages').doc(languageCode);
    batch.set(langRef, {
      "languageLabel": languageLabel,
      "level": level,
      "category": category,
      "dailygoal": dailygoal,
      "addedAt": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    await batch.commit();
    // await _firestore.collection('users').doc(uid).set({
    //   "onboardingCompleted": true,
    //   "language": language,
    //   "nativeLanguage": nativeLanguage,
    //   "level": level,
    //   "category": category,
    //   "dailygoal": dailygoal,
    // }, SetOptions(merge: true));
  }

  static Future<String?> getActiveLanguage() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return null;

    final doc = await _firestore.collection('users').doc(uid).get();
    return doc.data()?['active_language'] as String?;
  }

  static Future<void> addLanguage({
    required String languageCode,
    required String languageLabel,
    required String level,
    required String category,
    required String dailygoal,
  }) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await _firestore
        .collection('users')
        .doc(uid)
        .collection('languages')
        .doc(languageCode)
        .set({
          "languageLabel": languageLabel,
          "level": level,
          "category": category,
          "dailygoal": dailygoal,
          "addedAt": FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
  }

  static Future<void> switchActiveLanguage(String languageCode) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    await _firestore.collection('users').doc(uid).set({
      "active_language": languageCode,
    }, SetOptions(merge: true));
    log("✅ Active language switched to $languageCode");
  }

  static Future<List<Map<String, dynamic>>> getLanguages() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return [];

    final snapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('languages')
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['code'] = doc.id; // 👈 attach language code
      return data;
    }).toList();
  }

  static Future<void> setAppLanguage(String languageCode) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    await _firestore.collection('users').doc(uid).set({
      "nativeLanguage": languageCode,
    }, SetOptions(merge: true)); // ← This is key
    log("updated app language");
  }

  static Future<void> setDailyGoal(String dailygoal, {String? languageCode}) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final batch = _firestore.batch();
    final userRef = _firestore.collection('users').doc(uid);

    batch.set(userRef, {
      "dailygoal": dailygoal,
    }, SetOptions(merge: true));

    if (languageCode != null) {
      final langRef = userRef.collection('languages').doc(languageCode);
      batch.set(langRef, {
        "dailygoal": dailygoal,
      }, SetOptions(merge: true));
    }

    await batch.commit();
    log("updated daily goal");
  }
}
