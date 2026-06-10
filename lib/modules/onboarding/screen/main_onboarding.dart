import 'dart:developer';
import 'package:chatbot_app/core/appconstants/color_constant.dart';
import 'package:chatbot_app/core/extensions/localization_extension.dart';
import 'package:chatbot_app/core/widgets/app_button.dart';
import 'package:chatbot_app/core/widgets/app_container.dart';
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
                        style: Theme.of(context).textTheme.titleMedium,
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
              log(onboardProvider.selectedNativeLanguage.toString());
              log(onboardProvider.selectedlanguage.toString());
              log(onboardProvider.selectedExperienceLevel.toString());
              log(onboardProvider.selectedgoal.toString());
              log(onboardProvider.selectedDailyGoal.toString());

              onboardProvider.updateNativeLanguage(
                onboardProvider.selectedNativeLanguage!,
              );

              final uilangauage = onboardProvider.selectedlanguage;
              if (uilangauage == null) {
                return log(
                  "language not found from onboardprovider in main onboarding",
                );
              }

              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => ChangeNotifierProvider.value(
                  value: context.read<VocabProvider>(),
                  child: Consumer<VocabProvider>(
                    builder: (context, vocabProvider, _) {
                      if (vocabProvider.generationFailed) {
                        return Center(
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 30),
                            padding: EdgeInsets.all(20.r),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  S.of(context).generationFailedPleaseRetry,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                SizedBox(height: 20.h),
                                AppButton(
                                  buttonFunc: () async {
                                    await vocabProvider.generateWordsFromAI(
                                      onboardProvider,
                                    );
                                  },
                                  childWidget: Text(S.of(context).retry),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 20.h),
                            Text(
                              S.of(context).generatingYourVocabulary,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ),
              );

              await FirebaseOnboardingService.setprovider(
                true,
                onboardProvider.selectedlanguage!,
                onboardProvider.selectedNativeLanguage!,
                onboardProvider.selectedExperienceLevel!,
                onboardProvider.selectedgoal!,
                onboardProvider.selectedDailyGoal!,
              );

              if (!context.mounted) return;
              final vocabProvider = context.read<VocabProvider>();
              final homeProvider = context.read<HomescreenProvider>();

              await homeProvider.initializeOnce(
                onboardprovider: onboardProvider,
                vocabprovider: vocabProvider,
              );

              log("navigating to home...");
              if (!context.mounted) return;

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => Homescreen()),
                (route) => false,
              );
            } else {
              pagecontroller.nextPage(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          },
          childWidget: Text(
            S.of(context).continueText,
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ),
      ),
    );
  }
}
