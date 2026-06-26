import 'dart:developer';
import 'package:chatbot_app/core/extensions/localization_extension.dart';
import 'package:chatbot_app/core/extensions/theme_extension.dart';
import 'package:chatbot_app/core/extensions/app_animation_extension.dart';
import 'package:chatbot_app/core/widgets/app_button.dart';
import 'package:chatbot_app/modules/exercisepage/provider/lesson_provider.dart';
import 'package:chatbot_app/modules/vocabularypage/provider/vocab_provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import '../../exercisepage/screen/excerisescreen.dart';
import 'package:flutter/material.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:provider/provider.dart';

class Vocabcompletedscreen extends StatelessWidget {
  const Vocabcompletedscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 48.h,
          horizontal: 16.w,
        ), // Gives internal breathing room
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 20.r, right: 5.r),
                  child: Text(
                    context.l10n.greatJob,
                    style: context.text.displayMedium,
                  ),
                ),

                Lottie.asset(
                  fit: BoxFit.contain,
                  'assets/lottie/celebration.json',
                  height: 80.h,
                ).fadeInScale,
              ],
            ).fadeInSlideUp,
            Text(
              context.l10n.youveCompletedYourVocabularySession,
              textAlign: TextAlign.center,
              style: context.text.titleMedium?.copyWith(
                color: context.theme.colorScheme.outline,
              ),
            ).fadeInSlideUpDelayed(150),
            SizedBox(height: 20.h),
            CircularPercentIndicator(
              percent: 1,
              animation: true,
              animationDuration: Duration(milliseconds: 1200),
              radius: 60.r,
              lineWidth: 10.w,
              center: Text(
                context.l10n.oneHundredPercent,
                style: context.text.titleMedium,
              ),
              progressColor: context.theme.colorScheme.primary.withValues(
                alpha: 0.75,
              ),
            ).fadeInScaleDelayed(300),
            SizedBox(height: 20.h),

            Text(
              context.l10n.readyForExercise,
              style: context.text.headlineLarge,
            ).fadeInSlideUpDelayed(450),
            SizedBox(height: 20.h),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    backgroundColor: context.theme.colorScheme.surface,
                    buttonFunc: () {
                      context.read<VocabProvider>().restartLearning();
                      Navigator.pop(context);
                    },
                    childWidget: Text(
                      context.l10n.reviewWords,
                      style: context.text.labelMedium?.copyWith(
                        color: context.theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: AppButton(
                    buttonFunc: () {
                      log("Button clicked");
                      final lessonProvider = context.read<LessonProvider>();
                      lessonProvider.startPractice();
                      Future.delayed(200.ms, () {
                        if (!context.mounted) return;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ExerciseScreen(),
                          ),
                        );
                      });
                      log("Function finished");
                    },
                    childWidget: Text(
                      context.l10n.startExercise,
                      style: context.text.labelMedium,
                    ),
                  ),
                ),
              ],
            ).fadeInScaleDelayed(600),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
