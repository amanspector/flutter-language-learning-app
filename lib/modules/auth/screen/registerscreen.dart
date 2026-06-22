import 'package:chatbot_app/core/appconstants/color_constant.dart';
import 'package:chatbot_app/core/appconstants/text_constant.dart';
import 'package:chatbot_app/core/extensions/app_animation_extension.dart';
import 'package:chatbot_app/core/extensions/localization_extension.dart';
import 'package:chatbot_app/core/extensions/theme_extension.dart';
import 'package:chatbot_app/core/widgets/app_button.dart';
import 'package:chatbot_app/core/widgets/app_container.dart';
import 'package:chatbot_app/core/widgets/app_customContainer.dart';
import 'package:chatbot_app/core/widgets/app_error_widget.dart';
import 'package:chatbot_app/core/widgets/app_screen.dart';
import 'package:chatbot_app/modules/auth/provider/register_screen_provider.dart';
import 'package:chatbot_app/modules/auth/screen/loginscreen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Registerscreen extends StatelessWidget {
  const Registerscreen({super.key});

  @override
  Widget build(BuildContext context) {
    final registerProvider = context.read<RegisterscreenProvider>();
    final String? msg = context.select<RegisterscreenProvider, String?>(
      (p) => p.msg,
    );

    final bool ispasswordvisible = context.select<RegisterscreenProvider, bool>(
      (p) => p.isPasswordVisible,
    );

    final bool isConfirmPasswordVisible = context
        .select<RegisterscreenProvider, bool>(
          (p) => p.isConfirmPasswordVisible,
        );
    final formkey = context.read<RegisterscreenProvider>().formkey;

    return AppScreen(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: kToolbarHeight + 10.h,
        ),
        child: CustomPaint(
          painter: TicketPainter(
            concaveDepth: 12,
            cornerRadius: 32,
            color: context.colors.surface.withValues(alpha: 0.72),
            borderColor: context.colors.outline.withValues(alpha: 0.18),
            glowColor: context.colors.primary,
          ),
          child: AppContainer(
            backgroundColor: ColorConstant.colorTransparent,
            borderColor: ColorConstant.colorTransparent,
            widget: Padding(
              padding: EdgeInsets.symmetric(vertical: 35.h, horizontal: 20.w),
              child: Form(
                key: formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        height: 90.h,
                        width: 90.w,
                        padding: EdgeInsets.all(8.r),
                        decoration: BoxDecoration(
                          color: context.colors.primary.withValues(alpha: 0.08),
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                          'assets/icon/appicon_1.png',
                          fit: BoxFit.contain,
                        ),
                      ).popIn,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      context.l10n.joinTheJourney,
                      textAlign: TextAlign.center,
                      style: context.text.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.colors.onSurface,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      context.l10n.masterNewSkills,
                      textAlign: TextAlign.center,
                      style: context.text.titleMedium?.copyWith(
                        color: context.colors.onSurfaceVariant.withValues(
                          alpha: 0.7,
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    TextFormField(
                      controller: registerProvider.mailcontroller,
                      style: context.text.bodyMedium,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return context.l10n.emailIsRequired;
                        }
                        if (!RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(value)) {
                          return context.l10n.enterValidEmail;
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 14.h,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(
                            color: context.colors.outline.withValues(
                              alpha: 0.3,
                            ),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(
                            color: context.colors.outline.withValues(
                              alpha: 0.3,
                            ),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(
                            color: context.colors.primary,
                            width: 2,
                          ),
                        ),
                        label: Text(context.l10n.email),
                        hintText: context.l10n.enterYourEmail,
                      ),
                    ),
                    SizedBox(height: 12.h),

                    TextFormField(
                      controller: registerProvider.passwordcontroller,
                      keyboardType: TextInputType.visiblePassword,
                      style: context.text.bodyMedium,
                      obscureText: !ispasswordvisible,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return context.l10n.passwordIsRequired;
                        }
                        if (value.length < 8) {
                          return context.l10n.minimumEightCharactersRequired;
                        }
                        if (!RegExp(r'[A-Z]').hasMatch(value)) {
                          return context
                              .l10n
                              .mustContainAtLeastOneUppercaseLetter;
                        }
                        if (!RegExp(r'[a-z]').hasMatch(value)) {
                          return context
                              .l10n
                              .mustContainAtLeastOneLowercaseLetter;
                        }
                        if (!RegExp(r'[0-9]').hasMatch(value)) {
                          return context.l10n.mustContainAtLeastOneNumber;
                        }
                        if (!RegExp(r'[!@#\$&*~]').hasMatch(value)) {
                          return context.l10n.mustContainOneSpecialCharacter;
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 14.h,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            registerProvider.isPassword();
                          },
                          icon: Icon(
                            ispasswordvisible
                                ? Icons.visibility_off_rounded
                                : Icons.visibility_rounded,
                            size: 20.r,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(
                            color: context.colors.outline.withValues(
                              alpha: 0.3,
                            ),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(
                            color: context.colors.outline.withValues(
                              alpha: 0.3,
                            ),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(
                            color: context.colors.primary,
                            width: 2,
                          ),
                        ),
                        label: Text(context.l10n.password),
                        hintText: context.l10n.enterYourPassword,
                      ),
                    ),
                    SizedBox(height: 12.h),

                    TextFormField(
                      obscureText: !isConfirmPasswordVisible,
                      style: context.text.bodyMedium,
                      keyboardType: TextInputType.visiblePassword,
                      controller: registerProvider.confirmpasswordcontroller,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return context.l10n.confirmPasswordIsRequired;
                        }
                        if (value != registerProvider.passwordcontroller.text) {
                          return context.l10n.passwordDoesntMatch;
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 14.h,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            context
                                .read<RegisterscreenProvider>()
                                .isConfirmPassword();
                          },
                          icon: Icon(
                            isConfirmPasswordVisible
                                ? Icons.visibility_off_rounded
                                : Icons.visibility_rounded,
                            size: 20.r,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(
                            color: context.colors.outline.withValues(
                              alpha: 0.3,
                            ),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(
                            color: context.colors.outline.withValues(
                              alpha: 0.3,
                            ),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(
                            color: context.colors.primary,
                            width: 2,
                          ),
                        ),
                        label: Text(context.l10n.confirmPassword),
                        hintText: context.l10n.enterYourConfirmPassword,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    DropdownButtonFormField<String>(
                      style: context.text.bodyMedium?.copyWith(
                        color: context.colors.onSurface,
                      ),
                      initialValue: context
                          .read<RegisterscreenProvider>()
                          .selectedGender,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                        label: Text(context.l10n.gender),
                        hintText: context.l10n.selectYourGender,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(
                            color: context.colors.outline.withValues(
                              alpha: 0.3,
                            ),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(
                            color: context.colors.outline.withValues(
                              alpha: 0.3,
                            ),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(
                            color: context.colors.primary,
                            width: 2,
                          ),
                        ),
                      ),
                      items: Textconstant.genders.map((g) {
                        return DropdownMenuItem<String>(
                          value: g['label'] as String,
                          child: Row(
                            children: [
                              Icon(
                                g['icon'] as IconData,
                                size: 20.r,
                                color: context.colors.primary,
                              ),
                              SizedBox(width: 10.w),
                              Text(
                                g['label'] as String,
                                style: context.text.bodyMedium,
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          context.read<RegisterscreenProvider>().setGender(
                            value,
                          );
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return context.l10n.pleaseSelectYourGender;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),

                    Padding(
                      padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
                      child: Text(
                        context.l10n.age,
                        textAlign: TextAlign.left,
                        style: context.text.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // Age selector
                    const AgeSelector(),

                    SizedBox(height: 24.h),
                    AppButton(
                      isLoading: context
                          .watch<RegisterscreenProvider>()
                          .isLoading,
                      buttonFunc: () async {
                        if (formkey.currentState!.validate()) {
                          await context.read<RegisterscreenProvider>().register(
                            context,
                            registerProvider.mailcontroller.text
                                .trim()
                                .toLowerCase(),
                            registerProvider.passwordcontroller.text,
                          );
                        }
                      },
                      childWidget: Text(
                        context.l10n.register,
                        style: context.text.labelLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (msg != null) ...[
                      SizedBox(height: 12.h),
                      AppErrorwidget().showError(msg, context),
                    ],

                    SizedBox(height: 12.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          context.l10n.alreadyHaveAnAccount,
                          style: context.text.titleMedium?.copyWith(
                            color: context.colors.onSurfaceVariant.withValues(
                              alpha: 0.8,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            registerProvider.clearData();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Loginscreen(),
                              ),
                            );
                          },
                          child: Text(
                            context.l10n.login,
                            style: context.text.titleMedium?.copyWith(
                              color: context.colors.primary,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              decorationColor: context.colors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AgeSelector extends StatelessWidget {
  const AgeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final registerProvider = context.read<RegisterscreenProvider>();
    final selectedAge = context.select<RegisterscreenProvider, int?>(
      (p) => p.selectedAge,
    );
    final currentAge = selectedAge ?? 24;

    final pageController = registerProvider.getAgePageController(currentAge);

    // Sync PageController with provider age (e.g. when +/- buttons are clicked)
    if (pageController.hasClients) {
      final currentControllerPage = pageController.page?.round();
      if (currentControllerPage != null &&
          currentControllerPage != (currentAge - 10)) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (pageController.hasClients) {
            pageController.animateToPage(
              currentAge - 10,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
            );
          }
        });
      }
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: context.colors.surface.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: context.colors.outline.withValues(alpha: 0.15),
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
                onTap: () {
                  final newAge = (currentAge - 1).clamp(10, 60);
                  registerProvider.setAge(newAge);
                },
              ),
              Expanded(
                child: SizedBox(
                  height: 60.h,
                  child: PageView.builder(
                    controller: pageController,
                    onPageChanged: (pageIndex) {
                      final targetAge = 10 + pageIndex;
                      if (registerProvider.selectedAge != targetAge) {
                        registerProvider.setAge(targetAge);
                      }
                    },
                    physics: const BouncingScrollPhysics(),
                    itemCount: 51, // ages 10 to 60
                    itemBuilder: (context, index) {
                      final age = 10 + index;
                      return AnimatedBuilder(
                        animation: pageController,
                        builder: (context, child) {
                          double value = 0.0;
                          if (pageController.position.haveDimensions) {
                            value = pageController.page! - index;
                          } else {
                            value = (currentAge - 10 - index).toDouble();
                          }

                          final double distance = value.abs();
                          final double scale = (1.0 - (distance * 0.25)).clamp(
                            0.72,
                            1.0,
                          );
                          final double opacity = (1.0 - (distance * 0.45))
                              .clamp(0.4, 1.0);
                          final isSelected = distance < 0.5;

                          return Center(
                            child: Opacity(
                              opacity: opacity,
                              child: Transform.scale(
                                scale: scale,
                                child: Container(
                                  width: 48.r,
                                  height: 48.r,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? context.colors.primary
                                        : Colors.transparent,
                                    shape: BoxShape.circle,
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color: context.colors.primary
                                                  .withValues(alpha: 0.35),
                                              blurRadius: 8,
                                              offset: const Offset(0, 3),
                                            ),
                                          ]
                                        : [],
                                    border: Border.all(
                                      color: isSelected
                                          ? context.colors.primary
                                          : context.colors.outline.withValues(
                                              alpha: 0.08,
                                            ),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Text(
                                    '$age',
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.w500,
                                      color: isSelected
                                          ? context.colors.onPrimary
                                          : context.colors.onSurfaceVariant
                                                .withValues(alpha: 0.7),
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
                onTap: () {
                  final newAge = (currentAge + 1).clamp(10, 60);
                  registerProvider.setAge(newAge);
                },
              ),
            ],
          ),
          // SizedBox(height: 12.h),
          // Ruler style tick lines
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 24.w),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: List.generate(21, (index) {
          //       final isMajor = index % 5 == 0;
          //       return Container(
          //         width: 2.w,
          //         height: isMajor ? 12.h : 6.h,
          //         decoration: BoxDecoration(
          //           color: isMajor
          //               ? context.colors.primary.withValues(alpha: 0.4)
          //               : context.colors.outline.withValues(alpha: 0.15),
          //           borderRadius: BorderRadius.circular(1.r),
          //         ),
          //       );
          //     }),
          //   ),
          // ),
          SizedBox(height: 8.h),
          Text(
            context.l10n.yearsOld,
            style: TextStyle(
              fontSize: 12.sp,
              color: context.colors.onSurfaceVariant.withValues(alpha: 0.6),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
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
          color: context.colors.surface.withValues(alpha: 0.85),
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
