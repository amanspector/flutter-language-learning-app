import 'dart:developer';
import 'package:chatbot_app/core/appconstants/color_constant.dart';
import 'package:chatbot_app/core/extensions/localization_extension.dart';
import 'package:chatbot_app/core/extensions/theme_extension.dart';
import 'package:chatbot_app/core/widgets/app_button.dart';
import 'package:chatbot_app/core/widgets/app_container.dart';
import 'package:chatbot_app/core/widgets/app_loading_screen.dart';
import 'package:chatbot_app/core/widgets/app_navigator.dart';
import 'package:chatbot_app/generated/l10n.dart';
import 'package:chatbot_app/modules/homepage/provider/homescreen_provider.dart';
import 'package:chatbot_app/modules/onboarding/provider/onboard_provider.dart';
import 'package:chatbot_app/modules/onboarding/screen/appLanguageSelection.dart';
import 'package:chatbot_app/modules/onboarding/screen/getStarted.dart';
import 'package:chatbot_app/modules/onboarding/service/firebase_onboarding_service.dart';
import 'package:chatbot_app/modules/splashScreen/screen/ambient_background.dart';
import 'package:chatbot_app/modules/vocabularypage/provider/vocab_provider.dart';
import 'package:chatbot_app/modules/homepage/screen/homescreen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dailyGoal.dart';
import 'experienceLevel.dart';
import 'goalSelection.dart';
import 'languageSelection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainOnboarding extends StatelessWidget {
  const MainOnboarding({super.key});
  @override
  Widget build(BuildContext context) {
    final onboardProvider = context.watch<OnboardProvider>();
    final PageController pagecontroller = PageController();

    final onbordingpages = [
      Applanguageselection(),
      Languageselection(),
      Goalselection(),
      DailygoalScreen(),
      Experiencelevel(),
    ];

    return Scaffold(
      body: AmbientBackground(
        child: Column(
          children: [
            SizedBox(height: 30.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 50.h),
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10.r),
                      child: AppContainer(
                        widget: IconButton(
                          onPressed: () {
                            if (pagecontroller.page != 0) {
                              context.read<OnboardProvider>().setError();

                              pagecontroller.previousPage(
                                duration: Duration(milliseconds: 30),
                                curve: Curves.easeInOut,
                              );
                            } else {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Getstarted(),
                                ),
                              );
                            }
                          },
                          icon: Icon(Icons.arrow_back_rounded),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 20.h),
                      Text(
                        context.l10n.stepProgressFraction(
                          onboardProvider.currentPage + 1,
                          onbordingpages.length,
                        ),
                        // "STEPS ${onboardProvider.currentPage + 1} OF 5",
                        style: context.text.titleMedium,
                      ),
                      SizedBox(height: 10.h),
                      TweenAnimationBuilder(
                        builder: (context, value, child) => Padding(
                          padding: EdgeInsets.only(right: 20.r),
                          child: LinearProgressIndicator(
                            borderRadius: BorderRadius.circular(20.r),
                            value: value,
                            minHeight: 8.r,
                          ),
                        ),
                        tween: Tween(
                          end:
                              (onboardProvider.currentPage + 1) /
                              onbordingpages.length,
                        ),
                        duration: Duration(milliseconds: 300),
                        // child:
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: PageView.builder(
                physics: NeverScrollableScrollPhysics(),
                onPageChanged: onboardProvider.setCurrentPageIndex,
                itemCount: onbordingpages.length,
                itemBuilder: (context, index) {
                  return onbordingpages[index];
                },
                controller: pagecontroller,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: ColorConstant.colorTransparent,
        padding: EdgeInsets.symmetric(horizontal: 15.r, vertical: 15.r),
        child: AppButton(
          buttonFunc: () async {
            onboardProvider.validate(onboardProvider.currentPage);
            if (onboardProvider.error_message != null) return;

            final isLastPage =
                onboardProvider.currentPage == onbordingpages.length - 1;

            if (isLastPage) {
              // ✅ capture everything BEFORE any navigation
              final vocabProvider = context.read<VocabProvider>();
              final homeProvider = context.read<HomescreenProvider>();
              final selectedLang = onboardProvider.selectedlanguage;
              final selectedNative = onboardProvider.selectedNativeLanguage;
              final selectedLevel = onboardProvider.selectedExperienceLevel;
              final selectedGoal = onboardProvider.selectedgoal;
              final selectedDailyGoal = onboardProvider.selectedDailyGoal;
              final loadingMessage = context.l10n.generatingYourVocabulary;

              if (selectedLang == null) return;

              onboardProvider.updateNativeLanguage(selectedNative!);

              // ✅ navigate first
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => AppLoadingScreen(
                    message: loadingMessage,
                    generationFailed: vocabProvider.generationFailed,
                    onRetry: () =>
                        vocabProvider.generateWordsFromAI(onboardProvider),
                  ),
                ),
              );

              try {
                await FirebaseOnboardingService.setprovider(
                  true,
                  selectedLang,
                  selectedNative,
                  selectedLevel!,
                  selectedGoal!,
                  selectedDailyGoal!,
                );
                log("setprovider done");

                await homeProvider.initializeOnce(
                  onboardprovider: onboardProvider,
                  vocabprovider: vocabProvider,
                );
                log("initializeOnce done");

                // ✅ use navigatorKey instead of context
                navigatorKey.currentState?.pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => Homescreen()),
                  (route) => false,
                );
              } catch (e) {
                log("onboarding error: $e");
                navigatorKey.currentState?.pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => MainOnboarding()),
                  (route) => false,
                );
              }
            } else {
              pagecontroller.nextPage(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          },
          childWidget: Text(
            S.of(context).continueText,
            style: context.text.labelMedium,
          ),
        ),
      ),
    );
  }
}
