import 'package:chatbot_app/core/appconstants/color_constant.dart';
import 'package:chatbot_app/core/extensions/localization_extension.dart';
import 'package:chatbot_app/core/extensions/theme_extension.dart';
import 'package:chatbot_app/core/widgets/app_button.dart';
import 'package:chatbot_app/core/widgets/app_circular_progress.dart';
import 'package:chatbot_app/core/widgets/app_customContainer.dart';
import 'package:chatbot_app/core/widgets/app_haptic_counter.dart';
import 'package:chatbot_app/modules/homepage/provider/homescreen_provider.dart';
import 'package:chatbot_app/modules/exercisepage/provider/lesson_provider.dart';
import 'package:chatbot_app/modules/homepage/screen/homescreen.dart';
import 'package:chatbot_app/modules/homepage/screen/streak_celebration_screen.dart';
import 'package:chatbot_app/modules/onboarding/provider/onboard_provider.dart';
import 'package:chatbot_app/modules/splashScreen/screen/ambient_background.dart';
import 'package:chatbot_app/modules/vocabularypage/provider/vocab_provider.dart';
import 'package:confetti/confetti.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ResultScreen extends HookWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<LessonProvider>();
    final activeStep = useState(0); // 0 = circular progress, 1 = XP, 2 = Timer
    final scorePercentage = provider.exercises.isEmpty
        ? 0.0
        : (provider.score / provider.totalExercises) * 100;

    String performanceMessage() {
      final percentage = scorePercentage;
      if (percentage >= 90) return context.l10n.perfExcellent;
      if (percentage >= 75) return context.l10n.greatJob;
      if (percentage >= 60) return context.l10n.perfGoodWork;
      if (percentage >= 50) return context.l10n.perfKeepPracticing;
      return context.l10n.perfReviewAndTryAgain;
    }

    String formatSeconds(int totalSecs) {
      final minutes = totalSecs ~/ 60;
      final seconds = totalSecs % 60;
      if (minutes > 0) {
        return '${minutes}m ${seconds}s';
      } else {
        return '${seconds}s';
      }
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

    // Score-based confetti intensity
    final int confettiSeconds = scorePercentage >= 90
        ? 8
        : scorePercentage >= 70
        ? 5
        : scorePercentage >= 50
        ? 3
        : scorePercentage > 0
        ? 2
        : 0;
    final int confettiParticles = scorePercentage >= 90
        ? 20
        : scorePercentage >= 70
        ? 15
        : scorePercentage >= 50
        ? 10
        : scorePercentage > 0
        ? 5
        : 0;
    final double confettiEmission = scorePercentage >= 90
        ? 0.05
        : scorePercentage >= 70
        ? 0.08
        : scorePercentage >= 50
        ? 0.12
        : scorePercentage > 0
        ? 0.18
        : 0.0;

    final confettiController = useMemoized(
      () => ConfettiController(
        duration: Duration(seconds: confettiSeconds > 0 ? confettiSeconds : 1),
      ),
    );
    useEffect(() => confettiController.dispose, []);
    useEffect(() {
      fadeController.forward();
      Future.delayed(
        Duration(milliseconds: 200),
        () => scaleController.forward(),
      );
      if (confettiSeconds > 0) {
        confettiController.play();
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.refresh_rounded,
                              color: context.theme.colorScheme.onSurface
                                  .withValues(alpha: 0.60),
                              size: 26.r,
                            ),
                            onPressed: () {
                              activeStep.value = 0;
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
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
                                AppHapticCounter(
                                  begin: 0,
                                  end: provider.score,
                                  currentStep: activeStep.value,
                                  myStep: 0,
                                  onComplete: () {
                                    Future.delayed(
                                      const Duration(milliseconds: 500),
                                      () {
                                        if (context.mounted) {
                                          activeStep.value = 1;
                                        }
                                      },
                                    );
                                  },
                                  builder: (context, animatedScore) {
                                    return AppCircularProgress(
                                      showPercentage: true,
                                      score: animatedScore,
                                      total: provider.totalExercises,
                                      size: 160,
                                      strokeWidth: 16,
                                      isStatic: true,
                                    );
                                  },
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
                                    AppHapticCounter(
                                      begin: 0,
                                      end: provider.xpEarned,
                                      currentStep: activeStep.value,
                                      myStep: 1,
                                      onComplete: () {
                                        Future.delayed(
                                          const Duration(milliseconds: 500),
                                          () {
                                            if (context.mounted) {
                                              activeStep.value = 2;
                                            }
                                          },
                                        );
                                      },
                                      builder: (context, animatedXp) {
                                        return ResultStatItem(
                                          emoji: '⭐',
                                          label: context.l10n.xpEarned,
                                          value: '+$animatedXp',
                                        );
                                      },
                                    ),
                                    buildStatDivider(),
                                    ResultStatItem(
                                      emoji: '✅',
                                      label: context.l10n.correct,
                                      value: '${provider.score}',
                                    ),
                                    buildStatDivider(),
                                    AppHapticCounter(
                                      begin: 0,
                                      end: provider.elapsedSeconds,
                                      currentStep: activeStep.value,
                                      myStep: 2,
                                      builder: (context, animatedSeconds) {
                                        return ResultStatItem(
                                          emoji: '⏱️',
                                          label: context.l10n.timeTaken,
                                          value: formatSeconds(animatedSeconds),
                                        );
                                      },
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
                        isLoading: false,
                        buttonFunc: () {
                          final vocab = context.read<VocabProvider>();
                          final lesson = context.read<LessonProvider>();
                          final onboard = context.read<OnboardProvider>();
                          final homeProvider = context
                              .read<HomescreenProvider>();
                          final user = FirebaseAuth.instance.currentUser;
                          if (user == null) return;
                          final uid = user.uid;

                          if (lesson.streakUpdated) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const StreakCelebrationScreen(),
                              ),
                            );
                          } else {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (_) => Homescreen()),
                              (route) => false,
                            );
                          }

                          // Generate exercises and load next batch in the background
                          Future(() async {
                            try {
                              await vocab.loadNextBatch(onboard);
                              lesson.initWordsFromVocab(vocab.todaywords);
                              await lesson.startLesson(
                                userDailyGoalMinutes: vocab.maxWordsForLevel,
                                words: vocab.todaywords,
                              );
                              await homeProvider.loadUserStats(uid);
                            } catch (e) {
                              debugPrint("Background generation error: $e");
                            }
                          });
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

          // Confetti — intensity scales with score
          if (confettiParticles > 0)
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                numberOfParticles: confettiParticles,
                emissionFrequency: confettiEmission,
                gravity: 0.2,
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

class ResultStatItem extends StatelessWidget {
  final String emoji;
  final String label;
  final String value;

  const ResultStatItem({
    super.key,
    required this.emoji,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
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
}
