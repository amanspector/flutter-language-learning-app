import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chatbot_app/core/widgets/app_button.dart';
import 'package:chatbot_app/core/widgets/app_customContainer.dart';
import 'package:chatbot_app/generated/l10n.dart';
import 'package:chatbot_app/modules/onboarding/provider/onboard_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class Languageselection extends StatelessWidget {
  const Languageselection({super.key});

  @override
  Widget build(BuildContext context) {
    final learningLanguages = [
      {'code': 'en', 'label': 'English', 'img': 'assets/icon/icon_uk_flag.png'},
      {
        'code': 'hi',
        'label': 'Hindi',
        'img': 'assets/icon/icon_india_flag.png',
      },
      {
        'code': 'gu',
        'label': 'Gujarati',
        'img': 'assets/icon/icon_india_flag.png',
      },
      {'code': 'ar', 'label': 'Arabic', 'img': 'assets/icon/icon_ar_flag.png'},
      {
        'code': 'es',
        'label': 'Spanish',
        'img': 'assets/icon/icon_spain_flag.png',
      },
    ];

    final onboardProvider = context.watch<OnboardProvider>();
    final languages = learningLanguages
        .where((lang) => lang['code'] != onboardProvider.selectedNativeLanguage)
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
                          S.of(context).whatDoYouWantToLearn,
                          speed: Duration(milliseconds: 40),
                          textStyle: Theme.of(
                            context,
                          ).textTheme.displayMedium?.copyWith(fontSize: 30.sp),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Padding(
                  padding: EdgeInsetsGeometry.symmetric(horizontal: 15.r),
                  child: Text(
                    S
                        .of(context)
                        .chooseALanguageToStartYourJourneyIntoQuietProductivityAndFocusedGrowth,
                    style: Theme.of(context).textTheme.bodyLarge,
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
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: Theme.of(context).colorScheme.error,
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
                          ? Theme.of(context).colorScheme.onPrimaryContainer
                          : Theme.of(context).colorScheme.outline,
                      buttonColor:
                          onboardProvider.selectedlanguage == lang['label']
                          ? Theme.of(context).colorScheme.onPrimaryContainer
                          : Theme.of(context).colorScheme.onSecondary,
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
                                  ? Theme.of(context).colorScheme.onSurface
                                  : Theme.of(context).colorScheme.outline,
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
