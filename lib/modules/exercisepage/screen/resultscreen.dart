import 'package:chatbot_app/core/appconstants/color_constant.dart';
import 'package:chatbot_app/core/extensions/localization_extension.dart';
import 'package:chatbot_app/core/extensions/theme_extension.dart';
import 'package:chatbot_app/core/widgets/app_button.dart';
import 'package:chatbot_app/core/widgets/app_circular_progress.dart';
import 'package:chatbot_app/core/widgets/app_customContainer.dart';
import 'package:chatbot_app/generated/l10n.dart';
import 'package:chatbot_app/modules/homepage/provider/homescreen_provider.dart';
import 'package:chatbot_app/modules/exercisepage/provider/lesson_provider.dart';
import 'package:chatbot_app/modules/homepage/screen/homescreen.dart';
import 'package:chatbot_app/modules/onboarding/provider/onboard_provider.dart';
import 'package:chatbot_app/modules/splashScreen/screen/ambient_background.dart';
import 'package:chatbot_app/modules/vocabularypage/provider/vocab_provider.dart';
import 'package:confetti/confetti.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ResultScreen extends HookWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoading = useState(false);
    final provider = context.read<LessonProvider>();
    final scorePercentage = provider.exercises.isEmpty
        ? 0.0
        : (provider.score / provider.totalExercises) * 100;

    String performanceMessage() {
      final percentage = scorePercentage;
      if (percentage >= 90) return context.l10n.perfExcellent;
      if (percentage >= 75) return context.l10n.greatJob;
      if (percentage >= 60) return context.l10n.perfGoodWork;
      if (percentage >= 50) return context.l10n.perfKeepPracticing;
      return S.of(context).perfReviewAndTryAgain;
    }

    Widget buildStatItem({
      required String emoji,
      required String label,
      required String value,
    }) {
      return Expanded(
        child: Column(
          children: [
            Text(emoji, style: TextStyle(fontSize: 28.sp)),
            SizedBox(height: 6.h),
            Text(
              value,
              style: context.text.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: context.text.bodySmall?.copyWith(
                color: context.theme.colorScheme.outline,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    Widget buildStatDivider() {
      return Container(
        height: 48.h,
        width: 1,
        color: context.theme.colorScheme.outline.withValues(alpha: 0.2),
      );
    }

    final fadeController = useAnimationController(
      duration: Duration(milliseconds: 800),
    );
    final scaleController = useAnimationController(
      duration: Duration(milliseconds: 600),
    );
    // final confettiController = use(
    //   _ConfettiHook(duration: Duration(seconds: 4)),
    // );

    final fadeAnimation = CurvedAnimation(
      parent: fadeController,
      curve: Curves.easeOut,
    );
    final scaleAnimation = CurvedAnimation(
      parent: scaleController,
      curve: Curves.elasticOut,
    );

    final confettiController = useMemoized(
      () => ConfettiController(duration: Duration(seconds: 4))..play(),
    );
    useEffect(() => confettiController.dispose, []);
    useEffect(() {
      fadeController.forward();
      Future.delayed(
        Duration(milliseconds: 200),
        () => scaleController.forward(),
      );
      if (scorePercentage >= 70) {
        confettiController.play();
        HapticFeedback.heavyImpact();
      }
      return null;
    }, []);

    return Scaffold(
      body: Stack(
        children: [
          AmbientBackground(
            child: SafeArea(
              child: FadeTransition(
                opacity: fadeAnimation,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    children: [
                      SizedBox(height: 80.h),
                      ScaleTransition(
                        scale: scaleAnimation,
                        child: Text(
                          performanceMessage(),
                          style: context.text.displayMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      SizedBox(height: 32.h),

                      // Score card with TicketPainter
                      Expanded(
                        child: CustomPaint(
                          painter: TicketPainter(
                            concaveDepth: 20,
                            glowColor: context.theme.colorScheme.primary,
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 30.w,
                              vertical: 32.h,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Score ring
                                AppCircularProgress(
                                  showPercentage: true,
                                  score: provider.score,
                                  total: provider.totalExercises,
                                  size: 160,
                                  strokeWidth: 16,
                                ),

                                // Divider
                                Divider(
                                  color: context.theme.colorScheme.outline
                                      .withValues(alpha: 0.2),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    buildStatItem(
                                      emoji: '⭐',
                                      label: context.l10n.xpEarned,
                                      value: '+${provider.xpEarned}',
                                    ),
                                    buildStatDivider(),
                                    buildStatItem(
                                      emoji: '✅',
                                      label: context.l10n.correct,
                                      value: '${provider.score}',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 80.h),

                      // Continue button
                      AppButton(
                        isLoading: isLoading.value,
                        buttonFunc: () async {
                          isLoading.value = true;
                          try {
                            final vocab = context.read<VocabProvider>();
                            final lesson = context.read<LessonProvider>();
                            final onboard = context.read<OnboardProvider>();
                            final homeProvider = context
                                .read<HomescreenProvider>();
                            final uid = FirebaseAuth.instance.currentUser!.uid;
                            await vocab.loadNextBatch(onboard);
                            lesson.initWordsFromVocab(vocab.todaywords);
                            if (!context.mounted) return;
                            await lesson.startLesson(
                              con: context,
                              userDailyGoalMinutes: vocab.maxWordsForLevel,
                              words: vocab.todaywords,
                            );
                            if (!context.mounted) return;
                            lesson.generateExercises(context);
                            await homeProvider.loadUserStats(uid);
                            if (!context.mounted) return;
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (_) => Homescreen()),
                              (route) => false, // removes all previous routes
                            );
                          } finally {
                            isLoading.value = false;
                          }
                        },
                        childWidget: Text(
                          context.l10n.continueText,
                          style: context.text.labelMedium,
                        ),
                      ),

                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Confetti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: [
                ColorConstant.colorGreen,
                ColorConstant.colorBlue,
                ColorConstant.colorPink,
                ColorConstant.colorOrange,
                ColorConstant.colorPurple,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
