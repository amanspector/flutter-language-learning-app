// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:chatbot_app/main.dart';
import 'package:chatbot_app/modules/chatbotpage/repo/gemini_repo.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    setupFirebaseCoreMocks();
    await Firebase.initializeApp();
    dotenv.loadFromString(
      envString: '''
GEMINI_BASE_URL=https://api.gemini.com
SARVAM_BASE_URL=https://api.sarvam.ai
PUTER_BASE_URL=https://api.puter.com
SMALLEST_BASE_URL=https://api.smallest.ai
API_KEY=mock_api_key
SARVAM_API=mock_sarvam_api
SMALLEST_API=mock_smallest_api
PUTER_AUTH=mock_puter_auth
''',
    );
  });

  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(repo: GeminiRepo()));

    // Verify that MyApp is rendered.
    expect(find.byType(MyApp), findsOneWidget);

    // Unmount the widget tree.
    await tester.pumpWidget(const SizedBox());

    // Pump the event loop to allow unmount timers to execute and clear.
    await tester.pump(const Duration(seconds: 5));
  });
}
