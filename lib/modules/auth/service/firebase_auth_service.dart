import 'dart:developer';
import 'package:chatbot_app/core/extensions/localization_extension.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseAuthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<String?> registration({
    required BuildContext context,
    required String email,
    required String password,
    required String gender,
    required int age,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = credential.user!.uid;
      await _firestore.collection('users').doc(uid).set({
        'uid': uid,
        'email': email,
        'gender': gender,
        'age': age,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return null;
    } on FirebaseAuthException catch (e) {
      log('Register error: ${e.code}');
      if (e.code == "email-already-in-use") {
        return context.l10n.emailAddressAlreadyExistsTryToLogin;
      }
      return e.message ?? context.l10n.registrationFailed;
    } catch (e) {
      log('Register unknown error: $e');
      return context.l10n.somethingWentWrong;
    }
  }

  Future<String?> login(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      log(e.toString());

      if (e.code == 'invalid-credential') {
        return context.l10n.invalidCredential;
      }

      if (e.code == 'too-many-requests') {
        return context.l10n.tooManyAttemptsTryAgainLater;
      }
      return e.message ?? context.l10n.loginFailed;
    } catch (e) {
      log(e.toString());
      return context.l10n.somethingWentWrong;
    }
  }

  Future<DocumentSnapshot> getUserData(String uid) async {
    return _firestore.collection('users').doc(uid).get();
  }

  Future<void> updateUserData(String uid, Map<String, dynamic> data) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .set(data, SetOptions(merge: true));
  }

  Future<String?> updateEmail(String email) async {
    final user = _auth.currentUser;
    if (user == null) {
      return 'No authenticated user';
    }

    try {
      // await user.u(email);
      await updateUserData(user.uid, {'email': email});
      return null;
    } on FirebaseAuthException catch (e) {
      log('Update email error: ${e.code}');
      switch (e.code) {
        case 'email-already-in-use':
          return 'This email address is already in use.';
        case 'invalid-email':
          return 'Please enter a valid email address.';
        case 'requires-recent-login':
          return 'Please sign in again before changing your email.';
        default:
          return e.message ?? 'Failed to update email.';
      }
    } catch (e) {
      log('Update email unknown error: $e');
      return 'Failed to update email.';
    }
  }

  static String getuid() {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
