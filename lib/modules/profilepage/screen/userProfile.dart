import 'package:chatbot_app/modules/vocabularypage/provider/vocab_provider.dart';
import 'package:chatbot_app/modules/homepage/provider/homescreen_provider.dart';
import 'package:chatbot_app/modules/exercisepage/provider/lesson_provider.dart';
import 'package:chatbot_app/modules/onboarding/provider/onboard_provider.dart';
import 'package:chatbot_app/modules/auth/provider/login_screen_provider.dart';
import 'package:chatbot_app/modules/auth/service/firebase_auth_service.dart';
import 'package:chatbot_app/modules/onboarding/screen/main_onboarding.dart';
import 'package:chatbot_app/modules/profilepage/provider/user_profile_provider.dart';
import 'package:chatbot_app/core/widgets/app_selection_bottom_sheet.dart';
import 'package:chatbot_app/core/extensions/app_animation_extension.dart';
import 'package:chatbot_app/core/extensions/localization_extension.dart';
import 'package:chatbot_app/core/extensions/daily_goal_extension.dart';
import 'package:chatbot_app/core/appconstants/color_constant.dart';
import 'package:chatbot_app/core/widgets/app_customContainer.dart';
import 'package:chatbot_app/core/appconstants/text_constant.dart';
import 'package:chatbot_app/core/extensions/theme_extension.dart';
import 'package:chatbot_app/core/widgets/app_alertDialog.dart';
import 'package:chatbot_app/core/widgets/app_container.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:chatbot_app/core/widgets/app_screen.dart';
import 'package:chatbot_app/generated/l10n.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

class Userprofile extends StatelessWidget {
  const Userprofile({super.key});

