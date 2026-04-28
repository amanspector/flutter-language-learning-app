import 'package:chatbot_app/appconstants/text_constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseAuthService {
  Future<String?> registraion(String email, String password) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        return Textconstant.txt_emailalreadyexists;
      }
      return e.toString();
    }
  }

  Future<String?> login(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      print(e);

      if (e.code == 'invalid-credential') {
        return Textconstant.txt_invalidcredentail;
      }

      if (e.code == 'too-many-requests') {
        return Textconstant.txt_toomanyrequests;
      }
      return e.message ?? "Login failed";
    } catch (e) {
      print(e);
      return "Somthing went wrong";
    }
  }
}
