import 'dart:ui' show PathMetric;
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
import 'package:chatbot_app/core/services/sound_effect_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:chatbot_app/core/widgets/app_button.dart';
import 'package:vibration/vibration.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class _DragWordData {
  final int wordIndex;
  final int? sourceSlot;
  final String word;

  const _DragWordData({
    required this.wordIndex,
    required this.word,
    this.sourceSlot,
  });
}

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
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            SizedBox(width: 20.w),
                            AppContainer(
                              height: 40.r,
                              width: 40.r,
                              borderRadius: 20.r,
                              backgroundColor: context.theme.colorScheme.surface
                                  .withValues(alpha: 0.60),
                              widget: Center(
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  icon: Icon(Icons.arrow_back, size: 20.r),
                                  onPressed: () {
                                    _showExitDialog(context);
                                  },
                                ),
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: Text(
                                context.l10n.questionProgress(
                                  provider.currentExerciseIndex + 1,
                                  provider.totalExercises,
                                ),
                                style: context.text.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.sp,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          AppContainer(
                            backgroundColor: context.theme.colorScheme.surface
                                .withValues(alpha: 0.60),
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 6.h,
                            ),
                            widget: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.timer_outlined,
                                  size: 18.r,
                                  color: context.theme.colorScheme.onSurface,
                                ),
                                SizedBox(width: 6.w),
                                Text(
                                  provider.formattedTime,
                                  style: context.text.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: context.theme.colorScheme.onSurface,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 20.w),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(20.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildQuestionCard(context, exercise, provider),
                      if (!provider.isAnswered)
                        Text(
                          context.l10n.dragTheCorrectWordToTheBlankSpace,
                          style: context.text.bodyMedium,
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

              if (provider.isAnswered &&
                  !context.watch<VocabProvider>().isspeaking)
                Padding(
                  padding: EdgeInsets.all(20.r),
                  child: _buildNextButton(context, provider),
                  // : SizedBox(),
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
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: provider.isCorrect
            ? context.theme.colorScheme.primary.withValues(alpha: 0.40)
            : context.theme.colorScheme.error.withValues(alpha: 0.20),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: provider.isCorrect
              ? context.theme.colorScheme.primary.withGreen(180)
              : context.theme.colorScheme.error.withRed(225),
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
                    ? context.theme.colorScheme.primary.withGreen(180)
                    : context.theme.colorScheme.error.withRed(225),
                size: 32,
              ),
              SizedBox(width: 12.w),
              Text(
                provider.isCorrect
                    ? context.l10n.correct
                    : context.l10n.incorrect,
                style: context.text.displayMedium?.copyWith(
                  color: provider.isCorrect
                      ? context.theme.colorScheme.primary.withGreen(180)
                      : context.theme.colorScheme.error.withRed(225),
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          if (exercise.type != ExerciseType.translationMCQ) ...[
            if (exercise.type == ExerciseType.fillInBlank) ...[
              SizedBox(height: 10.h),
              // final feedback = exercise.explanation!.toString().split(":");
              Text(
                "${context.l10n.translation} : ${exercise.nativeTranslation}",
                style: context.text.bodyMedium,
              ),
            ],
            SizedBox(height: 12.h),
            Text(
              exercise.explanation!,
              style: context.text.bodyMedium,
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
      return CustomPaint(
        painter: _DashedBorderPainter(
          color: context.theme.colorScheme.outline.withValues(alpha: 0.25),
          borderRadius: 16.r,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24.r, vertical: 14.r),
          child: Text(
            word,
            style: context.text.headlineSmall?.copyWith(
              color: Colors.transparent, // Preserves layout size
            ),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        if (!provider.isAnswered) {
          _onWordSelected(context, word, provider);
        }
      },
      child: Draggable<String>(
        data: word,
        maxSimultaneousDrags: provider.isAnswered ? 0 : 1,
        feedback: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24.r, vertical: 14.r),
            decoration: BoxDecoration(
              color: context.theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: context.theme.colorScheme.shadow.withValues(
                    alpha: 0.2,
                  ),
                  blurRadius: 8.r,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              word,
              style: context.text.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        childWhenDragging: CustomPaint(
          painter: _DashedBorderPainter(
            color: context.theme.colorScheme.outline.withValues(alpha: 0.3),
            borderRadius: 16.r,
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24.r, vertical: 14.r),
            child: Text(
              word,
              style: context.text.headlineSmall?.copyWith(
                color: Colors.transparent,
              ),
            ),
          ),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24.r, vertical: 14.r),
          decoration: BoxDecoration(
            color: context.theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: context.theme.colorScheme.outline.withValues(alpha: 0.2),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: context.theme.colorScheme.outline.withValues(
                  alpha: 0.15,
                ),
                offset: const Offset(0, 4),
                blurRadius: 0,
              ),
            ],
          ),
          child: Text(
            word,
            style: context.text.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
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

        if (selectedAnswer == null) {
          return CustomPaint(
            painter: _DashedBorderPainter(
              color: isHovering
                  ? context.theme.colorScheme.primary
                  : context.theme.colorScheme.outline.withValues(alpha: 0.4),
              borderRadius: 12.r,
              strokeWidth: 2.w,
            ),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24.r, vertical: 12.r),
              color: isHovering
                  ? context.theme.colorScheme.primary.withValues(alpha: 0.1)
                  : Colors.transparent,
              child: Text(
                "       ",
                style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
              ),
            ),
          );
        }

        final Color textCol = isAnswered
            ? (isCorrect
                  ? context.theme.colorScheme.primary.withGreen(180)
                  : context.theme.colorScheme.error.withRed(225))
            : context.theme.colorScheme.onSurface;

        final Color bgCol = isAnswered
            ? (isCorrect
                  ? context.theme.colorScheme.primary.withValues(alpha: 0.40)
                  : context.theme.colorScheme.error.withValues(alpha: 0.20))
            : context.theme.colorScheme.primaryContainer;

        final Color borderCol = isAnswered
            ? (isCorrect
                  ? context.theme.colorScheme.primary.withGreen(180)
                  : context.theme.colorScheme.error.withRed(225))
            : context.theme.colorScheme.primary;

        final IconData? icon = isAnswered
            ? (isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded)
            : null;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutBack,
          padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 12.r),
          decoration: BoxDecoration(
            color: bgCol,
            border: Border.all(color: borderCol, width: 2.w),
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: borderCol.withValues(alpha: 0.15),
                blurRadius: 4.r,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, color: textCol, size: 20.r),
                SizedBox(width: 6.w),
              ],
              Text(
                selectedAnswer,
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: textCol,
                ),
              ),
            ],
          ),
        ).fadeInSlideUp;
      },
      onWillAcceptWithDetails: (details) => !isAnswered,
      onAcceptWithDetails: (details) {
        _onWordSelected(context, details.data, provider);
      },
    );
  }

  Widget _buildNextButton(BuildContext context, LessonProvider provider) {
    final isLastQuestion =
        provider.currentExerciseIndex >= provider.totalExercises - 1;

    return AppButton(
      isLoading: isLastQuestion && provider.isLoading,
      buttonFunc: () {
        final nextIndex = provider.currentExerciseIndex + 1;
        if (nextIndex < provider.exercises.length) {
          final nextExercise = provider.exercises[nextIndex];
          final vocab = context.read<VocabProvider>();

          final textSentence = nextExercise.type == ExerciseType.translationMCQ
              ? nextExercise.question
              : nextExercise
                    .questionWithoutBlank; // covers both fillInBlank and sentenceArrangement
          vocab.preloadText(
            textSentence,
            vocab.currentlanguage!,
            vocab.currentspeaker,
          );
        }
        final onboard = context.read<OnboardProvider>();
        provider.nextExercise(context, onboard.learningLanguageCode);
        // provider.nextExercise(context);
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
        context.read<LessonProvider>().resetLesson();
        Navigator.pop(context);
        Navigator.pop(context);
      }
      if (!isexit) {
        return;
      }
    }
  }

  void _onWordSelected(
    BuildContext context,
    String word,
    LessonProvider provider,
  ) {
    SoundEffectService.playPlace();
    provider.selectAnswer(word);
    final vocabpro = context.read<VocabProvider>();
    final onboard = context.read<OnboardProvider>();
    provider.checkAnswer(vocabpro, onboard.learningLanguageCode);

    if (!provider.isCorrect) {
      Vibration.vibrate(pattern: [0, 100, 50, 100]);
    }
  }

  void _onSentenceWordTap(
    BuildContext context,
    int wordIndex,
    LessonProvider provider,
  ) {
    final arrangedWords = provider.arrangedSentence;
    final emptyIndex = arrangedWords.indexOf(null);
    if (emptyIndex != -1) {
      provider.placeWordInSlot(emptyIndex, wordIndex);
      SoundEffectService.playPlace();
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

    return DragTarget<_DragWordData>(
      builder: (context, candidateData, rejectedData) {
        final isHovering = candidateData.isNotEmpty;

        final Widget slotContent;

        if (currentWord == null) {
          slotContent = CustomPaint(
            key: ValueKey("empty_$index"),
            painter: _DashedBorderPainter(
              color: isHovering
                  ? context.theme.colorScheme.primary
                  : context.theme.colorScheme.outline.withValues(alpha: 0.4),
              borderRadius: 12.r,
              strokeWidth: 2.w,
            ),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 12.r),
              color: isHovering
                  ? context.theme.colorScheme.primary.withValues(alpha: 0.1)
                  : Colors.transparent,
              child: Text(
                "       ",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.transparent,
                ),
              ),
            ),
          );
        } else if (isAnswered) {
          final Color textCol = isCorrect
              ? context.theme.colorScheme.primary.withGreen(180)
              : context.theme.colorScheme.error.withRed(225);
          final Color bgCol = isCorrect
              ? context.theme.colorScheme.primary.withValues(alpha: 0.40)
              : context.theme.colorScheme.error.withValues(alpha: 0.20);
          final Color borderCol = isCorrect
              ? context.theme.colorScheme.primary.withGreen(180)
              : context.theme.colorScheme.error.withRed(225);
          // final IconData icon = isCorrect
          //     ? Icons.check_circle_rounded
          //     : Icons.cancel_rounded;

          slotContent = Container(
            key: ValueKey("answered_${currentWord}_$index"),
            padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 12.r),
            decoration: BoxDecoration(
              color: bgCol,
              border: Border.all(color: borderCol, width: 2.w),
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: borderCol.withValues(alpha: 0.15),
                  blurRadius: 4.r,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon(icon, color: textCol, size: 18.r),
                // SizedBox(width: 6.w),
                Text(
                  currentWord,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: textCol,
                  ),
                ),
              ],
            ),
          );
        } else {
          final Color borderCol = isHovering
              ? context.theme.colorScheme.primary
              : context.theme.colorScheme.outline.withValues(alpha: 0.2);

          final Color bgCol = isHovering
              ? context.theme.colorScheme.primary.withValues(alpha: 0.1)
              : context.theme.colorScheme.surface;

          Widget targetChild = Container(
            padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 12.r),
            decoration: BoxDecoration(
              color: bgCol,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: borderCol, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: context.theme.colorScheme.outline.withValues(
                    alpha: 0.15,
                  ),
                  offset: const Offset(0, 4),
                  blurRadius: 0,
                ),
              ],
            ),
            child: Text(
              currentWord,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: context.theme.colorScheme.onSurface,
              ),
            ),
          );

          final sourceWordIndex = provider.getWordIndexAtSlot(index);
          if (sourceWordIndex != null) {
            targetChild = Draggable<_DragWordData>(
              data: _DragWordData(
                wordIndex: sourceWordIndex,
                word: currentWord,
                sourceSlot: index,
              ),
              maxSimultaneousDrags: isAnswered ? 0 : 1,
              feedback: Material(
                color: Colors.transparent,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.r,
                    vertical: 12.r,
                  ),
                  decoration: BoxDecoration(
                    color: context.theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: context.theme.colorScheme.shadow.withValues(
                          alpha: 0.2,
                        ),
                        blurRadius: 8.r,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    currentWord,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: context.theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ),
              childWhenDragging: CustomPaint(
                painter: _DashedBorderPainter(
                  color: context.theme.colorScheme.outline.withValues(
                    alpha: 0.3,
                  ),
                  borderRadius: 12.r,
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.r,
                    vertical: 12.r,
                  ),
                  child: Text(
                    "       ",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ),
              child: targetChild,
            );
          }

          slotContent = GestureDetector(
            key: ValueKey("filled_${currentWord}_$index"),
            onTap: () {
              if (!isAnswered) {
                provider.removeWordFromSlot(index);
                SoundEffectService.playRemove();
              }
            },
            child: targetChild,
          );
        }

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(
              scale: animation,
              child: FadeTransition(opacity: animation, child: child),
            );
          },
          child: slotContent,
        );
      },
      onWillAcceptWithDetails: (details) =>
          !isAnswered && details.data.sourceSlot != index,
      onAcceptWithDetails: (details) {
        provider.moveWordToSlot(
          index,
          details.data.sourceSlot,
          details.data.wordIndex,
        );
        SoundEffectService.playPlace();
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

    final availableWidgets = <Widget>[];

    for (int index = 0; index < currentExercise.options.length; index++) {
      final word = currentExercise.options[index];
      final isPlaced = placedWords.containsKey(index);
      final shouldAnimate = provider.shouldAnimateWord(word);

      Widget chip = _buildDraggableChipWithIndex(
        context,
        word,
        index,
        isAnswered,
        isPlaced,
      );

      if (shouldAnimate && !isPlaced) {
        chip = chip.fadeInSlideUpDelayed(80 + index * 40);
      }

      availableWidgets.add(chip);
    }

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
    bool isPlaced,
  ) {
    final Widget chipContent = isPlaced
        ? CustomPaint(
            key: ValueKey("placed_${word}_$wordIndex"),
            painter: _DashedBorderPainter(
              color: context.theme.colorScheme.outline.withValues(alpha: 0.25),
              borderRadius: 12.r,
            ),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 12.r),
              child: Text(
                word,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.transparent,
                ),
              ),
            ),
          )
        : GestureDetector(
            key: ValueKey("active_${word}_$wordIndex"),
            onTap: () {
              if (!isAnswered) {
                final provider = context.read<LessonProvider>();
                _onSentenceWordTap(context, wordIndex, provider);
              }
            },
            child: Draggable<_DragWordData>(
              data: _DragWordData(
                wordIndex: wordIndex,
                word: word,
                sourceSlot: null,
              ),
              maxSimultaneousDrags: isAnswered ? 0 : 1,
              feedback: Material(
                color: Colors.transparent,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.r,
                    vertical: 12.r,
                  ),
                  decoration: BoxDecoration(
                    color: context.theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: context.theme.colorScheme.shadow.withValues(
                          alpha: 0.2,
                        ),
                        blurRadius: 8.r,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    word,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: context.theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ),
              childWhenDragging: CustomPaint(
                painter: _DashedBorderPainter(
                  color: context.theme.colorScheme.outline.withValues(
                    alpha: 0.3,
                  ),
                  borderRadius: 12.r,
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.r,
                    vertical: 12.r,
                  ),
                  child: Text(
                    word,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ),
              child: _buildChipContainer(word, isAnswered, context),
            ),
          );

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return ScaleTransition(
          scale: animation,
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      child: chipContent,
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
            ? context.theme.colorScheme.outline.withValues(alpha: 0.12)
            : context.theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: context.theme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: isAnswered
            ? null
            : [
                BoxShadow(
                  color: context.theme.colorScheme.outline.withValues(
                    alpha: 0.15,
                  ),
                  offset: const Offset(0, 4),
                  blurRadius: 0,
                ),
              ],
      ),
      child: Text(
        word,
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: isAnswered
              ? context.theme.colorScheme.primary
              : context.theme.colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildQuestionCard(
    BuildContext context,
    ExerciseModel? exercise,
    LessonProvider provider,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.r),
      child: AppContainer(
        borderColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        widget: CustomPaint(
          painter: TicketPainter(cornerRadius: 32, concaveDepth: 8),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(24.r),
            child: exercise?.type == ExerciseType.fillInBlank
                ? _buildQuestionWithBlank(context, exercise!.question, provider)
                : exercise?.type == ExerciseType.sentenceArrangement
                ? _buildSentenceArrangementExercise(context, provider)
                : exercise?.type == ExerciseType.translationMCQ
                ? _buildTranslationMCQ(context, exercise!, provider)
                : SizedBox(),
          ),
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
              final onboard = context.read<OnboardProvider>();
              provider.submitAnswer(
                option,
                vocabpro,
                onboard.learningLanguageCode,
              );
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

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double borderRadius;

  static const double gap = 4.0;
  static const double dashLength = 6.0;

  _DashedBorderPainter({
    required this.color,
    this.strokeWidth = 1.5,
    this.borderRadius = 16.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        strokeWidth / 2,
        strokeWidth / 2,
        size.width - strokeWidth,
        size.height - strokeWidth,
      ),
      Radius.circular(borderRadius),
    );

    final Path path = Path()..addRRect(rrect);

    final Path dashPath = Path();
    double distance = 0.0;
    for (final PathMetric metric in path.computeMetrics()) {
      while (distance < metric.length) {
        dashPath.addPath(
          metric.extractPath(
            distance,
            (distance + dashLength).clamp(0.0, metric.length),
          ),
          Offset.zero,
        );
        distance += dashLength + gap;
      }
      distance = 0.0; // Reset distance for next metric (sub-paths)
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
