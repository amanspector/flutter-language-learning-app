import 'dart:developer';
import 'package:chatbot_app/core/appconstants/color_constant.dart';
import 'package:chatbot_app/core/appconstants/text_constant.dart';
import 'package:chatbot_app/core/extensions/app_animation_extension.dart';
import 'package:chatbot_app/core/extensions/daily_goal_extension.dart';
import 'package:chatbot_app/core/extensions/localization_extension.dart';
import 'package:chatbot_app/core/extensions/theme_extension.dart';
import 'package:chatbot_app/core/widgets/app_alertDialog.dart';
import 'package:chatbot_app/core/widgets/app_container.dart';
import 'package:chatbot_app/core/widgets/app_customContainer.dart';
import 'package:chatbot_app/core/widgets/app_screen.dart';
import 'package:chatbot_app/modules/auth/provider/login_screen_provider.dart';
import 'package:chatbot_app/modules/auth/service/firebase_auth_service.dart';
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
      (provider) => provider.gmail ?? context.l10n.notFound,
    );

    String selectedLanguage = context.select<OnboardProvider, String>(
      (provider) => provider.selectedlanguage ?? context.l10n.notFound,
    );

    String selectedDailyGoal = context.select<OnboardProvider, String>(
      (provider) => provider.selectedDailyGoal ?? context.l10n.notFound,
    );

    String? selectedGender = context.select<OnboardProvider, String?>(
      (provider) => provider.gender,
    );
    int selectedAge =
        context.select<OnboardProvider, int?>((provider) => provider.age) ?? 0;

    String appLanguage =
        context.watch<OnboardProvider>().selectedNativeLanguage ??
        context.l10n.notFound;

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
                              style: context.text.bodyLarge,
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

              SizedBox(height: 10.h),

              _buildSectionHeader(
                context,
                context.l10n.preferences,
              ).staggerFadeUp(1),
              SizedBox(height: 10.h),

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
                        title: context.l10n.learningLanguage,
                        subtitle: selectedLanguage,
                        textColor: context.theme.colorScheme.onSurface,
                        onTap: () {},
                      ),
                      Divider(),
                      _buildSettingTile(
                        context,
                        icon: Icons.timer_outlined,
                        title: context.l10n.dailyGoal,
                        subtitle: DailyGoal.fromCode(
                          selectedDailyGoal,
                        ).localizedLabel(context),
                        textColor: context.theme.colorScheme.onSurface,
                        showArrow: true,
                        onTap: () =>
                            _showDailyGoalPicker(context, selectedDailyGoal),
                      ),

                      Divider(),
                      _buildSettingTile(
                        context,
                        icon: Icons.language_rounded,
                        title: context.l10n.appLanguage,
                        subtitle:
                            Textconstant.languageNames[appLanguage] ??
                            'English',
                        textColor: context.theme.colorScheme.onSurface,
                      ),
                    ],
                  ),
                ),
              ).staggerFadeUp(2),

              SizedBox(height: 10.h),
              // ACCOUNT Section
              _buildSectionHeader(
                context,
                context.l10n.account,
              ).staggerFadeUp(3),
              SizedBox(height: 10.h),

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
                        title: context.l10n.personalInformation,
                        subtitle: selectedGender != null
                            ? '$selectedGender, ${selectedAge > 0 ? selectedAge.toString() : context.l10n.notFound}'
                            : context.l10n.notFound,
                        showArrow: true,
                        onTap: () => _showPersonalInformationEditor(
                          context,
                          selectedGender,
                          selectedAge,
                        ),
                      ),
                      Divider(height: 1.h),
                      _buildSettingTile(
                        context,
                        icon: Icons.exit_to_app_rounded,
                        title: context.l10n.logout,
                        subtitle: null,
                        textColor: context.theme.colorScheme.error,
                        iconColor: context.theme.colorScheme.error,
                        showArrow: false,
                        onTap: () {
                          _isLogout(context);
                        },

                        // islogout
                        //     ? null
                        //     : () async {

                        //         context.read<VocabProvider>().reset();
                        //         context.read<OnboardProvider>().reset();
                        //         context.read<LessonProvider>().resetLesson();
                        //         context
                        //             .read<HomescreenProvider>()
                        //             .resetUserState();
                        //         await context
                        //             .read<LoginscreenProvider>()
                        //             .logout(context);
                        //       },
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

  Future<void> _isLogout(BuildContext context) async {
    bool? isexit = await AppAlertdialog.showConfirmationDialog(
      context: context,
      icon: Icons.login_outlined,
      iconColor: context.theme.colorScheme.error,
      title: "${context.l10n.logout}?",
      message: context.l10n.logoutConfirmationTitle,
      cancelText: context.l10n.cancel,
      confirmText: context.l10n.logout,
      confirmBgColor: context.theme.colorScheme.error,
      confirmBorderColor: context.theme.colorScheme.error.withRed(210),
      confirmButtonColor: context.theme.colorScheme.error.withRed(210),
      // confirmTextColor: context.theme.colorScheme.error,
    );

    if (isexit != null) {
      if (isexit) {
        if (!context.mounted) return;
        context.read<VocabProvider>().reset();
        context.read<OnboardProvider>().reset();
        context.read<LessonProvider>().resetLesson();
        context.read<HomescreenProvider>().resetUserState();
        await context.read<LoginscreenProvider>().logout(context);
      }
      if (!isexit) {
        return;
      }
    }
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.r),
      child: Text(title, style: context.text.titleMedium),
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
                color: iconColor ?? context.theme.colorScheme.onSurface,
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
                      Text(subtitle, style: context.text.bodyLarge),
                    ],
                  ],
                ),
              ),
              if (showArrow)
                Icon(
                  Icons.chevron_right,
                  color: context.theme.colorScheme.outline,
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
      backgroundColor: context.theme.colorScheme.surface,
      context: context,
      shape: RoundedRectangleBorder(),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.all(10.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 12.h),
              Text(context.l10n.dailyGoal, style: context.text.bodyMedium),
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
                    style: context.text.bodyMedium,
                  ),
                  trailing: isSelected
                      ? Icon(
                          Icons.check_circle,
                          color: context.theme.colorScheme.primary,
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
                          iconColor: context.theme.colorScheme.primary,
                          title: context.l10n.changeDailyGoalDialogTitle,
                          message: S
                              .of(context)
                              .changeDailyGoalDialogMessage(
                                goal.words.toString(),
                              ),
                          cancelText: context.l10n.cancel,
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

  void _showPersonalInformationEditor(
    BuildContext context,
    String? currentGender,
    int currentAge,
  ) {
    final parentContext = context;
    String email = context.read<LoginscreenProvider>().gmail ?? '';
    String? selectedGender = currentGender;
    int age = currentAge > 0 ? currentAge : 24;
    final emailController = TextEditingController(text: email);

    showModalBottomSheet(
      context: parentContext,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (sheetContext, setState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16.r,
                right: 16.r,
                top: 16.r,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16.r,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      height: 4.h,
                      width: 60.w,
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 18.h),
                  Text(
                    context.l10n.personalInformation,
                    style: context.text.headlineMedium,
                  ),
                  SizedBox(height: 12.h),
                  TextFormField(
                    enabled: false,
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: context.l10n.email,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  DropdownButtonFormField<String>(
                    initialValue: selectedGender,
                    isExpanded: true,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.r,
                        vertical: 14.r,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      labelText: context.l10n.gender,
                    ),
                    items: Textconstant.genders.map((genderEntry) {
                      return DropdownMenuItem(
                        value: genderEntry['label'] as String,
                        child: Text(genderEntry['label'] as String),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedGender = value;
                      });
                    },
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    '${context.l10n.age}: ${age.toString()}',
                    style: context.text.bodyLarge,
                  ),
                  Slider(
                    min: 10,
                    max: 60,
                    divisions: 50,
                    value: age.toDouble(),
                    label: age.toString(),
                    onChanged: (value) {
                      setState(() {
                        age = value.round();
                      });
                    },
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(context.l10n.cancel),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: selectedGender == null
                              ? null
                              : () async {
                                  if (!sheetContext.mounted) return;
                                  final userId = FirebaseAuthService.getuid();

                                  await FirebaseAuthService().updateUserData(
                                    userId,
                                    {'gender': selectedGender, 'age': age},
                                  );

                                  if (!sheetContext.mounted) return;
                                  parentContext
                                      .read<OnboardProvider>()
                                      .setGender(selectedGender!);
                                  parentContext.read<OnboardProvider>().setAge(
                                    age,
                                  );

                                  if (!sheetContext.mounted) return;
                                  Navigator.pop(sheetContext);
                                  ScaffoldMessenger.of(
                                    parentContext,
                                  ).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        '${S.of(parentContext).personalInformation} updated',
                                      ),
                                    ),
                                  );
                                },
                          child: Text(context.l10n.edit),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
