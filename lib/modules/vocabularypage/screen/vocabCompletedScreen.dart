import 'dart:developer';
import 'package:chatbot_app/core/widgets/app_button.dart';
import 'package:chatbot_app/generated/l10n.dart';
import 'package:chatbot_app/modules/exercisepage/provider/lesson_provider.dart';
import 'package:chatbot_app/modules/vocabularypage/provider/vocab_provider.dart';
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
                    S.of(context).greatJob,
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                ),

                Lottie.asset(
                  fit: BoxFit.contain,
                  'assets/lottie/celebration.json',
                  height: 80.h,
                ),
              ],
            ),
            Text(
              S.of(context).youveCompletedYourVocabularySession,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            SizedBox(height: 20.h),
            CircularPercentIndicator(
              percent: 1,
              animation: true,
              animationDuration: Duration(milliseconds: 1200),
              radius: 60.r,
              lineWidth: 10.w,
              center: Text(
                S.of(context).oneHundredPercent,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              progressColor: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.75),
            ),
            SizedBox(height: 20.h),

            Text(
              S.of(context).readyForExercise,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    buttonFunc: () {
                      context.read<VocabProvider>().restartLearning();
                      Navigator.pop(context);
                    },
                    childWidget: Text(
                      S.of(context).reviewWords,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Theme.of(context).primaryColor,
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
                      lessonProvider.startPractice(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExerciseScreen(),
                        ),
                      );
                      log("Function finished");
                    },
                    childWidget: Text(
                      S.of(context).startExercise,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
