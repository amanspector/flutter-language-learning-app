import 'package:chatbot_app/core/extensions/localization_extension.dart';
import 'package:chatbot_app/modules/chatbotpage/service/firebase_chat_service.dart';
import 'package:chatbot_app/modules/onboarding/provider/getStarted_provider.dart';
import 'package:chatbot_app/modules/vocabularypage/provider/vocab_provider.dart';
import 'package:chatbot_app/modules/auth/provider/register_screen_provider.dart';
import 'package:chatbot_app/modules/exercisepage/provider/lesson_provider.dart';
import 'package:chatbot_app/modules/chatbotpage/provider/message_provider.dart';
import 'package:chatbot_app/modules/homepage/provider/homescreen_provider.dart';
import 'package:chatbot_app/modules/onboarding/provider/onboard_provider.dart';
import 'package:chatbot_app/modules/auth/provider/login_screen_provider.dart';
import 'package:chatbot_app/modules/splashScreen/screen/splashScreen.dart';
import 'package:chatbot_app/modules/chatbotpage/repo/gemini_repo.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:chatbot_app/core/widgets/app_theme_data.dart';
import 'package:chatbot_app/core/widgets/app_navigator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:chatbot_app/generated/l10n.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
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
        ChangeNotifierProvider(create: (_) => GetstartedProvider()),
        ChangeNotifierProvider(create: (_) => HomescreenProvider()),
        ChangeNotifierProvider(
          create: (_) => MessageProvider(repo: repo, service: service),
        ),
        ChangeNotifierProvider(create: (_) => LoginscreenProvider()),
        ChangeNotifierProvider(create: (_) => RegisterscreenProvider()),
        ChangeNotifierProvider(create: (_) => OnboardProvider()),
        ChangeNotifierProvider(create: (_) => VocabProvider()),
        ChangeNotifierProvider(create: (_) => LessonProvider()),
      ],

      child: ScreenUtilInit(
        designSize: const Size(390, 844),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return Consumer<OnboardProvider>(
            builder: (context, onboard, child) {
              return MaterialApp(
                navigatorKey: navigatorKey,
                debugShowCheckedModeBanner: false,
                locale: Locale(onboard.selectedNativeLanguage.toString()),
                onGenerateTitle: (BuildContext context) => context.l10n.appName,
                localizationsDelegates: [
                  S.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: S.delegate.supportedLocales,
                theme: AppThemedata.lightThemeData,
                home: Splashscreen(),
              );
            },
          );
        },
      ),
    );
  }
}
