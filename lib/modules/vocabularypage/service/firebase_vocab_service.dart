import 'dart:developer';
import 'package:chatbot_app/modules/vocabularypage/model/word_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseVocabService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> saveLessonResults({
    required List<String> masteredWords,
    required List<String> needReviewWords,
    required int score,
    required int totalQuestions,
    required int xpEarned,
  }) async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) throw Exception("User not logged in");

      final batch = _firestore.batch();
      final timestamp = FieldValue.serverTimestamp();

      final percentage = totalQuestions == 0
          ? 0
          : ((score / totalQuestions) * 100).round();

      final learnedWordsRef = _firestore
          .collection('users')
          .doc(uid)
          .collection('progress')
          .doc('learned_words');

      batch.set(learnedWordsRef, {
        'word_ids': FieldValue.arrayUnion(masteredWords),
        'last_updated': timestamp,
      }, SetOptions(merge: true));

      final lessonHistoryRef = _firestore
          .collection('users')
          .doc(uid)
          .collection('progress')
          .doc('lesson_history')
          .collection('lessons')
          .doc();

      batch.set(lessonHistoryRef, {
        'score': score,
        'total_questions': totalQuestions,
        'percentage': percentage,
        'xp_earned': xpEarned,
        'mastered_words': masteredWords,
        'review_words': needReviewWords,
        'completed_at': timestamp,
      });

      final statsRef = _firestore.collection('users').doc(uid);

      batch.set(statsRef, {
        'total_xp': FieldValue.increment(xpEarned),
        'lessons_completed': FieldValue.increment(1),
        'words_learned': FieldValue.increment(masteredWords.length),
        'last_lesson_date': timestamp,
      }, SetOptions(merge: true));

      await _updateStreak(uid);
      await batch.commit();

      log("✅ Lesson results saved successfully");
    } catch (e) {
      log("❌ Error saving lesson results: $e");
      rethrow;
    }
  }

  // Seed SRS when words are generated (call after saveVocab)
  Future<void> seedSrsCards(List<WordModel> words) async {
    final uid = _auth.currentUser!.uid;
    final batch = _firestore.batch();
    for (final w in words) {
      final ref = _firestore
          .collection('users')
          .doc(uid)
          .collection('srs_cards')
          .doc(w.word);
      final doc = await ref.get();
      if (!doc.exists) {
        batch.set(ref, {
          'word_id': w.word,
          'interval': 1,
          'repetitions': 0,
          'next_review': DateTime.now()
              .add(Duration(days: 1))
              .toIso8601String(),
        });
      }
    }
    await batch.commit();
  }

  // Update after Easy/Hard answer
  Future<void> updateSrsCard(WordModel word) async {
    final uid = _auth.currentUser!.uid;
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('srs_cards')
        .doc(word.word)
        .set({
          'word_id': word.word,
          'interval': word.srsInterval,
          'repetitions': word.srsRepetitions,
          'next_review': word.srsNextReview.toIso8601String(),
        });
  }

  // Get due words for today
  Future<List<String>> getDueSrsWordIds() async {
    final uid = _auth.currentUser!.uid;
    final now = DateTime.now().toIso8601String();
    final snap = await _firestore
        .collection('users')
        .doc(uid)
        .collection('srs_cards')
        .where('next_review', isLessThanOrEqualTo: now)
        .get();
    return snap.docs.map((d) => d['word_id'] as String).toList();
  }

  Future<void> _updateStreak(String uid) async {
    try {
      final docRef = _firestore.collection('users').doc(uid);
      final userDoc = await docRef.get();
      final data = userDoc.data();
      if (data == null) return;
      final lastLessonTimestamp = data['last_lesson_date'] as Timestamp?;
      final currentStreak = (data['current_streak'] ?? 0) as int;

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      int newStreak;

      log("Last lesson: $lastLessonTimestamp");
      log("Current streak: $currentStreak");
      log("Today: $today");
      if (lastLessonTimestamp == null) {
        newStreak = 1;
      } else {
        final lastLessonDate = lastLessonTimestamp.toDate();
        final lastLessonDay = DateTime(
          lastLessonDate.year,
          lastLessonDate.month,
          lastLessonDate.day,
        );
        final daysDifference = today.difference(lastLessonDay).inDays;
        log("Diff: $daysDifference");

        if (daysDifference == 0) {
          newStreak = currentStreak == 0 ? 1 : currentStreak;
        } else if (daysDifference == 1) {
          newStreak = currentStreak + 1;
        } else {
          newStreak = 1;
        }
      }

      final longestStreak = (data['longest_streak'] ?? 0) as int;
      log("new streak: $newStreak");
      log("longest streak : $longestStreak");
      await docRef.set({
        'current_streak': newStreak,
        'longest_streak': newStreak > longestStreak ? newStreak : longestStreak,
        'last_lesson_date': Timestamp.now(),
      }, SetOptions(merge: true));
    } catch (e) {
      log("Error updating streak: $e");
    }
  }

  Future<int> getCurrentStreak() async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) return 0;

      final doc = await _firestore.collection('users').doc(uid).get();
      final data = doc.data() ?? {};

      return (data['current_streak'] ?? 0) as int;
    } catch (e) {
      return 0;
    }
  }

  Future<int> getTotalXP() async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) return 0;

      final doc = await _firestore.collection('users').doc(uid).get();
      final data = doc.data() ?? {};

      return (data['total_xp'] ?? 0) as int;
    } catch (e) {
      return 0;
    }
  }

  Future<List<WordModel>> getUnlearnedWords({
    required List<WordModel> allWords,
  }) async {
    final learnedIds = await getLearnedWords();

    log("Learned IDs: $learnedIds");
    log("Learned word length: ${learnedIds.length.toString()}");
    return allWords.where((w) => !learnedIds.contains(w.word)).toList();
  }

  Future<List<String>> getLearnedWords() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception("User not logged in");

    final doc = await _firestore
        .collection('users')
        .doc(uid)
        .collection('progress')
        .doc('learned_words')
        .get();
    return (doc.data()?['word_ids'] as List?)?.cast<String>() ?? [];
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> fetchVocab(
    String language,
    String level,
    String category,
  ) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('languages')
        .doc(language.toLowerCase())
        .collection('levels')
        .doc(level.toLowerCase())
        .collection('categories')
        .doc(category.toLowerCase())
        .collection('words')
        .get();

    return snapshot;
  }

  // static Future<void> saveVocab({
  //   required String language,
  //   required String level,
  //   required String category,
  //   required List<WordModel> words,
  // }) async {
  //   final collection = FirebaseFirestore.instance
  //       .collection("vocabulary")
  //       .doc(language)
  //       .collection(level)
  //       .doc(category);

  //   await collection.set({
  //     "words": words.map((e) => e.toJson()).toList(),
  //     "createdAt": FieldValue.serverTimestamp(),
  //   });
  // }

  static Future<DocumentSnapshot<Map<String, dynamic>>> fetchVocabfromai(
    String language,
    String level,
    String category,
  ) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final docId =
        "${language.toLowerCase()}_${level.toLowerCase()}_${category.toLowerCase()}";

    return await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("vocabulary")
        .doc(docId)
        .get();
  }

  static Future<void> saveVocab({
    required String language,
    required String level,
    required String category,
    required List<WordModel> words,
  }) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final docId =
        "${language.toLowerCase()}_${level.toLowerCase()}_${category.toLowerCase()}";

    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("vocabulary")
        .doc(docId)
        .set({
          "language": language,
          "level": level,
          "category": category,
          "words": words.map((e) => e.toJson()).toList(),
          "createdAt": FieldValue.serverTimestamp(),
        });
  }

  Future<void> saveProgress({
    required String language,
    required String level,
    required String category,
    required int nextIndex,
  }) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("vocabulary_progress")
        .doc("${language}_${level}_$category")
        .set({
          "lastIndex": nextIndex,
          "updatedAt": FieldValue.serverTimestamp(),
        });
  }

  Future<void> clearVocabDataOnLanguageChange() async {
    final uid = _auth.currentUser!.uid;
    final batch = _firestore.batch();

    // Clear vocabulary
    final vocabSnap = await _firestore
        .collection('users')
        .doc(uid)
        .collection('vocabulary')
        .get();
    for (final doc in vocabSnap.docs) {
      batch.delete(doc.reference);
    }

    // Clear srs_cards
    final srsSnap = await _firestore
        .collection('users')
        .doc(uid)
        .collection('srs_cards')
        .get();
    for (final doc in srsSnap.docs) {
      batch.delete(doc.reference);
    }

    // Clear learned_words
    batch.delete(
      _firestore
          .collection('users')
          .doc(uid)
          .collection('progress')
          .doc('learned_words'),
    );

    await batch.commit();
    log("✅ Vocab data cleared on language change");
  }
}
