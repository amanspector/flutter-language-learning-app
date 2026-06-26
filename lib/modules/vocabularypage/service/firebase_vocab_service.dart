import 'dart:developer';
import 'package:chatbot_app/modules/exercisepage/model/exercise_model.dart';
import 'package:chatbot_app/modules/vocabularypage/model/word_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

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

  Future<bool> saveLessonResults({
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

      final streakUpdated = await onSessionCompleted(uid);
      await batch.commit();

      log("✅ Lesson results saved successfully");
      return streakUpdated;
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
              .add(const Duration(days: 1))
              .toIso8601String(),
          'word_data': w.toJson(),
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
          'word_data': word.toJson(),
        });
  }

  Future<List<WordModel>> getDueSrsWords(
    String language, {
    String? level,
    String? category,
  }) async {
    final uid = _auth.currentUser!.uid;
    final now = DateTime.now().toIso8601String();
    final snap = await _firestore
        .collection('users')
        .doc(uid)
        .collection('languages')
        .doc(language)
        .collection('srs_cards')
        .where('next_review', isLessThanOrEqualTo: now)
        .get();

    final List<WordModel> list = [];
    for (final doc in snap.docs) {
      final data = doc.data();
      if (data['word_data'] != null) {
        final wordData = Map<String, dynamic>.from(data['word_data'] as Map);
        wordData['srs_interval'] = data['interval'] ?? 1;
        wordData['srs_repetitions'] = data['repetitions'] ?? 0;
        wordData['srs_next_review'] = data['next_review'];
        list.add(WordModel.fromJson(wordData));
      } else if (level != null && category != null) {
        try {
          final docId =
              "${language.toLowerCase()}_${level.toLowerCase()}_${category.toLowerCase()}";
          final wordDoc = await _firestore
              .collection('users')
              .doc(uid)
              .collection('languages')
              .doc(language)
              .collection('vocabulary')
              .doc(docId)
              .collection('words')
              .doc(doc.id)
              .get();
          if (wordDoc.exists && wordDoc.data() != null) {
            final wordData = Map<String, dynamic>.from(wordDoc.data()!);
            wordData['srs_interval'] = data['interval'] ?? 1;
            wordData['srs_repetitions'] = data['repetitions'] ?? 0;
            wordData['srs_next_review'] = data['next_review'];
            final model = WordModel.fromJson(wordData);
            list.add(model);

            // Auto-upgrade legacy card to include word_data
            await updateSrsCard(model, language);
          }
        } catch (e) {
          log("Fallback fetch failed for legacy card ${doc.id}: $e");
        }
      }
    }
    return list;
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

  Future<void> checkAndUpdateStreak(String uid) async {
    try {
      final docRef = _firestore.collection('users').doc(uid);
      final snapshot = await docRef.get();
      if (!snapshot.exists) return;
      final data = snapshot.data() ?? {};

      final today = DateTime.now();
      final todayStr = DateFormat('yyyy-MM-dd').format(today);
      final lastSessionDateStr = data['lastSessionDate'] as String?;
      final lastCheckedDateStr = data['lastCheckedDate'] as String?;

      if (lastCheckedDateStr == todayStr) {
        log("Streak check already completed today. Skipping.");
        return;
      }

      final updates = <String, dynamic>{'lastCheckedDate': todayStr};

      if (lastSessionDateStr != null) {
        final lastSessionDate = DateTime.parse(lastSessionDateStr);
        final todayMidnight = DateTime(today.year, today.month, today.day);
        final lastSessionMidnight = DateTime(
          lastSessionDate.year,
          lastSessionDate.month,
          lastSessionDate.day,
        );
        final daysDiff = todayMidnight.difference(lastSessionMidnight).inDays;

        if (daysDiff > 1) {
          final missedDays = daysDiff - 1;
          final freezesOwned = (data['freezesOwned'] ?? 0) as int;

          if (freezesOwned >= missedDays) {
            updates['freezesOwned'] = freezesOwned - missedDays;
            updates['consecutiveSessionDays'] = 0;
            final yesterday = todayMidnight.subtract(const Duration(days: 1));
            updates['lastSessionDate'] = DateFormat(
              'yyyy-MM-dd',
            ).format(yesterday);

            final weekHistory = Map<String, String>.from(
              (data['weekHistory'] as Map?)?.map(
                    (k, v) => MapEntry(k.toString(), v.toString()),
                  ) ??
                  {},
            );
            for (int i = 1; i <= missedDays; i++) {
              final missedDate = lastSessionMidnight.add(Duration(days: i));
              final missedDateStr = DateFormat('yyyy-MM-dd').format(missedDate);
              weekHistory[missedDateStr] = 'freeze';
            }
            updates['weekHistory'] = weekHistory;
            log(
              "❄️ Consumed $missedDays streak freeze(s) for user $uid. Streak continues!",
            );
          } else {
            updates['currentStreak'] = 0;
            updates['current_streak'] = 0;
            updates['consecutiveSessionDays'] = 0;
            updates['freezesOwned'] = 0;
            log("💔 Streak broke for user $uid. Streak reset to 0.");
          }
        }
      } else {
        // Initialize fields if not set
        updates['currentStreak'] =
            data['currentStreak'] ?? data['current_streak'] ?? 0;
        updates['consecutiveSessionDays'] = data['consecutiveSessionDays'] ?? 0;
        updates['freezesOwned'] = data['freezesOwned'] ?? 0;
      }

      // Populate current week's history (Mon-Sun)
      final currentWeekHistory = Map<String, String>.from(
        (updates['weekHistory'] ?? data['weekHistory'] as Map?)?.map(
              (k, v) => MapEntry(k.toString(), v.toString()),
            ) ??
            {},
      );

      final todayMidnight = DateTime(today.year, today.month, today.day);
      final monday = todayMidnight.subtract(Duration(days: todayMidnight.weekday - 1));

      for (int i = 0; i < 7; i++) {
        final day = monday.add(Duration(days: i));
        final dayStr = DateFormat('yyyy-MM-dd').format(day);
        
        if (day.isAfter(todayMidnight)) {
          currentWeekHistory[dayStr] = 'future';
        } else if (day.isBefore(todayMidnight)) {
          if (currentWeekHistory[dayStr] != 'completed' && currentWeekHistory[dayStr] != 'freeze') {
            currentWeekHistory[dayStr] = 'missed';
          }
        } else { // today
          if (currentWeekHistory[dayStr] != 'completed') {
            currentWeekHistory[dayStr] = 'pending';
          }
        }
      }
      updates['weekHistory'] = currentWeekHistory;

      await docRef.update(updates);
      log("✅ checkAndUpdateStreak completed for $uid.");
    } catch (e) {
      log("❌ Error in checkAndUpdateStreak: $e");
    }
  }

  Future<bool> onSessionCompleted(String uid) async {
    try {
      final docRef = _firestore.collection('users').doc(uid);
      final streakUpdated = await _firestore.runTransaction<bool>((
        transaction,
      ) async {
        final snapshot = await transaction.get(docRef);
        if (!snapshot.exists) return false;
        final data = snapshot.data() ?? {};

        final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
        final lastSessionDateStr = data['lastSessionDate'] as String?;
        int currentStreak =
            (data['currentStreak'] ?? data['current_streak'] ?? 0) as int;
        int consecutiveSessionDays =
            (data['consecutiveSessionDays'] ?? 0) as int;
        int freezesOwned = (data['freezesOwned'] ?? 0) as int;
        final isPremium =
            (data['isPremium'] ?? data['is_premium'] ?? false) as bool;

        if (lastSessionDateStr == todayStr) {
          log("Session already completed today. Skipping streak increment.");
          return false;
        }

        currentStreak += 1;
        consecutiveSessionDays += 1;

        if (consecutiveSessionDays >= 7) {
          consecutiveSessionDays = 0;
          if (isPremium) {
            freezesOwned += 1;
            log(
              "🌟 Premium user earned a freeze! Total freezes: $freezesOwned",
            );
          } else {
            if (freezesOwned < 1) {
              freezesOwned = 1;
              log("🌟 Free user earned a freeze!");
            } else {
              log("🌟 Free user already owns max freezes (1).");
            }
          }
        }

        final longestStreak = (data['longest_streak'] ?? 0) as int;
        final newLongest = currentStreak > longestStreak
            ? currentStreak
            : longestStreak;

        final weekHistory = Map<String, String>.from(
          (data['weekHistory'] as Map?)?.map(
                (k, v) => MapEntry(k.toString(), v.toString()),
              ) ??
              {},
        );
        weekHistory[todayStr] = 'completed';

        transaction.update(docRef, {
          'currentStreak': currentStreak,
          'current_streak': currentStreak,
          'consecutiveSessionDays': consecutiveSessionDays,
          'freezesOwned': freezesOwned,
          'lastSessionDate': todayStr,
          'longest_streak': newLongest,
          'last_lesson_date': FieldValue.serverTimestamp(),
          'weekHistory': weekHistory,
        });
        return true;
      });
      log(
        "✅ onSessionCompleted executed for $uid. Streak updated: $streakUpdated",
      );
      return streakUpdated;
    } catch (e) {
      log("❌ Error in onSessionCompleted: $e");
      return false;
    }
  }

  Future<int> getCurrentStreak() async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) return 0;

      final doc = await _firestore.collection('users').doc(uid).get();
      final data = doc.data() ?? {};

      return (data['currentStreak'] ?? data['current_streak'] ?? 0) as int;
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
