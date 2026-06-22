import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chatbot_app/core/appconstants/text_constant.dart';
import 'package:chatbot_app/core/extensions/localization_extension.dart';
import 'package:chatbot_app/core/extensions/theme_extension.dart';
import 'package:chatbot_app/core/widgets/app_button.dart';
import 'package:chatbot_app/core/widgets/app_customContainer.dart';
import 'package:chatbot_app/modules/onboarding/provider/onboard_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class Languageselection extends StatelessWidget {
  const Languageselection({super.key});

  @override
  Widget build(BuildContext context) {
    final onboardProvider = context.watch<OnboardProvider>();
    final addedLanguageLabels = onboardProvider.myLanguages
        .map((lang) => lang['languageLabel'] as String?)
        .whereType<String>()
        .toSet();

    final languages = Textconstant.learningLanguages
        .where(
          (lang) =>
              lang['code'] != onboardProvider.selectedNativeLanguage &&
              !addedLanguageLabels.contains(lang['label']),
        )
        .toList();
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsetsDirectional.all(20.r),
        child: CustomPaint(
          painter: TicketPainter(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.r, vertical: 25.r),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 30.h),
                Padding(
                  padding: EdgeInsetsGeometry.symmetric(horizontal: 15),
                  child: SizedBox(
                    child: AnimatedTextKit(
                      displayFullTextOnTap: true,
                      totalRepeatCount: 1,
                      animatedTexts: [
                        TyperAnimatedText(
                          context.l10n.whatDoYouWantToLearn,
                          speed: Duration(milliseconds: 40),
                          textStyle: context.text.displayMedium?.copyWith(
                            fontSize: 30.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Padding(
                  padding: EdgeInsetsGeometry.symmetric(horizontal: 15.r),
                  child: Text(
                    context
                        .l10n
                        .chooseALanguageToStartYourJourneyIntoQuietProductivityAndFocusedGrowth,
                    style: context.text.bodyLarge,
                  ),
                ),
                SizedBox(height: 10.h),
                if (onboardProvider.error_message != null) ...[
                  Padding(
                    padding: EdgeInsetsGeometry.symmetric(
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
                ],

                ...languages.map((lang) {
                  return Padding(
                    padding: EdgeInsetsDirectional.symmetric(vertical: 10.r),
                    child: AppButton(
                      height: 80,
                      buttonFunc: () =>
                          onboardProvider.setSelectedLanguage(lang['label']!),
                      borderColor:
                          onboardProvider.selectedlanguage == lang['label']
                          ? context.theme.colorScheme.onPrimaryContainer
                          : context.theme.colorScheme.outline,
                      buttonColor:
                          onboardProvider.selectedlanguage == lang['label']
                          ? context.theme.colorScheme.onPrimaryContainer
                          : context.theme.colorScheme.onSecondary,
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.onSecondary,
                      childWidget: Row(
                        children: [
                          SizedBox(width: 20),
                          CircleAvatar(
                            foregroundImage: AssetImage(lang['img']!),
                            maxRadius: 20,
                          ),
                          SizedBox(width: 16),
                          Text(
                            lang['label']!,
                            style: TextStyle(
                              fontSize: 20,
                              color:
                                  onboardProvider.selectedlanguage ==
                                      lang['label']
                                  ? context.theme.colorScheme.onSurface
                                  : context.theme.colorScheme.outline,
                            ),
                          ),
                        ],
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
}
