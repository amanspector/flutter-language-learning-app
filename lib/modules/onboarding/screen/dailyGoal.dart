import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chatbot_app/core/extensions/daily_goal_extension.dart';
import 'package:chatbot_app/core/extensions/localization_extension.dart';
import 'package:chatbot_app/core/extensions/theme_extension.dart';
import 'package:chatbot_app/core/widgets/app_button.dart';
import 'package:chatbot_app/core/widgets/app_customContainer.dart';
import 'package:chatbot_app/generated/l10n.dart';
import 'package:chatbot_app/modules/onboarding/provider/onboard_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class DailygoalScreen extends StatelessWidget {
  const DailygoalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final onboardProvider = context.watch<OnboardProvider>();
    final goals = DailyGoal.all;
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsetsDirectional.all(20.r),
        child: CustomShapeContainter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.r, vertical: 25.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 30.h),
                Padding(
                  padding: EdgeInsetsGeometry.symmetric(horizontal: 15.r),
                  child: SizedBox(
                    child: AnimatedTextKit(
                      displayFullTextOnTap: true,
                      totalRepeatCount: 1,
                      animatedTexts: [
                        TyperAnimatedText(
                          context.l10n.setYourDailyGoal,
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
                  padding: EdgeInsetsGeometry.symmetric(horizontal: 15),
                  child: Text(
                    context.l10n.howMuchTimeCanYouDedicate,
                    style: context.text.bodyLarge,
                  ),
                ),

                SizedBox(height: 10.h),
                if (onboardProvider.error_message != null)
                  Padding(
                    padding: EdgeInsetsDirectional.symmetric(vertical: 5.r),
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        context.theme.colorScheme.error,
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

                ...goals.map((goal) {
                  final isSelected =
                      onboardProvider.selectedDailyGoal == goal.code;

                  return Padding(
                    padding: EdgeInsetsDirectional.symmetric(vertical: 10.r),
                    child: AppButton(
                      height: 130,
                      buttonFunc: () => onboardProvider.setDailyGoal(goal.code),
                      borderColor: isSelected
                          ? context.theme.colorScheme.onPrimaryContainer
                          : context.theme.colorScheme.outline,
                      buttonColor: isSelected
                          ? context.theme.colorScheme.onPrimaryContainer
                          : context.theme.colorScheme.onSecondary,
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.onSecondary,
                      childWidget: Padding(
                        padding: EdgeInsets.all(20.r),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  goal.localizedLabel(context),
                                  style: context.text.headlineSmall?.copyWith(
                                    color: isSelected
                                        ? context.theme.colorScheme.onSurface
                                        : context.theme.colorScheme.outline,
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
                              _getGoalDescription(goal.code, context),
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
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getGoalDescription(String code, BuildContext context) {
    switch (code) {
      case 'Casual':
        return S.of(context).fiveMinsPerDay;
      case 'Regular':
        return S.of(context).tenMinsPerDay;
      case 'Serious':
        return S.of(context).fifteenMinsPerDay;
      case 'Intense':
        return S.of(context).twentyMinsPerDay;
      default:
        return '';
    }
  }

  Widget goalSelectionCard({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required Color iconBackgroundColor,
    required String goal,
    required String subtitle,
  }) {
    // final onboard_Provider = context.watch<OnboardProvider>();
    // final isSelected = onboard_Provider.selectedlanguage == language;
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: GestureDetector(
        onTap: () {
          context.read<OnboardProvider>().setGoal(goal);
        },
        child: Container(
          padding: EdgeInsets.all(30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color:
                // ColorConstant.color_blueDark_shade
                //     :
                context.theme.colorScheme.surface.withValues(alpha: 30),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      // color: ColorConstant.color_blueDark_shade,
                      color: iconBackgroundColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    height: 50,
                    width: 50,
                    child: Icon(
                      size: 35,
                      icon,
                      // color: ColorConstant.color_bluelight,
                      color: iconColor,
                    ),
                  ),
                  Radio(value: goal),
                ],
              ),
              SizedBox(height: 20),

              Text(goal, style: context.text.displayMedium),
              SizedBox(height: 10),

              Text(subtitle, style: context.text.headlineMedium),
            ],
          ),
        ),
      ),
    );
  }
}
