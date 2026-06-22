import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomescreenService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<Map<String, dynamic>?> getLastLesson(String languageCode) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception("User not logged in");

    final snapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('languages')
        .doc(languageCode)
        .collection('lesson_history')
        .orderBy('completed_at', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;
    final data = snapshot.docs.first.data();
    data['doc_id'] = snapshot.docs.first.id;
    return data;
  }

  Future<List<Map<String, dynamic>>> getLessonHistory(
    String languageCode,
  ) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception("User not logged in");

    final snapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('languages')
        .doc(languageCode)
        .collection('lesson_history')
        .orderBy('completed_at', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['doc_id'] = doc.id;
      return data;
    }).toList();
  }
}
