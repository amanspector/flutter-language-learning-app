import 'package:chatbot_app/appconstants/color_constant.dart';
import 'package:chatbot_app/provider/cred_provider.dart';
import 'package:chatbot_app/repository/gemini_repo.dart';
import 'package:chatbot_app/screens/auth/authgate.dart';
import 'package:chatbot_app/services/firebase_chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:chatbot_app/provider/message_provider.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
      ],

      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chatbot',
        theme: ThemeData(
          textTheme: TextTheme(),
          fontFamily: 'InstrumentSerif',
          brightness: Brightness.dark,
          colorScheme: ColorScheme.fromSeed(
            brightness: Brightness.dark,
            primary: ColorConstant.color_white,
            seedColor: Colors.transparent,
          ),
        ),
        home: Authgate(),
      ),
    );
  }
}
