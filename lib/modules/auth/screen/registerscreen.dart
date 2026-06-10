import 'package:chatbot_app/core/appconstants/text_constant.dart';
import 'package:chatbot_app/core/extensions/localization_extension.dart';
import 'package:chatbot_app/core/extensions/theme_extension.dart';
import 'package:chatbot_app/core/widgets/app_button.dart';
import 'package:chatbot_app/core/widgets/app_customContainer.dart';
import 'package:chatbot_app/core/widgets/app_error_widget.dart';
import 'package:chatbot_app/core/widgets/app_screen.dart';
import 'package:chatbot_app/generated/l10n.dart';
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
        padding: EdgeInsets.symmetric(
          horizontal: 10.r,
          vertical: kToolbarHeight,
        ),
        child: CustomShapeContainter(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 30.r, horizontal: 20.r),
            child: Form(
              key: formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 105.h,
                    width: 105.w,
                    child: Image.asset(
                      'assets/icon/appicon_1.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  Text(
                    S.of(context).joinTheJourney,

                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    textAlign: TextAlign.center,
                    context.l10n.masterNewSkills,
                    style: context.theme.textTheme.titleMedium?.copyWith(
                      color: context.theme.colorScheme.outline,
                    ),
                  ),
                  SizedBox(height: 15.h),
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
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide: BorderSide(width: 2.r),
                      ),
                      label: Text(context.l10n.email),
                      hintText: context.l10n.enterYourEmail,
                    ),
                  ),
                  SizedBox(height: 10.h),

                  TextFormField(
                    controller: registerProvider.passwordcontroller,
                    keyboardType: TextInputType.visiblePassword,
                    style: Theme.of(context).textTheme.bodyMedium,
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
                      suffixIcon: IconButton(
                        onPressed: () {
                          registerProvider.isPassword();
                        },
                        icon: ispasswordvisible
                            ? Icon(Icons.visibility_off)
                            : Icon(Icons.visibility),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide: BorderSide(width: 2.r),
                      ),
                      label: Text(context.l10n.password),
                      hintText: context.l10n.enterYourPassword,
                    ),
                  ),
                  SizedBox(height: 10.h),

                  TextFormField(
                    obscureText: !isConfirmPasswordVisible,
                    style: context.theme.textTheme.bodyMedium,
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
                      suffixIcon: IconButton(
                        onPressed: () {
                          context
                              .read<RegisterscreenProvider>()
                              .isConfirmPassword();
                        },
                        icon: isConfirmPasswordVisible
                            ? Icon(Icons.visibility_off)
                            : Icon(Icons.visibility),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide: BorderSide(width: 2.r),
                      ),
                      label: Text(context.l10n.confirmPassword),
                      hintText: context.l10n.enterYourConfirmPassword,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  DropdownButtonFormField<String>(
                    style: context.text.bodyMedium,
                    initialValue: context
                        .read<RegisterscreenProvider>()
                        .selectedGender,
                    decoration: InputDecoration(
                      label: Text(context.l10n.gender),
                      hintText: context.l10n.selectYourGender,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide: BorderSide(width: 2.r),
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
                              color: context
                                  .theme
                                  .colorScheme
                                  .onSecondaryContainer,
                            ),
                            SizedBox(width: 10.w),
                            Text(
                              g['label'] as String,
                              style: TextStyle(fontSize: 14.sp),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        context.read<RegisterscreenProvider>().setGender(value);
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return context.l10n.pleaseSelectYourGender;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10.h),

                  Padding(
                    padding: EdgeInsets.only(left: 8.r),
                    child: Text(
                      context.l10n.age,
                      textAlign: TextAlign.left,
                      style: context.theme.textTheme.titleMedium,
                    ),
                  ),

                  // Age selector
                  AgeSelector(),

                  SizedBox(height: 10.h),
                  AppButton(
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
                      style: context.text.headlineMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  if (msg != null) ...[
                    SizedBox(height: 5.h),
                    AppErrorwidget().showError(msg, context),
                  ],

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        S.of(context).alreadyHaveAnAccount,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      TextButton(
                        onPressed: () => {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Loginscreen(),
                            ),
                          ),
                        },
                        child: Text(
                          S.of(context).login,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(decoration: TextDecoration.underline),
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
    );
  }
}

class AgeSelector extends StatelessWidget {
  const AgeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedAge = context.select<RegisterscreenProvider, int?>(
      (p) => p.selectedAge,
    );
    final age = selectedAge ?? 24;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.r),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$age',
                    style: TextStyle(
                      fontSize: 36.sp,
                      fontWeight: FontWeight.w600,
                      color: context.theme.colorScheme.onSecondaryContainer,
                      height: 1,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    S.of(context).yearsOld,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: context.theme.colorScheme.outline,
                    ),
                  ),
                ],
              ),

              // +/- buttons
              Row(
                children: [
                  _AgeButton(
                    icon: Icons.remove,
                    onTap: () {
                      final newAge = (age - 1).clamp(10, 60);
                      context.read<RegisterscreenProvider>().setAge(newAge);
                    },
                  ),
                  SizedBox(width: 8.w),
                  _AgeButton(
                    icon: Icons.add,
                    onTap: () {
                      final newAge = (age + 1).clamp(10, 60);
                      context.read<RegisterscreenProvider>().setAge(newAge);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),

        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: context.theme.colorScheme.primary,
            inactiveTrackColor: Theme.of(
              context,
            ).colorScheme.outline.withValues(alpha: 0.3),
            // ColorConstant.grey.withOpacity(0.2),
            thumbColor: context.theme.colorScheme.primary,
            overlayColor: context.theme.colorScheme.primary.withValues(
              alpha: 0.15,
            ),
            trackHeight: 4,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.r),
          ),
          child: Slider(
            value: age.toDouble(),
            min: 10,
            max: 60,
            divisions: 50,
            onChanged: (val) =>
                context.read<RegisterscreenProvider>().setAge(val.round()),
          ),
        ),

        // Range labels
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '10',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: context.theme.colorScheme.outline,
                ),
              ),
              Text(
                '60',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: context.theme.colorScheme.outline,
                ),
              ),
            ],
          ),
        ),
      ],
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
        width: 40.r,
        height: 40.r,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: context.theme.colorScheme.outline.withValues(alpha: 0.4),
          ),
        ),
        child: Icon(
          icon,
          size: 18.sp,
          color: context.theme.colorScheme.onSurface,
        ),
      ),
    );
  }
}