  @override
  Widget build(BuildContext context) {
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
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Beautiful User Header
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 15.h),
                  child: CustomPaint(
                    painter: TicketPainter(
                      concaveDepth: 8,
                      cornerRadius: 24,
                      color: context.colors.surface,
                      borderColor: context.colors.outline.withValues(
                        alpha: 0.15,
                      ),
                    ),
                    child: AppContainer(
                      backgroundColor: ColorConstant.colorTransparent,
                      borderColor: ColorConstant.colorTransparent,
                      widget: Padding(
                        padding: EdgeInsets.all(20.r),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 36.r,
                              backgroundColor: context.colors.primary,
                              child: CircleAvatar(
                                radius: 33.r,
                                backgroundColor: context.colors.surface,
                                child: Text(
                                  gmail.toUpperCase()[0],
                                  style: context.text.displaySmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: context.colors.primary,
                                  ),
                                ),
                              ),
                            ).popIn,
                            SizedBox(width: 18.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    gmail.split('@')[0],
                                    style: context.text.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: context.colors.onSurface,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    gmail,
                                    style: context.text.bodySmall?.copyWith(
                                      color: context.colors.onSurfaceVariant
                                          .withValues(alpha: 0.7),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ).staggerFadeUp(0),

              // PREFERENCES Section
              _buildSectionHeader(
                context,
                context.l10n.preferences,
              ).staggerFadeUp(1),
              SizedBox(height: 8.h),

              CustomPaint(
                painter: TicketPainter(
                  concaveDepth: 8,
                  cornerRadius: 24,
                  color: context.colors.surface,
                  borderColor: context.colors.outline.withValues(alpha: 0.15),
                ),
                child: AppContainer(
                  backgroundColor: ColorConstant.colorTransparent,
                  borderColor: ColorConstant.colorTransparent,
                  widget: Column(
                    children: [
                      _buildSettingTile(
                        context,
                        icon: Icons.language_outlined,
                        iconColor: Colors.blue,
                        iconBgColor: Colors.blue.withValues(alpha: 0.12),
                        title: context.l10n.learningLanguage,
                        subtitle: selectedLanguage,
                        textColor: context.theme.colorScheme.onSurface,
                        showArrow: true,
                        onTap: () => _showLanguagePicker(context),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Divider(
                          color: context.colors.outline.withValues(alpha: 0.15),
                        ),
                      ),
                      _buildSettingTile(
                        context,
                        icon: Icons.timer_outlined,
                        iconColor: Colors.orange,
                        iconBgColor: Colors.orange.withValues(alpha: 0.12),
                        title: context.l10n.dailyGoal,
                        subtitle: DailyGoal.fromCode(
                          selectedDailyGoal,
                        ).localizedLabel(context),
                        textColor: context.theme.colorScheme.onSurface,
                        showArrow: true,
                        onTap: () =>
                            _showDailyGoalPicker(context, selectedDailyGoal),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Divider(
                          color: context.colors.outline.withValues(alpha: 0.15),
                        ),
                      ),
                      _buildSettingTile(
                        context,
                        icon: Icons.translate_rounded,
                        iconColor: Colors.teal,
                        iconBgColor: Colors.teal.withValues(alpha: 0.12),
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

              SizedBox(height: 20.h),

              // ACCOUNT Section
              _buildSectionHeader(
                context,
                context.l10n.account,
              ).staggerFadeUp(3),
              SizedBox(height: 8.h),

              CustomPaint(
                painter: TicketPainter(
                  concaveDepth: 8,
                  cornerRadius: 24,
                  color: context.colors.surface,
                  borderColor: context.colors.outline.withValues(alpha: 0.15),
                ),
                child: AppContainer(
                  backgroundColor: ColorConstant.colorTransparent,
                  borderColor: ColorConstant.colorTransparent,
                  widget: Column(
                    children: [
                      _buildSettingTile(
                        context,
                        icon: Icons.person_outline_rounded,
                        iconColor: Colors.purple,
                        iconBgColor: Colors.purple.withValues(alpha: 0.12),
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
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Divider(
                          color: context.colors.outline.withValues(alpha: 0.15),
                        ),
                      ),
                      _buildSettingTile(
                        context,
                        icon: Icons.exit_to_app_rounded,
                        iconColor: context.theme.colorScheme.error,
                        iconBgColor: context.theme.colorScheme.error.withValues(
                          alpha: 0.12,
                        ),
                        title: context.l10n.logout,
                        textColor: context.theme.colorScheme.error,
                        showArrow: false,
                        onTap: () {
                          _isLogout(context);
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

  static const _flagMap = {
    'en': '🇬🇧',
    'es': '🇪🇸',
    'hi': '🇮🇳',
    'gu': '🇮🇳',
    'ar': '🇸🇦',
    'fr': '🇫🇷',
    'de': '🇩🇪',
    'ja': '🇯🇵',
    'zh': '🇨🇳',
    'pt': '🇧🇷',
    'it': '🇮🇹',
    'ko': '🇰🇷',
    'ru': '🇷🇺',
    'tr': '🇹🇷',
  };

  void _showLanguagePicker(BuildContext context) {
    final onboard = context.read<OnboardProvider>();
    final scheme = context.theme.colorScheme;

    AppSelectionBottomSheet.show<Map<String, dynamic>>(
      context: context,
      title: 'Learning Languages',
      subtitle:
          '${onboard.myLanguages.length} language${onboard.myLanguages.length == 1 ? '' : 's'} added',
      items: List<Map<String, dynamic>>.from(onboard.myLanguages),
      isSelected: (lang) => lang['code'] == onboard.activeLanguageCode,
      leadingBuilder: (context, lang, isActive) {
        final flag = _flagMap[lang['code'] as String? ?? ''] ?? '🌐';
        return Container(
          width: 46.r,
          height: 46.r,
          decoration: BoxDecoration(
            color: isActive
                ? scheme.primary.withValues(alpha: 0.12)
                : scheme.onSurface.withValues(alpha: 0.06),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(flag, style: TextStyle(fontSize: 22.sp)),
          ),
        );
      },
      titleBuilder: (context, lang) => lang['languageLabel'] ?? '',
      subtitleBuilder: (context, lang) {
        final level = lang['level'] as String? ?? '';
        final category = lang['category'] as String? ?? '';
        if (level.isEmpty && category.isEmpty) return null;
        return [
          if (level.isNotEmpty) level,
          if (category.isNotEmpty) category,
        ].join(' · ');
      },
      activeBadgeText: 'Active',
      onItemTap: (sheetContext, lang) async {
        Navigator.pop(sheetContext);
        if (lang['code'] == onboard.activeLanguageCode) return;

        final parentContext = context;
        await onboard.switchLanguage(lang['code']);

        if (!parentContext.mounted) return;
        parentContext.read<VocabProvider>().reset();
        parentContext.read<LessonProvider>().resetLesson();

        await parentContext.read<HomescreenProvider>().initSession(
          onboardprovider: onboard,
          vocabprovider: parentContext.read<VocabProvider>(),
        );
        if (!parentContext.mounted) return;
        await parentContext.read<HomescreenProvider>().loadLessonHistory(
          lang['code'],
        );
        if (!parentContext.mounted) return;
        await parentContext.read<HomescreenProvider>().loadLastLesson(
          lang['code'],
        );
      },
      bottomActionButton: FilledButton.icon(
        onPressed: () {
          context.read<OnboardProvider>().prepareForAddingLanguage();
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MainOnboarding(isAddingLanguage: true),
            ),
          );
        },
        style: FilledButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 14.r),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
        ),
        icon: Icon(Icons.add_rounded, size: 20.sp),
        label: Text(
          'Add New Language',
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
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
      confirmBorderColor: context.theme.colorScheme.error.withValues(
        alpha: 0.8,
      ),
      confirmButtonColor: context.theme.colorScheme.error.withValues(
        alpha: 0.8,
      ),
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
    }
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      child: Text(
        title.toUpperCase(),
        style: context.text.labelMedium?.copyWith(
          color: context.colors.outline,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    Color? textColor,
    Color? iconColor,
    Color? iconBgColor,
    bool showArrow = false,
    VoidCallback? onTap,
  }) {
    final scheme = context.theme.colorScheme;
    final defaultIconBg = scheme.primary.withValues(alpha: 0.12);
    final defaultIconColor = iconColor ?? scheme.primary;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            children: [
              Container(
                width: 44.r,
                height: 44.r,
                decoration: BoxDecoration(
                  color: iconBgColor ?? defaultIconBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 22.r, color: defaultIconColor),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: context.text.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: textColor ?? scheme.onSurface,
                      ),
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: 4.h),
                      Text(
                        subtitle,
                        style: context.text.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (showArrow)
                Icon(
                  Icons.chevron_right_rounded,
                  color: scheme.outline.withValues(alpha: 0.5),
                  size: 22.r,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDailyGoalPicker(BuildContext context, String currentGoal) {
    final goals = DailyGoal.all;
    final scheme = context.theme.colorScheme;

    AppSelectionBottomSheet.show<DailyGoal>(
      context: context,
      title: context.l10n.dailyGoal,
      subtitle: 'Select your daily practice target',
      items: goals,
      isSelected: (goal) => goal.code == currentGoal,
      leadingBuilder: (context, goal, isActive) {
        final Map<String, String> goalEmojis = {
          'Casual': '🌱',
          'Regular': '⚡',
          'Serious': '🔥',
          'Intense': '🏆',
        };
        final emoji = goalEmojis[goal.code] ?? '🎯';
        return Container(
          width: 46.r,
          height: 46.r,
          decoration: BoxDecoration(
            color: isActive
                ? scheme.primary.withValues(alpha: 0.12)
                : scheme.onSurface.withValues(alpha: 0.06),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(emoji, style: TextStyle(fontSize: 22.sp)),
          ),
        );
      },
      titleBuilder: (context, goal) {
        switch (goal.code) {
          case 'Casual':
            return context.l10n.casual;
          case 'Regular':
            return context.l10n.regular;
          case 'Serious':
            return context.l10n.serious;
          case 'Intense':
            return context.l10n.intense;
          default:
            return goal.code;
        }
      },
      subtitleBuilder: (context, goal) {
        return '${goal.words} ${context.l10n.wordsExercise}';
      },
      activeBadgeText: 'Selected',
      onItemTap: (sheetContext, goal) async {
        Navigator.pop(sheetContext);
        if (goal.code == currentGoal) return;

        final parentContext = context;
        final confirmed = await AppAlertdialog.showConfirmationDialog(
          context: parentContext,
          icon: Icons.timer_outlined,
          iconColor: parentContext.theme.colorScheme.primary,
          title: parentContext.l10n.changeDailyGoalDialogTitle,
          message: S
              .of(parentContext)
              .changeDailyGoalDialogMessage(goal.words.toString()),
          cancelText: parentContext.l10n.cancel,
          confirmText: S.of(parentContext).changeLanguageDialogConfirm,
        );

        if (confirmed == true && parentContext.mounted) {
          parentContext.read<OnboardProvider>().updateDailygoal(goal.code);
          parentContext.read<VocabProvider>().updateDailyLimit(goal.code);
          parentContext.read<VocabProvider>().reset();
          parentContext.read<LessonProvider>().resetLesson();
        }
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
    final initialAge = currentAge > 0 ? currentAge : 24;
    final emailController = TextEditingController(text: email);

    final pageController = PageController(
      initialPage: initialAge - 10,
      viewportFraction: 0.22,
    );

    showModalBottomSheet(
      context: parentContext,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      backgroundColor: parentContext.colors.surface,
      isScrollControlled: true,
      builder: (context) {
        return ChangeNotifierProvider(
          create: (_) => UserProfileProvider()..init(currentGender, currentAge),
          builder: (sheetContext, _) {
            final provider = sheetContext.watch<UserProfileProvider>();
            final isLoading = provider.isLoading;
            final selectedGender = provider.selectedGender;
            final age = provider.age;

            return Padding(
              padding: EdgeInsets.only(
                left: 20.r,
                right: 20.r,
                top: 16.r,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20.r,
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
                        ).colorScheme.onSurface.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    parentContext.l10n.personalInformation,
                    style: parentContext.text.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  TextFormField(
                    enabled: false,
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: parentContext.text.bodyMedium?.copyWith(
                      color: parentContext.colors.onSurface.withValues(
                        alpha: 0.5,
                      ),
                    ),
                    decoration: InputDecoration(
                      labelText: parentContext.l10n.email,
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        size: 20.r,
                        color: parentContext.colors.outline.withValues(
                          alpha: 0.5,
                        ),
                      ),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 14.h,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(
                          color: parentContext.colors.outline.withValues(
                            alpha: 0.15,
                          ),
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(
                          color: parentContext.colors.primary,
                          width: 1.5,
                        ),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(
                          color: parentContext.colors.outline.withValues(
                            alpha: 0.15,
                          ),
                          width: 1.5,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(
                          color: parentContext.colors.error,
                          width: 1.5,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(
                          color: parentContext.colors.error,
                          width: 1.5,
                        ),
                      ),
                      errorText: () {
                        final text = emailController.text.trim();
                        if (text.isEmpty) return null;
                        final isEmailValid = RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                        ).hasMatch(text);
                        if (!isEmailValid) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      }(),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    parentContext.l10n.gender,
                    style: parentContext.text.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: Textconstant.genders.map((g) {
                      final label = g['label'] as String;
                      final icon = g['icon'] as IconData;
                      final isSelected = selectedGender == label;

                      return Expanded(
                        child: GestureDetector(
                          onTap: isLoading
                              ? null
                              : () {
                                  provider.setGender(label);
                                  log(label);
                                  log("Changed");
                                },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: EdgeInsets.symmetric(horizontal: 4.w),
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? parentContext.colors.primary.withValues(
                                      alpha: 0.12,
                                    )
                                  : parentContext.colors.surface,
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(
                                color: isSelected
                                    ? parentContext.colors.primary
                                    : parentContext.colors.outline.withValues(
                                        alpha: 0.18,
                                      ),
                                width: 1.8,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: parentContext.colors.primary
                                            .withValues(alpha: 0.15),
                                        blurRadius: 6,
                                        offset: const Offset(0, 3),
                                      ),
                                    ]
                                  : [],
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  icon,
                                  size: 24.r,
                                  color: isSelected
                                      ? parentContext.colors.primary
                                      : parentContext.colors.onSurfaceVariant
                                            .withValues(alpha: 0.65),
                                ),
                                SizedBox(height: 6.h),
                                Text(
                                  label,
                                  style: parentContext.text.titleSmall
                                      ?.copyWith(
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.w500,
                                        color: isSelected
                                            ? parentContext.colors.primary
                                            : parentContext
                                                  .colors
                                                  .onSurfaceVariant
                                                  .withValues(alpha: 0.65),
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    '${parentContext.l10n.age}: $age',
                    style: parentContext.text.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 12.h,
                      horizontal: 8.w,
                    ),
                    decoration: BoxDecoration(
                      color: parentContext.colors.surface.withValues(
                        alpha: 0.35,
                      ),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: parentContext.colors.outline.withValues(
                          alpha: 0.15,
                        ),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _AgeButton(
                              icon: Icons.remove_rounded,
                              onTap: isLoading
                                  ? () {}
                                  : () {
                                      final newAge = (age - 1).clamp(10, 60);
                                      provider.setAge(newAge);
                                      pageController.animateToPage(
                                        newAge - 10,
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        curve: Curves.easeOutCubic,
                                      );
                                    },
                            ),
                            Expanded(
                              child: SizedBox(
                                height: 60.h,
                                child: PageView.builder(
                                  controller: pageController,
                                  onPageChanged: (pageIndex) {
                                    final targetAge = 10 + pageIndex;
                                    if (age != targetAge) {
                                      provider.setAge(targetAge);
                                    }
                                  },
                                  physics: isLoading
                                      ? const NeverScrollableScrollPhysics()
                                      : const BouncingScrollPhysics(),
                                  itemCount: 51,
                                  itemBuilder: (context, index) {
                                    final itemAge = 10 + index;
                                    return AnimatedBuilder(
                                      animation: pageController,
                                      builder: (context, child) {
                                        double value = 0.0;
                                        if (pageController
                                            .position
                                            .haveDimensions) {
                                          value = pageController.page! - index;
                                        } else {
                                          value = (age - 10 - index).toDouble();
                                        }

                                        final double distance = value.abs();
                                        final double scale =
                                            (1.0 - (distance * 0.25)).clamp(
                                              0.72,
                                              1.0,
                                            );
                                        final double opacity =
                                            (1.0 - (distance * 0.45)).clamp(
                                              0.4,
                                              1.0,
                                            );
                                        final isSelected = distance < 0.5;

                                        return Center(
                                          child: Opacity(
                                            opacity: opacity,
                                            child: Transform.scale(
                                              scale: scale,
                                              child: Container(
                                                width: 44.r,
                                                height: 44.r,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  color: isSelected
                                                      ? parentContext
                                                            .colors
                                                            .primary
                                                      : Colors.transparent,
                                                  shape: BoxShape.circle,
                                                  boxShadow: isSelected
                                                      ? [
                                                          BoxShadow(
                                                            color: parentContext
                                                                .colors
                                                                .primary
                                                                .withValues(
                                                                  alpha: 0.35,
                                                                ),
                                                            blurRadius: 8,
                                                            offset:
                                                                const Offset(
                                                                  0,
                                                                  3,
                                                                ),
                                                          ),
                                                        ]
                                                      : [],
                                                  border: Border.all(
                                                    color: isSelected
                                                        ? parentContext
                                                              .colors
                                                              .primary
                                                        : parentContext
                                                              .colors
                                                              .outline
                                                              .withValues(
                                                                alpha: 0.08,
                                                              ),
                                                    width: 1.5,
                                                  ),
                                                ),
                                                child: Text(
                                                  '$itemAge',
                                                  style: TextStyle(
                                                    fontSize: 16.sp,
                                                    fontWeight: isSelected
                                                        ? FontWeight.bold
                                                        : FontWeight.w500,
                                                    color: isSelected
                                                        ? parentContext
                                                              .colors
                                                              .onPrimary
                                                        : parentContext
                                                              .colors
                                                              .onSurfaceVariant
                                                              .withValues(
                                                                alpha: 0.7,
                                                              ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                            _AgeButton(
                              icon: Icons.add_rounded,
                              onTap: isLoading
                                  ? () {}
                                  : () {
                                      final newAge = (age + 1).clamp(10, 60);
                                      provider.setAge(newAge);
                                      pageController.animateToPage(
                                        newAge - 10,
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        curve: Curves.easeOutCubic,
                                      );
                                    },
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(21, (index) {
                              final isMajor = index % 5 == 0;
                              return Container(
                                width: 2.w,
                                height: isMajor ? 12.h : 6.h,
                                decoration: BoxDecoration(
                                  color: isMajor
                                      ? parentContext.colors.primary.withValues(
                                          alpha: 0.4,
                                        )
                                      : parentContext.colors.outline.withValues(
                                          alpha: 0.15,
                                        ),
                                  borderRadius: BorderRadius.circular(1.r),
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 28.h),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  Navigator.pop(context);
                                },
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            side: BorderSide(
                              color: parentContext.colors.outline.withValues(
                                alpha: 0.3,
                              ),
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                          ),
                          child: Text(
                            parentContext.l10n.cancel,
                            style: parentContext.text.labelLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: parentContext.colors.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (isLoading) return null;

                            final hasChanges =
                                selectedGender != currentGender ||
                                age != currentAge;

                            if (!hasChanges) return null;

                            return () async {
                              provider.setLoading(true);

                              try {
                                final userId = FirebaseAuthService.getuid();

                                // Update gender and age if changed
                                if (selectedGender != currentGender ||
                                    age != currentAge) {
                                  await FirebaseAuthService().updateUserData(
                                    userId,
                                    {'gender': selectedGender, 'age': age},
                                  );
                                  if (!parentContext.mounted) return;
                                  parentContext
                                      .read<OnboardProvider>()
                                      .setGender(selectedGender!);
                                  parentContext.read<OnboardProvider>().setAge(
                                    age,
                                  );
                                }

                                if (!sheetContext.mounted) return;
                                Navigator.pop(sheetContext);

                                String message =
                                    '${S.of(parentContext).personalInformation} updated';

                                ScaffoldMessenger.of(
                                  parentContext,
                                ).showSnackBar(
                                  SnackBar(content: Text(message)),
                                );
                              } catch (e) {
                                if (!sheetContext.mounted) return;
                                ScaffoldMessenger.of(
                                  parentContext,
                                ).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'An unexpected error occurred: $e',
                                    ),
                                    backgroundColor: parentContext.colors.error,
                                  ),
                                );
                                if (sheetContext.mounted) {
                                  provider.setLoading(false);
                                }
                              }
                            };
                          }(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: parentContext.colors.primary,
                            foregroundColor: parentContext.colors.onPrimary,
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            elevation: 0,
                          ),
                          child: isLoading
                              ? SizedBox(
                                  height: 20.r,
                                  width: 20.r,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: parentContext.colors.onPrimary,
                                  ),
                                )
                              : Text(
                                  parentContext.l10n.edit,
                                  style: parentContext.text.labelLarge
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
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
    ).then((_) {
      // Delay disposal to allow bottom sheet slide-down animation to complete
      Future.delayed(const Duration(milliseconds: 500), () {
        pageController.dispose();
        emailController.dispose();
      });
    });
  }
}

class _AgeButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _AgeButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38.r,
        height: 38.r,
        decoration: BoxDecoration(
          color: context.colors.surface,
          shape: BoxShape.circle,
          border: Border.all(
            color: context.colors.outline.withValues(alpha: 0.25),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: context.colors.shadow.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, size: 18.r, color: context.colors.onSurface),
      ),
    );
  }
}
