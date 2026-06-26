import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:chatbot_app/modules/homepage/screen/streak_celebration_screen.dart';
import 'package:chatbot_app/modules/homepage/provider/homescreen_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:chatbot_app/generated/l10n.dart';

void main() {
  testWidgets('StreakCelebrationScreen renders and doesn\'t crash', (WidgetTester tester) async {
    final homeProvider = HomescreenProvider();
    homeProvider.currentStreak = 5;
    homeProvider.weekHistory = {
      '2026-06-22': 'completed',
    };

    await tester.pumpWidget(
      ChangeNotifierProvider<HomescreenProvider>.value(
        value: homeProvider,
        child: ScreenUtilInit(
          designSize: const Size(390, 844),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return const MaterialApp(
              localizationsDelegates: [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              home: StreakCelebrationScreen(),
            );
          },
        ),
      ),
    );

    // Build the first frame, animation starts.
    await tester.pump();
    
    // We expect the widget to render.
    expect(find.byType(StreakCelebrationScreen), findsOneWidget);
    
    // Let the animations run for a bit.
    await tester.pump(const Duration(seconds: 3));

    // Unmount the widget tree.
    await tester.pumpWidget(const SizedBox());
    
    // Pump the event loop to allow unmount timers to execute and clear.
    await tester.pump(const Duration(seconds: 1));
  });
}
