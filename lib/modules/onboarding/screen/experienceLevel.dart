import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chatbot_app/core/extensions/theme_extension.dart';
import 'package:chatbot_app/core/widgets/app_button.dart';
import 'package:chatbot_app/core/widgets/app_customContainer.dart';
import 'package:chatbot_app/generated/l10n.dart';
import 'package:chatbot_app/modules/onboarding/provider/onboard_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class Experiencelevel extends StatelessWidget {
  const Experiencelevel({super.key});

  @override
  Widget build(BuildContext context) {
    final experienceLevels = [
      {
        'label': S.of(context).beginner,
        'code': 'Beginner',
        'subtitle': S.of(context).newToThisTopicStartingFromScratch,
      },
      {
        'label': S.of(context).intermediate,
        'code': 'Intermediate',
        'subtitle': S.of(context).comfortableWithBasicsSeekingDeeperMastery,
      },
      {
        'label': S.of(context).advanced,
        'code': 'Advanced',
        'subtitle': S.of(context).expertKnowledgeLookingForAdvancedNuances,
      },
    ];
    final onboardProvider = context.watch<OnboardProvider>();
    final levels = experienceLevels;
    return SingleChildScrollView(
      physics: ScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.all(20.r),
        child: CustomShapeContainter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.r, vertical: 25.r),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 30.h),
                Padding(
                  padding: EdgeInsetsGeometry.symmetric(horizontal: 15.r),
                  child: SizedBox(
                    // height: 82.h,
                    child: AnimatedTextKit(
                      displayFullTextOnTap: true,
                      totalRepeatCount: 1,
                      animatedTexts: [
                        TyperAnimatedText(
                          S.of(context).yourExperienceLevel,
                          speed: Duration(milliseconds: 40),
                          textStyle: context.text.displayMedium?.copyWith(
                            fontSize: 30.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsetsGeometry.symmetric(horizontal: 15.r),
                  child: Text(
                    S
                        .of(context)
                        .thisHelpsUsTailorTheLessonsToYourCurrentKnowledgeAndLearningPace,
                    style: context.text.bodyLarge,
                  ),
                ),

                SizedBox(height: 10.h),

                if (onboardProvider.error_message != null)
                  Padding(
                    padding: EdgeInsetsDirectional.symmetric(
                      horizontal: 15.r,
                      vertical: 5.r,
                    ),
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        Colors.red,
                        BlendMode.srcIn,
                      ),
                      child: Text(
                        onboardProvider.error_message!,
                        style: context.text.headlineSmall?.copyWith(
                          color: context.theme.colorScheme.error,
                        ),
                      ),
                    ),
                  ),

                ...levels.map((level) {
                  final String levelCode = level['code'] as String;

                  return Selector<OnboardProvider, String?>(
                    selector: (_, provider) => provider.selectedExperienceLevel,
                    builder: (context, selectedLevel, _) {
                      final bool isSelected = selectedLevel == levelCode;

                      return Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: AppButton(
                          height: 130,
                          buttonFunc: () {
                            onboardProvider.setExperienceLevel(levelCode);
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
                            padding: EdgeInsets.all(20.r),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      level['label'] as String,
                                      style: context
                                          .theme
                                          .textTheme
                                          .headlineLarge
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
                                    SizedBox(width: 4.w),
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
                                Text(
                                  level['subtitle'] as String,
                                  style: context.text.labelMedium?.copyWith(
                                    color: isSelected
                                        ? context.theme.colorScheme.onSurface
                                        : context.theme.colorScheme.outline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
