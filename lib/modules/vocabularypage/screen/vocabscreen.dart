import 'dart:developer';
import 'package:chatbot_app/core/appconstants/color_constant.dart';
import 'package:chatbot_app/core/extensions/theme_extension.dart';
import 'package:chatbot_app/core/widgets/app_button.dart';
import 'package:chatbot_app/core/widgets/app_container.dart';
import 'package:chatbot_app/core/widgets/app_customContainer.dart';
import 'package:chatbot_app/generated/l10n.dart';
import 'package:chatbot_app/modules/exercisepage/provider/lesson_provider.dart';
import 'package:chatbot_app/modules/onboarding/provider/onboard_provider.dart';
import 'package:chatbot_app/modules/splashScreen/screen/ambient_background.dart';
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

    if (provider.generationFailed) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                S.of(context).generationFailedPleaseRetry,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 20.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.r),
                child: AppButton(
                  buttonFunc: () =>
                      provider.generateWordsFromAI(onboardProvider),
                  childWidget: Text(
                    S.of(context).retry,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (provider.isloadingAidata && provider.todaywords.isEmpty) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              SizedBox(height: 20.h),
              Text(
                S.of(context).generatingYourVocabulary,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      );
    }
    if (word == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              SizedBox(height: 20.h),
              Text(
                S.of(context).generatingYourVocabulary,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      );
    }

    final uilanguage = onboardProvider.selectedlanguage;
    if (uilanguage == null) {
      return Center(child: Text(S.of(context).languageNotSelected));
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
    return Scaffold(
      body: AmbientBackground(
        child: Column(
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
                  ),
                  SizedBox(width: 20.w),

                  Expanded(
                    child: Text(
                      S
                          .of(context)
                          .wordProgressFraction(
                            provider.currentIndex + 1,
                            words.length,
                          ),
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                  ),
                ],
              ),
            ),

            Flexible(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.r, horizontal: 18.r),
                child: CustomPaint(
                  painter: TicketPainter(
                    borderColor: context.theme.colorScheme.outline.withValues(
                      alpha: 0.10,
                    ),
                    glowColor: context.theme.colorScheme.primary,
                    concaveDepth: 10,
                    cornerRadius: 50,
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
                                selector: (_, provider) => provider.speakingKey,
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
                                      backgroundColor: Theme.of(context)
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
                                                key: ValueKey("icon_$keyWord"),
                                                padding: EdgeInsets.all(15.r),
                                                child: SvgPicture.asset(
                                                  'assets/icon/svg/speaker.svg',
                                                ),
                                              ),
                                      ),
                                    ),
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
                              ),
                            ],
                          ),

                          Container(
                            padding: EdgeInsets.all(20.r),
                            child: provider.showMeaning
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        word.translationNative,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.headlineSmall,
                                      ),
                                      SizedBox(height: 10.h),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            word
                                                    .exampleForRep(
                                                      word.srsRepetitions,
                                                    )
                                                    ?.sentence ??
                                                word.example,
                                            style: Theme.of(
                                              context,
                                            ).textTheme.headlineSmall,
                                          ),
                                          SizedBox(width: 10.w),
                                          Flexible(
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
                                                backgroundColor:
                                                    Theme.of(context)
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
                                                          opacity: animation,
                                                          child:
                                                              ScaleTransition(
                                                                scale:
                                                                    animation,
                                                                child: child,
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
                                    ],
                                  )
                                : Padding(
                                    padding: EdgeInsets.all(20.r),
                                    child: Text(
                                      S.of(context).tapToRevealMeaning,
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
                        backgroundColor: Theme.of(context).colorScheme.surface,

                        buttonFunc: () {
                          if (isFirstWord) {
                            log("First word, cannot go back");
                            null;
                          } else {
                            provider.previousWord(speaker);
                          }
                        },
                        childWidget: Text(
                          S.of(context).previousWord,
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(
                                color: isFirstWord
                                    ? context.theme.colorScheme.outline
                                    : Theme.of(context).primaryColor,
                              ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: AppButton(
                        buttonFunc: () {
                          provider.nextWord(speaker, context);
                        },
                        childWidget: Text(
                          isLastWord
                              ? S.of(context).finish
                              : S.of(context).nextWord,
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
