import 'package:chatbot_app/appconstants/color_constant.dart';
import 'package:chatbot_app/provider/cred_provider.dart';
import 'package:chatbot_app/provider/onboard_provider.dart';
import 'package:chatbot_app/provider/vocab_provider.dart';
import 'package:chatbot_app/repository/gemini_repo.dart';
import 'package:chatbot_app/screens/auth/authgate.dart';
import 'package:chatbot_app/screens/onboarding/getStarted.dart';
import 'package:chatbot_app/screens/onboarding/goalSelection.dart';
import 'package:chatbot_app/screens/onboarding/languageSelection.dart';
import 'package:chatbot_app/screens/onboarding/main_onboarding.dart';
import 'package:chatbot_app/screens/vocabscreen.dart';
import 'package:chatbot_app/services/firebase_chat_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:chatbot_app/provider/message_provider.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  final repo = GeminiRepo();

  runApp(MyApp(repo: repo));
}

class MyApp extends StatelessWidget {
  final GeminiRepo repo;

  final service = FirebaseChatService();
  MyApp({super.key, required this.repo});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MessageProvider(repo: repo, service: service),
        ),
        ChangeNotifierProvider(create: (_) => CredProvider()),
        ChangeNotifierProvider(create: (_) => OnboardProvider()),
        ChangeNotifierProvider(create: (_) => VocabProvider()),
      ],

      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chatbot',
        theme: ThemeData(
          textTheme: TextTheme(
            bodyLarge: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            bodyMedium: TextStyle(fontSize: 20),
            labelMedium: TextStyle(
              fontSize: 20,
              color: ColorConstant.color_black,
            ),
            displayMedium: TextStyle(fontSize: 25),
            displaySmall: TextStyle(
              height: 1.5,
              fontSize: 20,
              fontWeight: FontWeight.normal,
            ),
            headlineMedium: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w100,
              color: Color(0xff94A3B8),
            ),
          ),
          fontFamily: 'InstrumentSerif',
          brightness: Brightness.dark,
          colorScheme: ColorScheme.fromSeed(
            brightness: Brightness.dark,
            primary: ColorConstant.color_white,
            seedColor: Colors.transparent,
            primaryContainer: ColorConstant.color_white_withalpha30,
          ),
        ),
        home: MainOnboarding(),
      ),
    );
  }
}
