import 'dart:developer';
import 'package:chatbot_app/modules/exercisepage/model/exercise_model.dart';
import 'package:chatbot_app/modules/vocabularypage/model/word_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VocabFetchResult {
  final List<Map<String, dynamic>> words;
  final DocumentSnapshot? lastDoc;
  VocabFetchResult({required this.words, this.lastDoc});
}

class FirebaseVocabService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // String _langDoc(String uid, String languageCode) =>
  //     'users/$uid/languages/$languageCode';

  Future<void> saveLessonResults({
    required String language,
    required List<String> masteredWords,
    required List<String> needReviewWords,
    required int score,
    required int totalQuestions,
    required int xpEarned,
    required List<ExerciseModel> exercises,
  }) async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) throw Exception("User not logged in");

      final batch = _firestore.batch();
      final timestamp = FieldValue.serverTimestamp();

      final percentage = totalQuestions == 0
          ? 0
          : ((score / totalQuestions) * 100).round();

      final langRef = _firestore
          .collection('users')
          .doc(uid)
          .collection('languages')
          .doc(language);

      final learnedWordsRef = langRef
          .collection('progress')
          .doc('learned_words');

      batch.set(learnedWordsRef, {
        'word_ids': FieldValue.arrayUnion([
          ...masteredWords,
          ...needReviewWords,
        ]),
        'last_updated': timestamp,
      }, SetOptions(merge: true));

      final lessonHistoryRef = _firestore
          .collection('users')
          .doc(uid)
          .collection('languages')
          .doc(language)
          .collection('lesson_history')
          .doc();

      final exerciseData = exercises
          .map(
            (e) => {
              'id': e.id,
              'type': e.type.name,
              'question': e.question,
              'correct_answer': e.correctAnswer,
              'user_answer': e.userAnswer ?? '',
              'is_correct': e.isCorrect ?? false,
              'options': e.options,
            },
          )
          .toList();

      batch.set(lessonHistoryRef, {
        'score': score,
        'total_questions': totalQuestions,
        'percentage': percentage,
        'xp_earned': xpEarned,
        'mastered_words': masteredWords,
        'review_words': needReviewWords,
        'completed_at': timestamp,
        'exercises': exerciseData,
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

  Future<void> seedSrsCards(List<WordModel> words, String language) async {
    final uid = _auth.currentUser!.uid;
    final batch = _firestore.batch();
    final wordIds = words.map((w) => w.word).toSet().toList();
    if (wordIds.isEmpty) return;

    final existingWordIds = <String>{};

    // Query in chunks of 30 to stay within Firestore's whereIn limit
    for (var i = 0; i < wordIds.length; i += 30) {
      final chunk = wordIds.sublist(i, (i + 30).clamp(0, wordIds.length));
      final snapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('languages')
          .doc(language)
          .collection('srs_cards')
          .where(FieldPath.documentId, whereIn: chunk)
          .get();
      existingWordIds.addAll(snapshot.docs.map((doc) => doc.id));
    }

    for (final w in words) {
      if (!existingWordIds.contains(w.word)) {
        final ref = _firestore
            .collection('users')
            .doc(uid)
            .collection('languages')
            .doc(language)
            .collection('srs_cards')
            .doc(w.word);
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

  Future<void> updateSrsCard(WordModel word, String language) async {
    final uid = _auth.currentUser!.uid;
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('languages')
        .doc(language)
        .collection('srs_cards')
        .doc(word.word)
        .set({
          'word_id': word.word,
          'interval': word.srsInterval,
          'repetitions': word.srsRepetitions,
          'next_review': word.srsNextReview.toIso8601String(),
        });
  }

  Future<List<String>> getDueSrsWordIds(String langauge) async {
    final uid = _auth.currentUser!.uid;
    final now = DateTime.now().toIso8601String();
    final snap = await _firestore
        .collection('users')
        .doc(uid)
        .collection('languages')
        .doc(langauge)
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
    required String language,
  }) async {
    final learnedIds = await getLearnedWords(language);

    log("Learned IDs: $learnedIds");
    log("Learned word length: ${learnedIds.length.toString()}");
    return allWords.where((w) => !learnedIds.contains(w.word)).toList();
  }

  Future<List<String>> getLearnedWords(String language) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception("User not logged in");

    final doc = await _firestore
        .collection('users')
        .doc(uid)
        .collection('languages')
        .doc(language)
        .collection('progress')
        .doc('learned_words')
        .get();
    return (doc.data()?['word_ids'] as List?)?.cast<String>() ?? [];
  }

  static Future<VocabFetchResult> fetchVocabfromai(
    String languageCode,
    String level,
    String category, {
    DocumentSnapshot? startAfterDoc,
    int limit = 50,
  }) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final docId =
        "${languageCode.toLowerCase()}_${level.toLowerCase()}_${category.toLowerCase()}";

    final vocabDocRef = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("languages")
        .doc(languageCode)
        .collection("vocabulary")
        .doc(docId);

    List<Map<String, dynamic>> allWords = [];

    // Backward compatibility: fetch old array format ONLY on first load
    if (startAfterDoc == null) {
      final docSnapshot = await vocabDocRef.get();
      if (docSnapshot.exists && docSnapshot.data() != null) {
        final data = docSnapshot.data()!;
        if (data['words'] != null && data['words'] is List) {
          final wordsList = data['words'] as List;
          allWords.addAll(
            wordsList.map((e) => Map<String, dynamic>.from(e as Map)),
          );
        }
      }
    }

    // Fetch from subcollection with pagination
    var wordsQuery = vocabDocRef.collection("words").limit(limit);
    if (startAfterDoc != null) {
      wordsQuery = wordsQuery.startAfterDocument(startAfterDoc);
    }
    final querySnapshot = await wordsQuery.get();

    for (var doc in querySnapshot.docs) {
      allWords.add(doc.data());
    }

    DocumentSnapshot? lastDoc;
    if (querySnapshot.docs.isNotEmpty) {
      lastDoc = querySnapshot.docs.last;
    }

    return VocabFetchResult(words: allWords, lastDoc: lastDoc);
  }

  static Future<void> saveVocab({
    required String languageCode,
    required String level,
    required String category,
    required List<WordModel> words,
  }) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final docId =
        "${languageCode.toLowerCase()}_${level.toLowerCase()}_${category.toLowerCase()}";

    final vocabDocRef = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("languages")
        .doc(languageCode)
        .collection("vocabulary")
        .doc(docId);

    final batch = FirebaseFirestore.instance.batch();

    batch.set(vocabDocRef, {
      "languageCode": languageCode,
      "level": level,
      "category": category,
      "updatedAt": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    for (final word in words) {
      final wordDocRef = vocabDocRef.collection("words").doc(word.word);
      batch.set(wordDocRef, word.toJson(), SetOptions(merge: true));
    }

    await batch.commit();
  }
}
