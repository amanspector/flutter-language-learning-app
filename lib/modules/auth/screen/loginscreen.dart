import 'package:chatbot_app/core/appconstants/color_constant.dart';
import 'package:chatbot_app/core/extensions/app_animation_extension.dart';
import 'package:chatbot_app/core/extensions/localization_extension.dart';
import 'package:chatbot_app/core/extensions/theme_extension.dart';
import 'package:chatbot_app/core/widgets/app_button.dart';
import 'package:chatbot_app/core/widgets/app_container.dart';
import 'package:chatbot_app/core/widgets/app_customContainer.dart';
import 'package:chatbot_app/core/widgets/app_error_widget.dart';
import 'package:chatbot_app/core/widgets/app_screen.dart';
import 'package:chatbot_app/modules/auth/provider/login_screen_provider.dart';
import 'package:chatbot_app/modules/auth/screen/registerscreen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Loginscreen extends StatelessWidget {
  const Loginscreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loginProvider = context.read<LoginscreenProvider>();
    final String? msg = context.select<LoginscreenProvider, String?>(
      (p) => p.msg,
    );
    final formkey = loginProvider.formkey;
    final emailController = context.select<LoginscreenProvider, TextEditingController>(
      (p) => p.emailcontroller,
    );

    final passwordController = context.select<LoginscreenProvider, TextEditingController>(
      (p) => p.passwordcontroller,
    );

    final bool ispasswordvisible = context.select<LoginscreenProvider, bool>(
      (p) => p.isPasswordVisible,
    );

    return AppScreen(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: kToolbarHeight + 40.h,
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
              padding: EdgeInsets.symmetric(vertical: 45.h, horizontal: 20.w),
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
                      context.l10n.welcomeBack,
                      textAlign: TextAlign.center,
                      style: context.text.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.colors.onSurface,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      context.l10n.visualizeYourJourneyWithTonalProgressTracking,
                      textAlign: TextAlign.center,
                      style: context.text.titleMedium?.copyWith(
                        color: context.colors.onSurfaceVariant.withValues(
                          alpha: 0.7,
                        ),
                      ),
                    ),
                    SizedBox(height: 28.h),
                    TextFormField(
                      controller: emailController,
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
                        hintText: context.l10n.enterEmail,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    TextFormField(
                      controller: passwordController,
                      style: context.text.bodyMedium,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: !ispasswordvisible,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return context.l10n.passwordIsRequired;
                        }
                        if (value.length < 6) {
                          return context.l10n.passwordTooShort;
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
                            loginProvider.isPass();
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
                        hintText: context.l10n.enterPassword,
                      ),
                    ),
                    SizedBox(height: 28.h),
                    AppButton(
                      isLoading: context.watch<LoginscreenProvider>().isloading,
                      buttonFunc: () async {
                        if (formkey.currentState!.validate()) {
                          await loginProvider.login(
                            context,
                            emailController.text.trim().toLowerCase(),
                            passwordController.text,
                          );
                        }
                      },
                      childWidget: Text(
                        context.l10n.login,
                        style: context.text.labelLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (msg != null) ...[
                      SizedBox(height: 12.h),
                      AppErrorwidget().showError(msg, context),
                    ],
                    SizedBox(height: 16.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          context.l10n.dontHaveAnAccount,
                          style: context.text.titleMedium?.copyWith(
                            color: context.colors.onSurfaceVariant.withValues(
                              alpha: 0.8,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            loginProvider.clearloginData();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Registerscreen(),
                              ),
                            );
                          },
                          child: Text(
                            context.l10n.register,
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
