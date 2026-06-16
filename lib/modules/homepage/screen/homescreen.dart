import 'package:chatbot_app/core/appconstants/color_constant.dart';
import 'package:chatbot_app/core/extensions/daily_goal_extension.dart';
import 'package:chatbot_app/core/extensions/localization_extension.dart';
import 'package:chatbot_app/core/extensions/theme_extension.dart';
import 'package:chatbot_app/core/extensions/app_animation_extension.dart';
import 'package:chatbot_app/core/widgets/app_button.dart';
import 'package:chatbot_app/core/widgets/app_container.dart';
import 'package:chatbot_app/core/widgets/app_customContainer.dart';
import 'package:chatbot_app/core/widgets/app_custom_navbar.dart';
import 'package:chatbot_app/core/widgets/app_screen.dart';
import 'package:chatbot_app/generated/l10n.dart';
import 'package:chatbot_app/modules/homepage/provider/homescreen_provider.dart';
import 'package:chatbot_app/modules/chatbotpage/screen/chathistory.dart';
import 'package:chatbot_app/modules/onboarding/provider/onboard_provider.dart';
import 'package:chatbot_app/modules/profilepage/screen/userProfile.dart';
import 'package:chatbot_app/modules/vocabularypage/screen/vocabscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class Homescreen extends StatelessWidget {
  Homescreen({super.key});
  FocusNode focus = FocusNode();

  @override
  Widget build(BuildContext context) {
    int selectedindex = context.select<HomescreenProvider, int>(
      (provider) => provider.seletectedIndex,
    );

    return AppScreen(
      body: BottomBar(
        theme: BottomBarThemeData(
          iconHeight: 90,
          iconWidth: 45,
          iconDecoration: BoxDecoration(
            shape: BoxShape.circle,

            color: context.theme.colorScheme.onPrimaryContainer.withValues(
              alpha: 30,
            ),
          ),

          barDecoration: BoxDecoration(color: ColorConstant.colorTransparent),
        ),
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: context.watch<HomescreenProvider>().pageController,
          // index: selectedindex,
          children: [homeScreenPage(context), Chathistory(), Userprofile()],
        ),
        child: CustomNavBar(
          selectedIndex: selectedindex,
          onTap: (value) {
            context.read<HomescreenProvider>().bottomNavBarIndex(value);
          },
        ).slideInFromBottom,
      ),
    );
  }

  Widget homeScreenPage(BuildContext context) {
    int defaultvalue = 0;
    int currentStreak = context.select<HomescreenProvider, int>(
      (provider) => provider.currentStreak,
    );

    int xpPoints = context.select<HomescreenProvider, int>(
      (provider) => provider.totalXP,
    );

    int dailylimit = context.select<OnboardProvider, int>(
      (provider) => DailyGoal.getMaxWordsForGoal(provider.selectedDailyGoal),
    );
    String selectedLanguage = context.select<OnboardProvider, String>(
      (provider) => provider.selectedlanguage ?? S.of(context).notFound,
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.r),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 80.h,
                  child: Image.asset('assets/icon/appicon_1.png'),
                ).fadeInScale,

                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.welcomeBack,
                        style: context.theme.textTheme.headlineLarge,
                      ),
                      SizedBox(height: 5.h),

                      Text(
                        context.l10n.youreMakingExcellentProgress,
                        style: context.text.bodySmall,
                      ),
                    ],
                  ).fadeInSlideUp,
                ),

                AppContainer(
                  borderRadius: 30.r,
                  borderColor: context.theme.colorScheme.outline.withValues(
                    alpha: 0.5,
                  ),
                  widget: Padding(
                    padding: EdgeInsets.all(10.r),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 20.h,
                          child: SvgPicture.asset('assets/icon/svg/fire.svg'),
                        ),
                        SizedBox(width: 5.r),
                        Text(
                          currentStreak == 0
                              ? defaultvalue.toString()
                              : currentStreak.toString(),
                          overflow: TextOverflow.clip,
                          style: context.theme.textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ).staggerPopIn(1),
              ],
            ),
          ),
        ),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.r),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              customContainer(
                context,
                'assets/icon/svg/fire.svg',
                context.l10n.currentStreak,
                currentStreak == 0
                    ? defaultvalue.toString()
                    : context.l10n.streakDays(currentStreak),
              ).staggerPopIn(0),

              SizedBox(width: 18.w),
              customContainer(
                context,
                'assets/icon/svg/star.svg',
                context.l10n.currentPoints,
                xpPoints == 0
                    ? defaultvalue.toString()
                    : context.l10n.xpPointsValue(xpPoints),
              ).staggerPopIn(1),
            ],
          ),
        ),
        SizedBox(height: 10.h),

        Padding(
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
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.r, vertical: 70.r),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AppContainer(
                    backgroundColor: context.theme.colorScheme.primary
                        .withValues(alpha: 0.25),
                    height: 64.h,
                    width: 64.w,
                    widget: Icon(Icons.school_outlined, size: 33).fadeInScale,
                  ),
                  SizedBox(height: 10.h),

                  Text(
                    context.l10n.readyForToday,
                    style: context.text.displaySmall,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    context.l10n.masterNewPhrases(
                      dailylimit.toString(),
                      selectedLanguage,
                    ),
                    style: context.text.bodyLarge,
                    textAlign: TextAlign.center,
                  ).fadeInSlideUpDelayed(200),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 15.r),
                    child: AppButton(
                      width: MediaQuery.widthOf(context) * 0.9,
                      buttonFunc: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VocabScreen(),
                          ),
                        );
                      },
                      childWidget: Text(
                        context.l10n.startLesson,
                        style: context.theme.textTheme.labelLarge,
                      ),
                    ).fadeInScaleDelayed(400),
                  ),
                ],
              ),
            ),
          ),
        ).softFocusIn,
      ],
    );
  }

  Widget customContainer(
    BuildContext context,
    String svgAsset,
    String labelString,
    String countString,
  ) {
    return Expanded(
      child: CustomPaint(
        painter: TicketPainter(cornerRadius: 30, concaveDepth: 3),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 30.r),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppContainer(widget: SvgPicture.asset(svgAsset, height: 40.h)),
              SizedBox(height: 10.h),
              Text(
                labelString,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
              SizedBox(height: 10.h),

              Padding(
                padding: EdgeInsets.only(left: 5.r),
                child: Text(
                  countString,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
