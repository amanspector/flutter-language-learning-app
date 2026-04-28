import 'package:chatbot_app/services/firebase_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CredProvider extends ChangeNotifier {
  bool isloading = false;
  final FirebaseAuthService authobj = FirebaseAuthService();
  String? gmail;

  CredProvider() {
    FirebaseAuth.instance.authStateChanges().listen((event) {
      gmail = event?.email;
      notifyListeners();
    });
  }
  void getGmail(User? user) {
    gmail = user?.email;
    notifyListeners();
  }

  Future<String?> login(String email, String password) async {
    isloading = true;
    notifyListeners();

    String? error = await authobj.login(email, password);
    isloading = false;
    notifyListeners();
    return error;
  }

  Future<String?> register(String email, String password) async {
    String? error = await FirebaseAuthService().registraion(email, password);
    notifyListeners();
    return error;
  }
}
