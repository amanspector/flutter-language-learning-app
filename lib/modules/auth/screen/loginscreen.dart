import 'package:chatbot_app/modules/auth/provider/login_screen_provider.dart';
import 'package:chatbot_app/core/extensions/localization_extension.dart';
import 'package:chatbot_app/modules/auth/screen/registerscreen.dart';
import 'package:chatbot_app/core/widgets/app_customContainer.dart';
import 'package:chatbot_app/core/extensions/theme_extension.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:chatbot_app/core/widgets/app_button.dart';
import 'package:chatbot_app/core/widgets/app_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class Loginscreen extends StatelessWidget {
  const Loginscreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loginProvider = context.read<LoginscreenProvider>();
    final String? msg = context.select<LoginscreenProvider, String?>(
      (p) => p.msg,
    );
    final formkey = loginProvider.formkey;
    final emailController = context
        .select<LoginscreenProvider, TextEditingController>(
          (p) => p.emailcontroller,
        );

    final passwordController = context
        .select<LoginscreenProvider, TextEditingController>(
          (p) => p.passwordcontroller,
        );

    final bool ispasswordvisible = context.select<LoginscreenProvider, bool>(
      (p) => p.isPasswordVisible,
    );

    return AppScreen(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.r),
          child: CustomShapeContainter(
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 50.r, horizontal: 20.r),
                child: Form(
                  key: formkey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                        context.l10n.welcomeBack,
                        // Textconstant.txt_welcomeback,
                        style: context.text.displaySmall,
                      ),
                      SizedBox(height: 10.h),

                      Text(
                        context
                            .l10n
                            .visualizeYourJourneyWithTonalProgressTracking,
                        textAlign: TextAlign.center,
                        // yourJourneyToFluencyContinuesHere,
                        style: context.text.titleMedium?.copyWith(
                          color: context.theme.colorScheme.outline,
                        ),
                      ),
                      SizedBox(height: 15.h),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        style: context.text.bodyMedium,
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

                        controller: emailController,
                        decoration: InputDecoration(
                          label: Text(context.l10n.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide(width: 2.w),
                          ),
                          hintText: context.l10n.enterEmail,
                        ),
                      ),
                      SizedBox(height: 10),

                      TextFormField(
                        style: context.text.bodyMedium,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return context.l10n.passwordIsRequired;
                          }
                          if (value.length < 6) {
                            return context.l10n.passwordTooShort;
                          }
                          return null;
                        },
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: !ispasswordvisible,
                        controller: passwordController,
                        decoration: InputDecoration(
                          label: Text(context.l10n.password),
                          suffixIcon: IconButton(
                            onPressed: () {
                              loginProvider.isPass();
                            },
                            icon: ispasswordvisible
                                ? Icon(Icons.visibility_off)
                                : Icon(Icons.visibility),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide(width: 2.w),
                          ),
                          hintText: context.l10n.enterPassword,
                        ),
                      ),
                      SizedBox(height: 10),

                      Container(
                        height: 50,
                        width: MediaQuery.widthOf(context),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        child: Consumer<LoginscreenProvider>(
                          builder: (context, value, child) {
                            return AppButton(
                              isLoading: loginProvider.isloading,
                              buttonFunc: () async {
                                if (formkey.currentState!.validate()) {
                                  loginProvider.login(
                                    context,
                                    emailController.text.trim().toLowerCase(),
                                    passwordController.text,
                                  );
                                }
                              },
                              childWidget: Text(
                                context.l10n.login,
                                // Textconstant.txt_login,
                                style: context.text.headlineMedium?.copyWith(
                                  color: context.theme.colorScheme.onPrimary,
                                ),
                                // TextStyle(
                                //   color: ColorConstant.color_black,
                                //   fontSize: 20,
                                // ),
                              ),
                            );
                          },
                        ),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            context.l10n.dontHaveAnAccount,
                            style: context.text.titleMedium,
                            // context.text.titleMedium,
                            // TextStyle(
                            //   color: ColorConstant.color_black,
                            //   fontSize: 15,
                            //   fontWeight: FontWeight.w600,
                            // ),
                          ),
                          TextButton(
                            onPressed: () {
                              loginProvider.clearloginData();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Registerscreen(),
                                ),
                              );
                            },
                            child: Text(
                              context.l10n.register,
                              // S.of(context).register,
                              style: context.text.titleMedium?.copyWith(
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (msg != null)
                        Text(
                          msg,
                          style: TextStyle(
                            color: context.theme.colorScheme.error,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
