import 'dart:math';
import 'package:chatbot_app/core/appconstants/color_constant.dart';
import 'package:chatbot_app/core/extensions/localization_extension.dart';
import 'package:chatbot_app/core/extensions/theme_extension.dart';
import 'package:chatbot_app/core/widgets/app_button.dart';
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
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with TickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _confettiController = ConfettiController(duration: Duration(seconds: 4));
    _fadeController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _scaleController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    );

    // triggers last
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fadeController.forward();
      Future.delayed(Duration(milliseconds: 200), () {
        if (mounted) _scaleController.forward();
      });
      if (scorePercentage >= 70) {
        _confettiController.play();
      }
    });
  }

  double get scorePercentage {
    final provider = context.read<LessonProvider>();
    if (provider.exercises.isEmpty) return 0;
    return ((provider.score / provider.totalExercises) * 100);
  }

  String get performanceMessage {
    final percentage = scorePercentage;
    if (percentage >= 90) return S.of(context).perfExcellent;
    if (percentage >= 75) return S.of(context).greatJob;
    if (percentage >= 60) return S.of(context).perfGoodWork;
    if (percentage >= 50) return S.of(context).perfKeepPracticing;
    return S.of(context).perfReviewAndTryAgain;
  }

  String get performanceEmoji {
    final percentage = scorePercentage;
    if (percentage >= 90) return '🏆';
    if (percentage >= 75) return '🌟';
    if (percentage >= 60) return '👍';
    if (percentage >= 50) return '💪';
    return '📚';
  }

  Color get scoreColor {
    final percentage = scorePercentage;
    if (percentage >= 90) return ColorConstant.green400;
    if (percentage >= 75) return ColorConstant.blue400;
    if (percentage >= 60) return ColorConstant.orange400;
    return ColorConstant.red400;
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LessonProvider>();

    return Scaffold(
      body: Stack(
        children: [
          AmbientBackground(
            child: SafeArea(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    children: [
                      SizedBox(height: 32.h),

                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: Text(
                          performanceMessage,
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
                            glowColor: Theme.of(context).colorScheme.primary,
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 24.w,
                              vertical: 32.h,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Score ring
                                _AnimatedScoreRing(
                                  percentage: scorePercentage,
                                  color: scoreColor,
                                  score: provider.score,
                                  total: provider.totalExercises,
                                ),

                                // Divider
                                Divider(
                                  color: context.theme.colorScheme.outline
                                      .withValues(alpha: 0.2),
                                ),

                                // Stats row
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildStatItem(
                                      emoji: '⭐',
                                      label: context.l10n.xpEarned,
                                      value: '+${provider.xpEarned}',
                                    ),
                                    _buildStatDivider(),
                                    _buildStatItem(
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

                      SizedBox(height: 24.h),

                      // Continue button
                      AppButton(
                        buttonFunc: () async {
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
              confettiController: _confettiController,
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

  Widget _buildStatItem({
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

  Widget _buildStatDivider() {
    return Container(
      height: 48.h,
      width: 1,
      color: context.theme.colorScheme.outline.withValues(alpha: 0.2),
    );
  }
}

// Animated score ring widget
class _AnimatedScoreRing extends StatefulWidget {
  final double percentage;
  final Color color;
  final int score;
  final int total;

  const _AnimatedScoreRing({
    required this.percentage,
    required this.color,
    required this.score,
    required this.total,
  });

  @override
  State<_AnimatedScoreRing> createState() => _AnimatedScoreRingState();
}

class _AnimatedScoreRingState extends State<_AnimatedScoreRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1200),
    );
    _animation = Tween<double>(
      begin: 0,
      end: widget.percentage / 100,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return SizedBox(
          width: 160.w,
          height: 160.w,
          child: CustomPaint(
            painter: _RingPainter(
              progress: _animation.value,
              color: widget.color,
              backgroundColor: context.theme.colorScheme.outline.withValues(
                alpha: 0.15,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${(widget.percentage * _animation.value).toStringAsFixed(0)}%',
                    style: context.text.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: widget.color,
                    ),
                  ),
                  Text(
                    '${widget.score}/${widget.total}',
                    style: context.text.bodyMedium?.copyWith(
                      color: context.theme.colorScheme.outline,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color backgroundColor;

  _RingPainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 12.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background ring
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      0,
      2 * pi,
      false,
      Paint()
        ..color = backgroundColor
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    // Progress ring
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * progress,
      false,
      Paint()
        ..color = color
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_RingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
