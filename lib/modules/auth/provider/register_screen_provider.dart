import 'package:chatbot_app/core/appconstants/text_constant.dart';
import 'package:chatbot_app/core/widgets/app_showLoading.dart';
import 'package:chatbot_app/modules/auth/service/firebase_auth_service.dart';
import 'package:chatbot_app/modules/homepage/provider/homescreen_provider.dart';
import 'package:chatbot_app/modules/onboarding/provider/onboard_provider.dart';
import 'package:chatbot_app/modules/onboarding/screen/main_onboarding.dart';
import 'package:chatbot_app/modules/vocabularypage/provider/vocab_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterscreenProvider extends ChangeNotifier {
  final TextEditingController mailcontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  final TextEditingController confirmpasswordcontroller =
      TextEditingController();
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  int? selectedAge;
  String? selectedGender;
  String? msg;
  final formkey = GlobalKey<FormState>();
  final FirebaseAuthService authobj = FirebaseAuthService();
  bool _isLoading = false;

  void clearData() {
    _isLoading = false;
    mailcontroller.clear();
    passwordcontroller.clear();
    confirmpasswordcontroller.clear();
    msg = null;
    notifyListeners();
  }

  Future<void> register(
    BuildContext context,
    String email,
    String password,
  ) async {
    if (_isLoading) return;
    _isLoading = true;
    notifyListeners();

    AppShowloading.show(context, CircularProgressIndicator());

    try {
      String? error = await authobj.registration(
        context: context,
        email: email,
        password: password,
        gender: selectedGender!,
        age: selectedAge ?? 24,
      );
      if (!context.mounted) return;
      if (error != null) {
        AppShowloading.hide(context);
        setErrorMsg(error);
      } else {
        context.read<OnboardProvider>().reset();
        context.read<VocabProvider>().reset();
        context.read<HomescreenProvider>().resetUserState();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(Textconstant.txtRegistersucess)),
        );

        clearData();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => MainOnboarding()),
          (route) => false,
        );
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setAge(int age) {
    selectedAge = age;
    notifyListeners();
  }

  void setGender(String gender) {
    selectedGender = gender;
    notifyListeners();
  }

  bool isPassword() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
    return isPasswordVisible;
  }

  bool isConfirmPassword() {
    isConfirmPasswordVisible = !isConfirmPasswordVisible;
    notifyListeners();
    return isConfirmPasswordVisible;
  }

  void setErrorMsg(String? error) {
    msg = error;
    notifyListeners();
  }
}
