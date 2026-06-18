import 'dart:developer';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chatbot_app/core/appconstants/text_constant.dart';
import 'package:chatbot_app/core/extensions/theme_extension.dart';
import 'package:chatbot_app/core/widgets/app_button.dart';
import 'package:chatbot_app/core/widgets/app_customContainer.dart';
import 'package:chatbot_app/modules/onboarding/provider/onboard_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class Applanguageselection extends StatelessWidget {
  const Applanguageselection({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<OnboardProvider>();
    final String? selectedNativeLang = provider.selectedNativeLanguage;
    final languages = Textconstant.languages;
    // .map((e) => eremove(selectedNativeLang))
    // .toList();
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(20.r),
        child: CustomShapeContainter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.r, vertical: 25.r),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30.h),
                Padding(
                  padding: EdgeInsetsGeometry.symmetric(horizontal: 15.r),
                  child: SizedBox(
                    height: 82.h,
                    child: AnimatedTextKit(
                      displayFullTextOnTap: true,
                      totalRepeatCount: 1,
                      animatedTexts: [
                        TyperAnimatedText(
                          Textconstant.whatsYourNativeLanguage,
                          speed: Duration(milliseconds: 40),
                          textStyle: Theme.of(
                            context,
                          ).textTheme.displayMedium?.copyWith(fontSize: 30.sp),
                        ),
                      ],
                    ),
                  ),
                ),

                // SizedBox(height: 30.h),
                // Container(
                //   padding: EdgeInsetsGeometry.symmetric(horizontal: 15.r),
                //   child: Text(
                //     Textconstant.txt_whatsYourNativeLanguage,
                //     style: Theme.of(
                //       context,
                //     ).textTheme.displayMedium?.copyWith(fontSize: 30.sp),
                //   ),
                // ),
                Padding(
                  padding: EdgeInsetsGeometry.symmetric(horizontal: 15.r),
                  child: Text(
                    Textconstant.nativeLanguageSubtitle,
                    style: context.text.bodyLarge,
                  ),
                ),
                SizedBox(height: 10.h),

                ...languages.map(
                  (lang) => Padding(
                    padding: EdgeInsetsDirectional.symmetric(vertical: 10.r),
                    child: AppButton(
                      height: 80,
                      buttonFunc: () {
                        context
                            .read<OnboardProvider>()
                            .setSelectedNativeLanguage(lang['code']!);
                        log(
                          "--------------------------------------native lang selected",
                        );
                      },
                      borderColor: selectedNativeLang == lang['code']
                          ? context.theme.colorScheme.onPrimaryContainer
                          : context.theme.colorScheme.outline,
                      buttonColor: selectedNativeLang == lang['code']
                          ? context.theme.colorScheme.onPrimaryContainer
                          : context.theme.colorScheme.onSecondary,
                      backgroundColor: context.theme.colorScheme.surface,
                      childWidget: Row(
                        children: [
                          SizedBox(width: 20.w),
                          Expanded(
                            child: Text(
                              lang['label']!,
                              style: TextStyle(
                                fontSize: 20.sp,
                                color: selectedNativeLang == lang['code']
                                    ? context.theme.colorScheme.onSurface
                                    : context.theme.colorScheme.outline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (provider.error_message != null)
                  Padding(
                    padding: EdgeInsetsDirectional.symmetric(vertical: 5.r),
                    child: Text(
                      provider.error_message!,
                      style: context.text.headlineSmall?.copyWith(
                        color: context.theme.colorScheme.error,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
