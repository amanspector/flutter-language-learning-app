import 'package:chatbot_app/core/extensions/localization_extension.dart';
import 'package:chatbot_app/core/widgets/app_circular_progress.dart';
import 'package:chatbot_app/core/widgets/app_customContainer.dart';
import 'package:chatbot_app/core/extensions/theme_extension.dart';
import 'package:chatbot_app/core/widgets/app_container.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:chatbot_app/core/widgets/app_screen.dart';
import 'package:flutter/material.dart';

class LessonReviewScreen extends StatelessWidget {
  final List<Map<String, dynamic>> exercises;
  final int score;
  final int total;

  const LessonReviewScreen({
    super.key,
    required this.exercises,
    required this.score,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.r),
              child: Row(
                children: [
                  AppContainer(
                    borderRadius: 30.r,
                    backgroundColor: context.theme.colorScheme.surface
                        .withValues(alpha: 0.60),
                    widget: IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    context.l10n.lessonReview,
                    style: context.text.headlineMedium,
                  ),
                  Spacer(),
                  AppCircularProgress(score: score, total: total),
                  SizedBox(width: 10.w),
                  // Text("$score/$total", style: context.text.headlineMedium),
                ],
              ),
            ),
          ),

          Divider(indent: 0, endIndent: 0),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(20.r),
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                final ex = exercises[index];
                final isCorrect = ex['is_correct'] ?? false;
                final userAnswer = ex['user_answer'] ?? '';
                final correctAnswer = ex['correct_answer'] ?? '';
                final type = ex['type'] ?? '';

                return Padding(
                  padding: EdgeInsetsGeometry.only(
                    top: index == 0 ? 0.r : 10.r,
                    left: 10.r,
                    right: 10.r,
                    bottom: 10.r,
                  ),
                  child: CustomPaint(
                    painter: TicketPainter(
                      concaveDepth: 12,
                      glowColor: isCorrect
                          ? context.theme.colorScheme.primary
                          : context.theme.colorScheme.error,
                      borderColor: isCorrect
                          ? context.theme.colorScheme.primary
                          : context.theme.colorScheme.error,
                    ),
                    child: AppContainer(
                      borderColor: Colors.transparent,
                      backgroundColor: Colors.transparent,
                      margin: EdgeInsets.only(bottom: 16.r),
                      padding: EdgeInsets.all(16.r),
                      widget: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "${index + 1}. ${ex['question'] ?? ''} ",
                                  style: context.text.bodyMedium,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Icon(
                                isCorrect ? Icons.check_circle : Icons.cancel,
                                color: isCorrect
                                    ? context.theme.colorScheme.primary
                                    : context.theme.colorScheme.error,
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          if (ex['options'] != null &&
                              type != 'sentenceArrangement') ...[
                            ...(ex['options'] as List).map((option) {
                              final isUserAnswer = option == userAnswer;
                              final isCorrectAnswer = option == correctAnswer;
                              Color borderColor = context
                                  .theme
                                  .colorScheme
                                  .outline
                                  .withValues(alpha: 0.20);
                              Color bgColor = Colors.transparent;
                              Widget? trailingIcon;
                              if (isCorrectAnswer) {
                                borderColor = context.theme.colorScheme.primary;
                                bgColor = context.theme.colorScheme.primary
                                    .withValues(alpha: 0.10);
                                trailingIcon = Icon(
                                  Icons.check_circle,
                                  color: context.theme.colorScheme.primary,
                                  size: 18.r,
                                );
                              } else if (isUserAnswer && !isCorrect) {
                                borderColor = context.theme.colorScheme.error;
                                bgColor = context.theme.colorScheme.error
                                    .withValues(alpha: 0.10);
                                trailingIcon = Icon(
                                  Icons.cancel,
                                  color: context.theme.colorScheme.error,
                                  size: 18.r,
                                );
                              }
                              return Container(
                                width: double.infinity,
                                margin: EdgeInsets.only(bottom: 8.r),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.r,
                                  vertical: 12.r,
                                ),
                                decoration: BoxDecoration(
                                  color: bgColor,
                                  borderRadius: BorderRadius.circular(10.r),
                                  border: Border.all(
                                    color: borderColor,
                                    width: 1.5,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        option,
                                        style: context.text.bodyMedium
                                            ?.copyWith(
                                              color: isCorrectAnswer
                                                  ? context
                                                        .theme
                                                        .colorScheme
                                                        .primary
                                                  : isUserAnswer && !isCorrect
                                                  ? context
                                                        .theme
                                                        .colorScheme
                                                        .error
                                                  : context
                                                        .theme
                                                        .colorScheme
                                                        .onSurface,
                                              fontWeight:
                                                  isCorrectAnswer ||
                                                      (isUserAnswer &&
                                                          !isCorrect)
                                                  ? FontWeight.w600
                                                  : FontWeight.normal,
                                            ),
                                      ),
                                    ),
                                    ?trailingIcon,
                                  ],
                                ),
                              );
                            }),
                          ],
                          if (type == 'sentenceArrangement') ...[
                            _buildAnswerRow(
                              context,
                              label: context.l10n.yourAnswer,
                              answer: userAnswer,
                              color: isCorrect
                                  ? context.theme.colorScheme.primary
                                  : context.theme.colorScheme.error,
                            ),
                            if (!isCorrect) ...[
                              SizedBox(height: 8.h),
                              _buildAnswerRow(
                                context,
                                label: context.l10n.correctAnswerText,
                                answer: correctAnswer,
                                color: context.theme.colorScheme.primary,
                              ),
                            ],
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerRow(
    BuildContext context, {
    required String label,
    required String answer,
    required Color color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label: ",
          style: context.text.bodySmall?.copyWith(
            color: context.theme.colorScheme.outline,
          ),
        ),
        Expanded(
          child: Text(
            answer,
            style: context.text.bodyMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
