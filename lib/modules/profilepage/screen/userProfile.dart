import 'dart:developer';
import 'package:chatbot_app/core/appconstants/color_constant.dart';
import 'package:chatbot_app/core/appconstants/text_constant.dart';
import 'package:chatbot_app/core/extensions/app_animation_extension.dart';
import 'package:chatbot_app/core/extensions/daily_goal_extension.dart';
import 'package:chatbot_app/core/widgets/app_alertDialog.dart';
import 'package:chatbot_app/core/widgets/app_container.dart';
import 'package:chatbot_app/core/widgets/app_customContainer.dart';
import 'package:chatbot_app/core/widgets/app_screen.dart';
import 'package:chatbot_app/modules/auth/provider/login_screen_provider.dart';
import 'package:chatbot_app/modules/splashScreen/screen/splashScreen.dart';
import 'package:chatbot_app/generated/l10n.dart';
import 'package:chatbot_app/modules/exercisepage/provider/lesson_provider.dart';
import 'package:chatbot_app/modules/homepage/provider/homescreen_provider.dart';
import 'package:chatbot_app/modules/onboarding/provider/onboard_provider.dart';
import 'package:chatbot_app/modules/vocabularypage/provider/vocab_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class Userprofile extends StatelessWidget {
  const Userprofile({super.key});

  @override
  Widget build(BuildContext context) {
    bool islogout = context.select<LoginscreenProvider, bool>(
      (provider) => provider.islogout,
    );
    String gmail = context.select<LoginscreenProvider, String>(
      (provider) => provider.gmail ?? S.of(context).notFound,
    );

    String selectedLanguage = context.select<OnboardProvider, String>(
      (provider) => provider.selectedlanguage ?? S.of(context).notFound,
    );

    String learninglanguage = context.select<OnboardProvider, String>(
      (provider) => provider.selectedlanguage ?? S.of(context).notFound,
    );

    final learningLanguageCode = Textconstant.learningLanguages.firstWhere(
      (element) => element['label'] == learninglanguage,
      orElse: () => {'code': ''},
    )['code'];

    final languages = Textconstant.languages
        .where((lang) => lang['code'] != learningLanguageCode)
        .toList();
    String selectedDailyGoal = context.select<OnboardProvider, String>(
      (provider) => provider.selectedDailyGoal ?? S.of(context).notFound,
    );

    String appLanguage =
        context.watch<OnboardProvider>().selectedNativeLanguage ??
        S.of(context).notFound;

    return AppScreen(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SafeArea(
                child: AppContainer(
                  borderColor: ColorConstant.colorTransparent,
                  backgroundColor: ColorConstant.colorTransparent,
                  widget: CustomPaint(
                    painter: TicketPainter(concaveDepth: 12),
                    child: Padding(
                      padding: EdgeInsets.all(20.r),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 35.r,
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.secondaryContainer,
                            child: Text(
                              gmail.toUpperCase()[0],
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ).popIn,
                          SizedBox(width: 16.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                gmail.split('@')[0],
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineMedium,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ).staggerFadeUp(0),

              SizedBox(height: 20.h),

              _buildSectionHeader(
                context,
                S.of(context).preferences,
              ).staggerFadeUp(1),
              SizedBox(height: 8.h),

              AppContainer(
                borderColor: ColorConstant.colorTransparent,
                backgroundColor: ColorConstant.colorTransparent,
                widget: CustomPaint(
                  painter: TicketPainter(concaveDepth: 12),
                  child: Column(
                    children: [
                      _buildSettingTile(
                        context,
                        icon: Icons.language_outlined,
                        title: S.of(context).learningLanguage,
                        subtitle: selectedLanguage,
                        textColor: Theme.of(context).colorScheme.onSurface,
                        onTap: () {},
                      ),
                      Divider(),
                      _buildSettingTile(
                        context,
                        icon: Icons.timer_outlined,
                        title: S.of(context).dailyGoal,
                        subtitle: DailyGoal.fromCode(
                          selectedDailyGoal,
                        ).localizedLabel(context),
                        textColor: Theme.of(context).colorScheme.onSurface,
                        showArrow: true,
                        onTap: () =>
                            _showDailyGoalPicker(context, selectedDailyGoal),
                      ),

                      Divider(),
                      _buildSettingTile(
                        context,
                        icon: Icons.language_rounded,
                        title: S.of(context).appLanguage,
                        subtitle:
                            Textconstant.languageNames[appLanguage] ??
                            'English',
                        textColor: Theme.of(context).colorScheme.onSurface,
                        showArrow: true,
                        onTap: () => _showLanguagePicker(
                          context,
                          appLanguage,
                          languages,
                        ),
                      ),
                    ],
                  ),
                ),
              ).staggerFadeUp(2),

              SizedBox(height: 20.h),

              // ACCOUNT Section
              _buildSectionHeader(
                context,
                S.of(context).account,
              ).staggerFadeUp(3),
              SizedBox(height: 8.h),

              AppContainer(
                borderColor: ColorConstant.colorTransparent,
                backgroundColor: ColorConstant.colorTransparent,
                widget: CustomPaint(
                  painter: TicketPainter(concaveDepth: 12),
                  child: Column(
                    children: [
                      _buildSettingTile(
                        context,
                        icon: Icons.person_outline,
                        title: S.of(context).personalInformation,
                        subtitle: null,
                        onTap: () {},
                      ),
                      Divider(height: 1.h),
                      _buildSettingTile(
                        context,
                        icon: Icons.exit_to_app_rounded,
                        title: S.of(context).logout,
                        subtitle: null,
                        textColor: Theme.of(context).colorScheme.error,
                        iconColor: Theme.of(context).colorScheme.error,
                        showArrow: false,
                        onTap: islogout
                            ? null
                            : () async {
                                context.read<VocabProvider>().reset();
                                context.read<OnboardProvider>().reset();
                                context.read<LessonProvider>().resetLesson();
                                context
                                    .read<HomescreenProvider>()
                                    .resetUserState();
                                await context
                                    .read<LoginscreenProvider>()
                                    .logout(context);
                              },
                      ),
                    ],
                  ),
                ),
              ).staggerFadeUp(4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.r),
      child: Text(title, style: Theme.of(context).textTheme.titleMedium),
    );
  }

  Widget _buildSettingTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    Color? textColor,
    Color? iconColor,
    bool showArrow = false,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: EdgeInsets.all(8.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(10.r),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(15.r),
          child: Row(
            children: [
              Icon(
                icon,
                size: 28.sp,
                color: iconColor ?? Theme.of(context).colorScheme.onSurface,
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium?.copyWith(color: textColor),
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: 4.h),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ],
                ),
              ),
              if (showArrow)
                Icon(
                  Icons.chevron_right,
                  color: Theme.of(context).colorScheme.outline,
                  size: 24.sp,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDailyGoalPicker(BuildContext context, String currentGoal) {
    final goals = DailyGoal.all;

    int index = 0;

    showModalBottomSheet(
      backgroundColor: Theme.of(context).colorScheme.surface,
      context: context,
      shape: RoundedRectangleBorder(),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.all(10.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 12.h),
              Text(
                S.of(context).dailyGoal,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 12.h),

              Divider(),
              ...goals.map((goal) {
                final currentIdx = index++;
                final isSelected = goal.code == currentGoal;
                log("Current goal : $currentGoal");
                log("goal code : ${goal.code}");
                return ListTile(
                  title: Text(
                    goal.localizedLabel(context),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  trailing: isSelected
                      ? Icon(
                          Icons.check_circle,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      : null,
                  onTap: () async {
                    if (goal.code == currentGoal) {
                      Navigator.pop(context);
                      return;
                    }

                    Navigator.pop(context);

                    if (!context.mounted) return;

                    final confirmed =
                        await AppAlertdialog.showConfirmationDialog(
                          context: context,
                          icon: Icons.timer_outlined,
                          iconColor: Theme.of(context).colorScheme.primary,
                          title: S.of(context).changeDailyGoalDialogTitle,
                          message: S
                              .of(context)
                              .changeDailyGoalDialogMessage(
                                goal.words.toString(),
                              ),
                          cancelText: S.of(context).cancel,
                          confirmText: S
                              .of(context)
                              .changeLanguageDialogConfirm,
                        );

                    if (confirmed == true && context.mounted) {
                      log("Confirmed condition");
                      log("Current goal : $currentGoal");
                      log("goal code : ${goal.code}");
                      context.read<OnboardProvider>().updateDailygoal(
                        goal.code,
                      );
                      context.read<VocabProvider>().updateDailyLimit(goal.code);

                      context.read<VocabProvider>().reset();

                      context.read<LessonProvider>().resetLesson();
                    }
                  },
                ).staggerFadeLeft(currentIdx, baseDelayMs: 50);
              }),
              SizedBox(height: 16.h),
            ],
          ),
        );
      },
    );
  }

  void _showLanguagePicker(
    BuildContext context,
    String currentLang,
    List<Map<String, String>> languages,
  ) {
    int index = 0;

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.all(10.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 12.h),
              Text(
                S.of(context).selectLanguage,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 12.h),
              Divider(),
              ...languages.map((lang) {
                final currentIdx = index++;
                final isSelected = lang['code'] == currentLang;
                return ListTile(
                  title: Text(
                    lang['label']!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  trailing: isSelected
                      ? Icon(
                          Icons.check_circle,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      : null,
                  onTap: () async {
                    if (lang['code'] == currentLang) {
                      Navigator.pop(context);
                      return;
                    }

                    Navigator.pop(context);

                    final confirmed =
                        await AppAlertdialog.showConfirmationDialog(
                          context: context,
                          icon: Icons.warning_amber_rounded,
                          iconColor: Theme.of(
                            context,
                          ).colorScheme.onPrimaryFixed,
                          title: S.of(context).changeLanguageDialogTitle,
                          message: S.of(context).changeLanguageDialogMessage,
                          cancelText: S.of(context).changeLanguageDialogCancel,
                          confirmText: S
                              .of(context)
                              .changeLanguageDialogConfirm,
                        );

                    if (confirmed == true && context.mounted) {
                      await context
                          .read<VocabProvider>()
                          .clearVocabDataOnLanguageChange();
                      if (!context.mounted) return;

                      context.read<LessonProvider>().resetLesson();
                      context.read<OnboardProvider>().setSelectedNativeLanguage(
                        lang['code']!,
                      );

                      await context
                          .read<OnboardProvider>()
                          .updateNativeLanguage(lang['code']!);

                      if (!context.mounted) return;

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => Splashscreen()),
                      );
                    }
                  },
                ).staggerFadeLeft(currentIdx, baseDelayMs: 50);
              }),
              SizedBox(height: 16.h),
            ],
          ),
        );
      },
    );
  }
}
