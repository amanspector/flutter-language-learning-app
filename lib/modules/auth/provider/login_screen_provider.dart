import 'package:chatbot_app/modules/auth/service/firebase_auth_service.dart';
import 'package:chatbot_app/modules/homepage/screen/homescreen.dart';
import 'package:chatbot_app/modules/onboarding/provider/onboard_provider.dart';
import 'package:chatbot_app/modules/onboarding/screen/getStarted.dart';
import 'package:chatbot_app/modules/onboarding/screen/main_onboarding.dart';
import 'package:chatbot_app/modules/splashScreen/service/sessionManage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginscreenProvider extends ChangeNotifier {
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  final FirebaseAuthService authobj = FirebaseAuthService();
  final formkey = GlobalKey<FormState>();
  bool isPasswordVisible = false;
  bool isloading = false;
  bool islogout = false;
  String? gmail;
  String? msg;

  LoginscreenProvider() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        gmail = user.email;
        notifyListeners();
      }
    });
  }

  void getGmail(User? user) {
    gmail = user?.email;
    notifyListeners();
  }

  Future<void> login(
    BuildContext context,
    String email,
    String password,
  ) async {
    if (isloading) return;
    isloading = true;
    notifyListeners();

    try {
      String? error = await authobj.login(context, email, password);
      if (!context.mounted) return;
      if (error != null) {
        setErrorMsg(error);
        return;
      }
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;
      if (!context.mounted) return;
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //     builder: (_) => AppLoadingScreen(),
      //     // AppShowloading(message: context.l10n.generatingYourVocabulary),
      //   ),
      // );

      final isReady = await Sessionmanage.loadAndInitializeUser(
        context,
        currentUser.uid,
      );

      if (!context.mounted) return;
      clearloginData();

      _navigateAfterLogin(context, isReady);
    } finally {
      isloading = false;
      notifyListeners();
    }
  }

  void _navigateAfterLogin(BuildContext context, bool isReady) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => isReady ? Homescreen() : MainOnboarding(),
      ),
      (route) => false,
    );
  }

  Future<void> logout(BuildContext con) async {
    islogout = true;
    notifyListeners();
    await FirebaseAuth.instance.signOut();
    if (!con.mounted) return;
    con.read<OnboardProvider>().setSelectedNativeLanguage('en');
    Navigator.pushAndRemoveUntil(
      con,
      MaterialPageRoute(builder: (_) => Getstarted()),
      (route) => false,
    );

    islogout = false;
    notifyListeners();
  }

  bool isPass() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
    return isPasswordVisible;
  }

  void setErrorMsg(String? error) {
    msg = error;
    notifyListeners();
  }

  void clearloginData() {
    emailcontroller.clear();
    passwordcontroller.clear();
    msg = null;
    isPasswordVisible = false;
    notifyListeners();
  }

  void isloadtrue() {
    isloading = true;
    notifyListeners();
  }

  void isloadfalse() {
    isloading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    emailcontroller.dispose();
    passwordcontroller.dispose();
    super.dispose();
  }
}
