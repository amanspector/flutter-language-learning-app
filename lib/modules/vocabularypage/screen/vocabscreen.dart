import 'dart:developer';
import 'package:chatbot_app/core/extensions/localization_extension.dart';
import 'package:chatbot_app/core/extensions/theme_extension.dart';
import 'package:chatbot_app/core/extensions/app_animation_extension.dart';
import 'package:chatbot_app/core/widgets/app_button.dart';
import 'package:chatbot_app/core/widgets/app_container.dart';
import 'package:chatbot_app/core/widgets/app_customContainer.dart';
import 'package:chatbot_app/core/widgets/app_loading_screen.dart';
import 'package:chatbot_app/core/widgets/app_screen.dart';
import 'package:chatbot_app/modules/exercisepage/provider/lesson_provider.dart';
import 'package:chatbot_app/modules/onboarding/provider/onboard_provider.dart';
import 'package:chatbot_app/modules/vocabularypage/provider/vocab_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:chatbot_app/modules/vocabularypage/service/tts_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VocabScreen extends StatelessWidget {
  const VocabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final onboardProvider = context.read<OnboardProvider>();
    final provider = context.watch<VocabProvider>();
    final lessonprovider = context.read<LessonProvider>();
    final word = provider.currentWord;
    String speaker = provider.currentspeaker;
    final words = provider.todaywords;

    if (!provider.isloadingAidata && provider.todaywords.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        provider.loadWords(
          uilangauage: onboardProvider.selectedlanguage!,
          ttslangauage: TTSService.getCode(onboardProvider.selectedlanguage!),
          experienceLevel: onboardProvider.selectedExperienceLevel!,
          category: onboardProvider.selectedgoal!,
          // dailygoal: onboardProvider.selectedDailyGoal!,
          onboard: onboardProvider,
        );
      });
    }
    if (words.isNotEmpty && lessonprovider.lessonWords.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        lessonprovider.initWordsFromVocab(words);
      });
    }

    if (provider.isloadingAidata ||
        (provider.generationFailed && provider.todaywords.isEmpty)) {
      return AppLoadingScreen(
        message: context.l10n.generatingYourVocabulary,
        generationFailed: provider.generationFailed,
        onRetry: () => provider.generateWordsFromAI(onboardProvider),
      );
    }

    if (word == null) {
      return AppLoadingScreen();
    }

    final uilanguage = onboardProvider.selectedlanguage;
    if (uilanguage == null) {
      return Center(child: Text(context.l10n.languageNotSelected));
    }

    final language = TTSService.getCode(uilanguage);

    log("CURRENT INDEX: ${provider.currentIndex}");
    log("WORDS LENGTH: ${words.length}");

    final keyWord = "${word.word}-$language-word";
    final currentExample =
        word.exampleForRep(word.srsRepetitions)?.sentence ?? word.example;
    final keyExample = "$currentExample-$language-example";
    final isLastWord = provider.currentIndex == (words.length - 1);
    final isFirstWord = provider.currentIndex == 0;
    return AppScreen(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Flexible(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 20.w),
                AppContainer(
                  borderRadius: 30.r,
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.surface.withValues(alpha: 0.60),
                  widget: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back_outlined),
                  ),
                ).softFocusIn,
                SizedBox(width: 20.w),

                Expanded(
                  child: Text(
                    context.l10n.wordProgressFraction(
                      provider.currentIndex + 1,
                      words.length,
                    ),
                    style: context.text.displaySmall,
                  ).fadeInSlideDown,
                ),
              ],
            ),
          ),

          Flexible(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.r, horizontal: 18.r),
              child:
                  CustomPaint(
                    painter: TicketPainter(
                      borderColor: context.theme.colorScheme.outline.withValues(
                        alpha: 0.10,
                      ),
                      glowColor: context.theme.colorScheme.primary,
                    ),
                    child: Center(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: provider.toggleMeaning,
                        child: Column(
                          // mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Selector<VocabProvider, String?>(
                                  selector: (_, provider) =>
                                      provider.speakingKey,
                                  builder: (context, speakingkey, child) {
                                    return GestureDetector(
                                      onTap: () {
                                        provider.speak(
                                          speaker: speaker,
                                          text: word.word,
                                          language: language,
                                          type: "word",
                                        );
                                      },
                                      child: AppContainer(
                                        backgroundColor: context
                                            .theme
                                            .colorScheme
                                            .primary
                                            .withValues(alpha: 0.15),
                                        height: 64.h,
                                        width: 64.w,
                                        widget: AnimatedSwitcher(
                                          duration: const Duration(
                                            milliseconds: 200,
                                          ),
                                          child: speakingkey == keyWord
                                              ? Center(
                                                  key: ValueKey(
                                                    "loading_$keyWord",
                                                  ),
                                                  child: SizedBox(
                                                    width: 24
                                                        .w, // Adjusted to fit nicely within 64x64
                                                    height: 24.h,
                                                    child:
                                                        CircularProgressIndicator(
                                                          strokeWidth: 2.w,
                                                        ),
                                                  ),
                                                )
                                              : Padding(
                                                  key: ValueKey(
                                                    "icon_$keyWord",
                                                  ),
                                                  padding: EdgeInsets.all(15.r),
                                                  child: SvgPicture.asset(
                                                    'assets/icon/svg/speaker.svg',
                                                  ),
                                                ),
                                        ),
                                      ).shimmerLoading(context),
                                    );
                                  },
                                ),
                                SizedBox(height: 5.h),
                                Text(
                                  word.word,
                                  style: TextStyle(
                                    fontSize: 38.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ).fadeInSlideUp,
                              ],
                            ),

                            Container(
                              padding: EdgeInsets.all(20.r),
                              child: provider.showMeaning
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          word.translationNative,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.headlineSmall,
                                        ).fadeInSlideUp,
                                        SizedBox(height: 10.h),
                                        Directionality(
                                          textDirection: context
                                              .read<OnboardProvider>()
                                              .learningTextDirection,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Flexible(
                                                flex: 4,
                                                child: Text(
                                                  word
                                                          .exampleForRep(
                                                            word.srsRepetitions,
                                                          )
                                                          ?.sentence ??
                                                      word.example,
                                                  style: Theme.of(
                                                    context,
                                                  ).textTheme.headlineSmall,
                                                ).fadeInSlideUp,
                                              ),
                                              SizedBox(width: 10.w),
                                              Flexible(
                                                flex: 1,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    provider.speak(
                                                      speaker: speaker,
                                                      text:
                                                          word
                                                              .exampleForRep(
                                                                word.srsRepetitions,
                                                              )
                                                              ?.sentence ??
                                                          word.example,
                                                      language: language,
                                                      type: "example",
                                                    );
                                                  },
                                                  child: AppContainer(
                                                    backgroundColor: context
                                                        .theme
                                                        .colorScheme
                                                        .primary
                                                        .withValues(
                                                          alpha: 0.15,
                                                        ),
                                                    height: 50.h,
                                                    width: 50.w,
                                                    widget: AnimatedSwitcher(
                                                      duration: const Duration(
                                                        milliseconds: 150,
                                                      ),
                                                      transitionBuilder:
                                                          (child, animation) {
                                                            return FadeTransition(
                                                              opacity:
                                                                  animation,
                                                              child:
                                                                  ScaleTransition(
                                                                    scale:
                                                                        animation,
                                                                    child:
                                                                        child,
                                                                  ),
                                                            );
                                                          },
                                                      child:
                                                          provider.speakingKey ==
                                                              keyExample
                                                          ? Center(
                                                              key: ValueKey(
                                                                "loading_${provider.currentIndex}_$keyWord",
                                                              ),
                                                              child: SizedBox(
                                                                width: 24
                                                                    .w, // Standardized sizing to match your container
                                                                height: 24.h,
                                                                child:
                                                                    CircularProgressIndicator(
                                                                      strokeWidth:
                                                                          2.w,
                                                                    ),
                                                              ),
                                                            )
                                                          : Padding(
                                                              key: ValueKey(
                                                                "icon_${provider.currentIndex}_$keyWord",
                                                              ),
                                                              padding:
                                                                  EdgeInsets.all(
                                                                    15.r,
                                                                  ),
                                                              child: SvgPicture.asset(
                                                                'assets/icon/svg/speaker.svg',
                                                              ),
                                                            ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  : Padding(
                                      padding: EdgeInsets.all(20.r),
                                      child: Text(
                                        context.l10n.tapToRevealMeaning,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.headlineSmall,
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ).vocabCardTransition(
                    transitionKey: provider.currentIndex,
                    isGoingForward: provider.ismovingforward,
                  ),
            ),
          ),

          Flexible(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.r),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: AppButton(
                      buttonColor: isFirstWord
                          ? context.theme.colorScheme.outline
                          : null,
                      borderColor: isFirstWord
                          ? context.theme.colorScheme.outline
                          : null,
                      backgroundColor: context.theme.colorScheme.surface,

                      buttonFunc: () {
                        if (isFirstWord) {
                          log("First word, cannot go back");
                          null;
                        } else {
                          provider.previousWord(speaker);
                        }
                      },
                      childWidget: Text(
                        context.l10n.previousWord,
                        style: context.text.labelMedium?.copyWith(
                          color: isFirstWord
                              ? context.theme.colorScheme.outline
                              : context.theme.primaryColor,
                        ),
                      ),
                    ).fadeInScaleDelayed(300),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: AppButton(
                      buttonFunc: () {
                        provider.nextWord(speaker, context);
                      },
                      childWidget: Text(
                        isLastWord
                            ? context.l10n.finish
                            : context.l10n.nextWord,
                        style: context.text.labelMedium,
                      ),
                    ).fadeInScaleDelayed(300),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
