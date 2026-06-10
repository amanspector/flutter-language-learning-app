import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chatbot_app/core/extensions/localization_extension.dart';
import 'package:chatbot_app/core/extensions/theme_extension.dart';
import 'package:chatbot_app/core/widgets/app_button.dart';
import 'package:chatbot_app/core/widgets/app_customContainer.dart';
import 'package:chatbot_app/generated/l10n.dart';
import 'package:chatbot_app/modules/onboarding/provider/onboard_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class Goalselection extends StatelessWidget {
  const Goalselection({super.key});

  @override
  Widget build(BuildContext context) {
    final learningGoals = [
      {
        'code': 'travel',
        'label': S.of(context).travel,
        'subtitle': S.of(context).navigateNewCitiesAndConnectWithLocals,
      },
      {
        'code': 'career',
        'label': S.of(context).career,
        'subtitle': S.of(context).boostYourResumeAndUnlockGlobalOpportunities,
      },
      {
        'code': 'school',
        'label': S.of(context).school,
        'subtitle': S.of(context).excelInYourStudiesAndMasterExams,
      },
    ];

    final onboardProvider = context.watch<OnboardProvider>();
    final goals = learningGoals;
    return SingleChildScrollView(
      physics: ScrollPhysics(),
      child: Padding(
        padding: EdgeInsetsDirectional.all(20.r),
        child: CustomShapeContainter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.r, vertical: 25.r),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 30.h),
                Padding(
                  padding: EdgeInsetsGeometry.symmetric(horizontal: 15),
                  child: AnimatedTextKit(
                    displayFullTextOnTap: true,
                    totalRepeatCount: 1,
                    animatedTexts: [
                      TyperAnimatedText(
                        context.l10n.whyAreYouLearning,
                        speed: Duration(milliseconds: 40),
                        textStyle: context.text.displayMedium?.copyWith(
                          fontSize: 30.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),

                Padding(
                  padding: EdgeInsetsGeometry.symmetric(horizontal: 15),
                  child: Text(
                    // Textconstant.txt_tailoryourexperience,
                    context
                        .l10n
                        .wellTailorYourExperienceToHelpYouReachYourGoalsFaster,
                    style: context.theme.textTheme.bodyLarge,
                  ),
                ),

                if (onboardProvider.error_message != null)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.r),
                    child: Text(
                      onboardProvider.error_message!,
                      style: context.text.headlineSmall?.copyWith(
                        color: context.theme.colorScheme.error,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                SizedBox(height: 10.h),
                ...goals.map((goal) {
                  return Selector<OnboardProvider, String?>(
                    selector: (_, provider) => provider.selectedgoal,
                    builder: (context, selectedGoal, _) {
                      final isSelected = selectedGoal == goal['code'];
                      return Padding(
                        padding: EdgeInsetsDirectional.symmetric(
                          vertical: 10.r,
                        ),
                        child: AppButton(
                          height: 130,
                          buttonFunc: () {
                            context.read<OnboardProvider>().setGoal(
                              goal['code'] as String,
                            );
                          },
                          borderColor: isSelected
                              ? context.theme.colorScheme.onPrimaryContainer
                              : context.theme.colorScheme.outline,
                          buttonColor: isSelected
                              ? context.theme.colorScheme.onPrimaryContainer
                              : context.theme.colorScheme.onSecondary,
                          backgroundColor:
                              context.theme.colorScheme.onSecondary,
                          childWidget: Padding(
                            padding: EdgeInsets.all(20.h),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      goal['label'] as String,
                                      style: context.text.displaySmall
                                          ?.copyWith(
                                            color: isSelected
                                                ? context
                                                      .theme
                                                      .colorScheme
                                                      .onSurface
                                                : context
                                                      .theme
                                                      .colorScheme
                                                      .outline,
                                          ),
                                    ),
                                    Icon(
                                      isSelected
                                          ? Icons.check_circle
                                          : Icons.circle_outlined,
                                      color: isSelected
                                          ? context
                                                .theme
                                                .colorScheme
                                                .onPrimaryContainer
                                          : context.theme.colorScheme.outline,
                                      size: 28,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Expanded(
                                  child: Text(
                                    goal['subtitle'] as String,
                                    style: context.text.labelMedium?.copyWith(
                                      color: isSelected
                                          ? context.theme.colorScheme.onSurface
                                          : context.theme.colorScheme.outline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
