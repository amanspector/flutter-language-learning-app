import 'package:chatbot_app/modules/onboarding/provider/onboard_provider.dart';
import 'package:chatbot_app/modules/splashScreen/screen/ambient_background.dart';
import 'package:chatbot_app/modules/exercisepage/provider/lesson_provider.dart';
import 'package:chatbot_app/modules/exercisepage/model/exercise_model.dart';
import 'package:chatbot_app/core/extensions/localization_extension.dart';
import 'package:chatbot_app/core/appconstants/color_constant.dart';
import 'package:chatbot_app/core/widgets/app_customContainer.dart';
import 'package:chatbot_app/core/extensions/theme_extension.dart';
import 'package:chatbot_app/core/widgets/app_alertDialog.dart';
import 'package:chatbot_app/core/extensions/app_animation_extension.dart';
import 'package:chatbot_app/core/widgets/app_container.dart';
import 'package:chatbot_app/modules/vocabularypage/provider/vocab_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:chatbot_app/core/widgets/app_button.dart';
import 'package:chatbot_app/generated/l10n.dart';
import 'package:vibration/vibration.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

class ExerciseScreen extends StatelessWidget {
  const ExerciseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LessonProvider>();
    final exercise = provider.currentExercise;
    return Scaffold(
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          _showExitDialog(context);
        },
        child: AmbientBackground(
          child: Column(
            children: [
              SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 20.w),
                    AppContainer(
                      borderRadius: 30.r,
                      backgroundColor: context.theme.colorScheme.surface
                          .withValues(alpha: 0.60),
                      widget: IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          _showExitDialog(context);
                        },
                      ),
                    ),
                    SizedBox(width: 20.w),
                    Text(
                      context.l10n.questionProgress(
                        provider.currentExerciseIndex + 1,
                        provider.totalExercises,
                      ),
                      style: context.theme.textTheme.displaySmall,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(20.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(20.r),
                        child: AppContainer(
                          backgroundColor: Colors.transparent,
                          widget: CustomPaint(
                            painter: TicketPainter(
                              cornerRadius: 32,
                              concaveDepth: 8,
                            ),
                            child: Container(
                              padding: EdgeInsets.all(24.r),
                              child: exercise?.type == ExerciseType.fillInBlank
                                  ? _buildQuestionWithBlank(
                                      context,
                                      exercise!.question,
                                      provider,
                                    )
                                  : exercise?.type ==
                                        ExerciseType.sentenceArrangement
                                  ? _buildSentenceArrangementExercise(
                                      context,
                                      provider,
                                    )
                                  : exercise?.type ==
                                        ExerciseType.translationMCQ
                                  ? _buildTranslationMCQ(
                                      context,
                                      exercise!,
                                      provider,
                                    )
                                  : SizedBox(),
                            ),
                          ),
                        ),
                      ),
                      if (!provider.isAnswered)
                        Text(
                          context.l10n.dragTheCorrectWordToTheBlankSpace,
                          style: context.theme.textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),

                      SizedBox(height: 20.h),
                      if (!provider.isAnswered)
                        exercise?.type == ExerciseType.fillInBlank
                            ? Wrap(
                                alignment: WrapAlignment.center,
                                spacing: 16,
                                runSpacing: 16,
                                children: exercise!.options.asMap().entries.map(
                                  (entry) {
                                    int index = entry.key;
                                    String option = entry.value;
                                    return _buildDraggableWord(
                                      context,
                                      option,
                                      provider,
                                    ).fadeInSlideUpDelayed(100 + index * 50);
                                  },
                                ).toList(),
                              )
                            : exercise?.type == ExerciseType.sentenceArrangement
                            ? _buildDraggableWordChips(context, provider)
                            : exercise?.type == ExerciseType.translationMCQ
                            ? _buildMCQOptions(context, exercise!, provider)
                            : SizedBox(),
                      if (provider.isAnswered) ...[
                        SizedBox(height: 30.h),
                        if (exercise?.type == ExerciseType.translationMCQ) ...[
                          _buildMCQOptions(context, exercise!, provider),
                          SizedBox(height: 30.h),
                        ],
                        _buildFeedback(context, provider, exercise),
                      ],
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20.r),
                child:
                    provider.isAnswered &&
                        !context.watch<VocabProvider>().isspeaking
                    ? _buildNextButton(context, provider)
                    : SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeedback(
    BuildContext context,
    LessonProvider provider,
    dynamic exercise,
  ) {
    // final String correctWord = exercise.correctAnswer ?? "";

    // 2. Extract the complete, unbroken sentence (without the "_____" blank)
    // final String fullSentence = exercise.questionWithoutBlank ?? "";
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: provider.isCorrect
            ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.40)
            : Theme.of(context).colorScheme.error.withValues(alpha: 0.20),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: provider.isCorrect
              ? Theme.of(context).colorScheme.primary.withGreen(180)
              : Theme.of(context).colorScheme.error.withRed(225),
          width: 2.r,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                provider.isCorrect ? Icons.check_circle : Icons.cancel,
                color: provider.isCorrect
                    ? Theme.of(context).colorScheme.primary.withGreen(180)
                    : Theme.of(context).colorScheme.error.withRed(225),
                size: 32,
              ),
              SizedBox(width: 12.w),
              Text(
                provider.isCorrect
                    ? S.of(context).correct
                    : S.of(context).incorrect,
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: provider.isCorrect
                      ? Theme.of(context).colorScheme.primary.withGreen(180)
                      : Theme.of(context).colorScheme.error.withRed(225),
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          if (exercise.type != ExerciseType.translationMCQ) ...[
            if (exercise.type == ExerciseType.fillInBlank) ...[
              SizedBox(height: 12.h),
              // final feedback = exercise.explanation!.toString().split(":");
              Text(
                "${S.of(context).translation} : ${exercise.nativeTranslation}",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
            SizedBox(height: 12.h),
            Text(
              exercise.explanation!,
              style: Theme.of(context).textTheme.bodyMedium,
              textDirection: context
                  .read<OnboardProvider>()
                  .learningTextDirection,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuestionWithBlank(
    BuildContext context,
    String question,
    LessonProvider provider,
  ) {
    final parts = question.split(RegExp(r'_{3,}'));
    List<Widget> widgets = [];

    for (int i = 0; i < parts.length; i++) {
      widgets.add(
        Text(
          parts[i].trim(),
          style: Theme.of(
            context,
          ).textTheme.displayMedium?.copyWith(fontSize: 24.sp, height: 1.5),
        ).fadeInSlideUp,
      );

      if (i < parts.length - 1) {
        widgets.add(_buildDragTarget(context, provider));
      }
    }

    if (parts.length == 1) {
      widgets.add(SizedBox(width: 10.w));
      widgets.add(_buildDragTarget(context, provider));
    }

    return Directionality(
      textDirection: context.read<OnboardProvider>().learningTextDirection,
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 8,
        runSpacing: 12,
        children: widgets,
      ),
    );
  }

  Widget _buildDraggableWord(
    BuildContext context,
    String word,
    LessonProvider provider,
  ) {
    final isSelected = provider.selectedAnswer == word;

    if (isSelected) {
      return AppContainer(
        widget: Container(
          padding: EdgeInsets.symmetric(horizontal: 24.r, vertical: 14.r),
          decoration: BoxDecoration(
            border: Border.all(color: context.theme.colorScheme.primary),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Text(word, style: context.theme.textTheme.bodySmall),
        ),
      );
    }

    return Draggable<String>(
      data: word,
      maxSimultaneousDrags: 1,
      feedback: Material(
        color: Colors.transparent,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24.r, vertical: 14.r),
          decoration: BoxDecoration(
            color: context.theme.colorScheme.onPrimaryContainer,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: context.theme.colorScheme.shadow,
                blurRadius: 10.r,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Text(
            word,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Theme.of(context).colorScheme.surface,
            ),
          ),
        ),
      ),
      childWhenDragging: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.r, vertical: 14.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: context.theme.colorScheme.outline),
        ),
        child: Text(
          word,
          style: context.theme.textTheme.headlineSmall?.copyWith(
            color: context.theme.colorScheme.outline,
          ),
        ),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.r, vertical: 14.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: context.theme.colorScheme.onSurface),
        ),
        child: Text(word, style: context.theme.textTheme.headlineSmall),
      ),
    );
  }

  Widget _buildDragTarget(BuildContext context, LessonProvider provider) {
    final selectedAnswer = provider.selectedAnswer;
    final isAnswered = provider.isAnswered;
    final isCorrect = provider.isCorrect;

    return DragTarget<String>(
      builder: (context, candidateData, rejectedData) {
        final isHovering = candidateData.isNotEmpty;

        // 1. Default fallback colors
        Color bgColor = context.theme.colorScheme.outline.withValues(
          alpha: 0.25,
        );
        Color borderColor = context.theme.colorScheme.surface.withValues(
          alpha: 0.25,
        );

        // 2. Change color properties dynamically based on state
        if (isAnswered) {
          bgColor = isCorrect
              ? context.theme.colorScheme.primary.withValues(alpha: 0.40)
              : context.theme.colorScheme.error.withValues(alpha: 0.20);
          borderColor = isCorrect
              ? context.theme.colorScheme.secondary
              : context.theme.colorScheme.error.withRed(225);
        } else if (isHovering) {
          bgColor = context.theme.colorScheme.primary.withValues(alpha: 0.20);
          borderColor = context.theme.colorScheme.secondaryContainer;
        } else if (selectedAnswer != null) {
          bgColor = context.theme.colorScheme.onPrimaryContainer;
          borderColor = context.theme.colorScheme.onPrimaryContainer;
        }

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 14.r),
          decoration: BoxDecoration(
            color: bgColor,
            border: Border.all(color: borderColor, width: 2.w),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Text(
            // Always displays what the user dropped in the box
            selectedAnswer ?? "       ",
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: selectedAnswer == null
                  ? context.theme.colorScheme.outline
                  : (isAnswered && !isCorrect
                        ? context.theme.colorScheme.error.withRed(
                            225,
                          ) // Keeps their text red if wrong
                        : context.theme.colorScheme.onSurface),
            ),
          ).fadeInSlideUp,
        );
      },
      onWillAcceptWithDetails: (details) => !isAnswered,
      onAcceptWithDetails: (details) {
        provider.selectAnswer(details.data);
        final vocabpro = context.read<VocabProvider>();
        provider.checkAnswer(vocabpro);
        log("outside condition");

        if (!provider.isCorrect) {
          Vibration.vibrate(pattern: [0, 100, 50, 100]);
        }
      },
    );
  }

  Widget _buildNextButton(BuildContext context, LessonProvider provider) {
    final isLastQuestion =
        provider.currentExerciseIndex >= provider.totalExercises - 1;

    return AppButton(
      buttonFunc: () {
        provider.nextExercise(context);
      },
      childWidget: Text(
        isLastQuestion ? context.l10n.seeResults : context.l10n.nextQuestion,
        style: context.text.labelMedium,
      ),
    );
  }

  Future<void> _showExitDialog(BuildContext context) async {
    bool? isexit = await AppAlertdialog.showConfirmationDialog(
      context: context,
      icon: Icons.exit_to_app,
      iconColor: context.theme.colorScheme.error,
      title: context.l10n.exitLesson,
      message: context.l10n.yourProgressWillBeLostIfYouExitNow,
      cancelText: context.l10n.cancel,
      confirmText: context.l10n.exit,
    );
    if (isexit != null) {
      if (!context.mounted) return;
      if (isexit) {
        context.read<LessonProvider>().resetProgress();
        Navigator.pop(context);
        Navigator.pop(context);
      }
      if (!isexit) {
        return;
      }
    }
  }

  Widget _buildSentenceArrangementArea(
    BuildContext context,
    LessonProvider provider,
  ) {
    final currentExercise = provider.currentExercise!;
    final isAnswered = provider.isAnswered;
    final arrangedWords = provider.arrangedSentence;
    if (arrangedWords.length == currentExercise.options.length &&
        arrangedWords.every((w) => w != null) &&
        !isAnswered) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        provider.checkSentenceArrangement(context);
      });
    }

    return Column(
      children: [
        Directionality(
          textDirection: context.read<OnboardProvider>().learningTextDirection,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(
              currentExercise.options.length,
              (index) => _buildWordDropZone(
                context,
                provider,
                index,
                index < arrangedWords.length ? arrangedWords[index] : null,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWordDropZone(
    BuildContext context,
    LessonProvider provider,
    int index,
    String? currentWord,
  ) {
    final isAnswered = provider.isAnswered;
    final isCorrect = provider.isCorrect;

    return DragTarget<MapEntry<int, String>>(
      builder: (context, candidateData, rejectedData) {
        final isHovering = candidateData.isNotEmpty;

        Color bgColor = context.theme.colorScheme.outline.withValues(
          alpha: 0.10,
        );
        Color borderColor = context.theme.colorScheme.outline;

        if (isAnswered) {
          bgColor = isCorrect
              ? context.theme.colorScheme.primary.withGreen(180)
              // ColorConstant.color_green700
              : context.theme.colorScheme.error.withRed(225);
          // ColorConstant.color_red700;
          borderColor = isCorrect
              ? context.theme.colorScheme.secondary
              : context.theme.colorScheme.error.withRed(225);
        } else if (isHovering) {
          bgColor = context.theme.colorScheme.primary.withValues(alpha: 0.20);
          borderColor = context.theme.colorScheme.secondaryContainer;
        } else if (currentWord != null) {
          bgColor = context.theme.colorScheme.onPrimaryContainer;
          borderColor = context.theme.colorScheme.onPrimaryContainer;
        }

        return GestureDetector(
          onTap: () {
            if (!isAnswered && currentWord != null) {
              provider.removeWordFromSlot(index);
            }
          },
          child: Container(
            constraints: BoxConstraints(minWidth: 80.w),
            padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 12.r),
            decoration: BoxDecoration(
              color: bgColor,
              border: Border.all(color: borderColor, width: 2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              currentWord ?? "       ",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: currentWord == null
                    ? context.theme.colorScheme.outline
                    : context.theme.colorScheme.surface,
              ),
            ),
          ),
        );
      },
      onWillAcceptWithDetails: (details) => !isAnswered && currentWord == null,
      onAcceptWithDetails: (details) {
        provider.placeWordInSlot(index, details.data.key);
      },
    );
  }

  Widget _buildDraggableWordChips(
    BuildContext context,
    LessonProvider provider,
  ) {
    final currentExercise = provider.currentExercise!;
    final isAnswered = provider.isAnswered;
    final placedWords = provider.placedWords;

    log("🔍 Total options: ${currentExercise.options.length}");
    log("🔍 Placed words: ${placedWords.length}");
    log(
      "🔍 Available words: ${currentExercise.options.length - placedWords.length}",
    );

    final availableWidgets = <Widget>[];

    for (int index = 0; index < currentExercise.options.length; index++) {
      if (placedWords.containsKey(index)) {
        log("⏭️ Skipping index $index (already placed)");
        continue;
      }

      final word = currentExercise.options[index];
      log("✅ Adding chip for index $index: '$word'");

      // final shouldAnimate = provider.shouldAnimateIndex(index);
      final shouldAnimate = provider.shouldAnimateWord(word);

      Widget chip = _buildDraggableChipWithIndex(
        context,
        word,
        index,
        isAnswered,
      );

      if (shouldAnimate) {
        chip = chip.fadeInSlideUpDelayed(80 + index * 40);
      }

      availableWidgets.add(chip);
    }

    log("📦 Total chips to show: ${availableWidgets.length}");

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: availableWidgets,
    );
  }

  Widget _buildDraggableChipWithIndex(
    BuildContext context,
    String word,
    int wordIndex,
    bool isAnswered,
  ) {
    return Draggable<MapEntry<int, String>>(
      data: MapEntry(wordIndex, word),
      feedback: Material(
        color: ColorConstant.colorTransparent,
        child: AppContainer(
          widget: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 12.r),
            decoration: BoxDecoration(
              color: context.theme.colorScheme.onPrimaryContainer,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: ColorConstant.colorBlack26,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Text(word, style: context.text.labelMedium),
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: _buildChipContainer(word, isAnswered, context),
      ),
      child: _buildChipContainer(word, isAnswered, context),
    );
  }

  Widget _buildChipContainer(
    String word,
    bool isAnswered,
    BuildContext context,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 12.r),
      decoration: BoxDecoration(
        color: isAnswered
            ? context.theme.colorScheme.outline.withValues(alpha: 30)
            : context.theme.colorScheme.surface.withValues(alpha: 30),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: context.theme.colorScheme.outline,
          width: 1.5,
        ),
      ),
      child: Text(
        word,
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: isAnswered
              ? context.theme.colorScheme.primary
              : context.theme.colorScheme.outline,
        ),
      ),
    );
  }

  Widget _buildSentenceArrangementExercise(
    BuildContext context,
    LessonProvider provider,
  ) {
    return Column(
      children: [
        Text(
          provider.currentExercise!.question,
          style: Theme.of(
            context,
          ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ).fadeInSlideUp,

        SizedBox(height: 30),

        Text(context.l10n.dragWordsHere, style: TextStyle(fontSize: 16.sp)),

        SizedBox(height: 15),
        _buildSentenceArrangementArea(context, provider),
      ],
    );
  }

  Widget _buildTranslationMCQ(
    BuildContext context,
    ExerciseModel exercise,
    LessonProvider provider,
  ) {
    return Column(
      children: [
        Text(
          context.l10n.pickTheCorrectTranslation,
          style: TextStyle(fontSize: 16.sp),
        ),
        SizedBox(height: 16),
        Directionality(
          textDirection: context.read<OnboardProvider>().learningTextDirection,
          child: Text(
            exercise.question, // native sentence
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ).fadeInSlideUp,
        ),
      ],
    );
  }

  Widget _buildMCQOptions(
    BuildContext context,
    ExerciseModel exercise,
    LessonProvider provider,
  ) {
    final bool checkIntroAnimation = provider.shouldAnimateQuestion(
      provider.currentExerciseIndex,
    );

    if (checkIntroAnimation) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        provider.markQuestionAnimated(provider.currentExerciseIndex);
      });
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: exercise.options.asMap().entries.map((entry) {
        final option = entry.value;

        final isSelected = provider.selectedAnswer == option;
        final isAnswered = provider.isAnswered;
        final isCorrect = option == exercise.correctAnswer;
        Color textColor = context.theme.colorScheme.onSurface;
        Color bgColor = ColorConstant.colorTransparent;
        Color borderColor = context.theme.colorScheme.outline.withValues(
          alpha: 0.30,
        );

        if (isAnswered) {
          if (isCorrect) {
            bgColor = context.theme.colorScheme.primary.withValues(alpha: 0.40);
            borderColor = context.theme.colorScheme.secondary;
          } else if (isSelected) {
            bgColor = context.theme.colorScheme.error.withValues(alpha: 0.20);
            borderColor = context.theme.colorScheme.error.withRed(225);
          }
        } else if (isSelected) {
          bgColor = context.theme.colorScheme.onPrimaryContainer;
          borderColor = context.theme.colorScheme.onPrimaryContainer;
        }

        // final shouldAnimate = provider.shouldAnimateWord(option);

        Widget optionWidget = GestureDetector(
          key: ValueKey(
            "${provider.currentExerciseIndex}_${exercise.id}_$option",
          ),
          onTap: () {
            if (!isAnswered) {
              final vocabpro = context.read<VocabProvider>();
              provider.submitAnswer(option, vocabpro);
            }
          },
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.only(bottom: 10.r),
            padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 16.r),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: borderColor, width: 2),
            ),
            child: Text(
              option,
              style: context.text.bodyLarge?.copyWith(color: textColor),
            ),
          ),
        );

        if (isAnswered) {
          if (isCorrect) {
            optionWidget = optionWidget.successFlash;
          } else if (isSelected) {
            optionWidget = optionWidget.errorShake;
          }
        } else if (checkIntroAnimation) {
          optionWidget = optionWidget.fadeInScale;
        }

        return optionWidget;
      }).toList(),
    );
  }
}
