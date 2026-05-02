import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chatbot_app/appconstants/color_constant.dart';
import 'package:chatbot_app/appconstants/text_constant.dart';
import 'package:chatbot_app/provider/onboard_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Experiencelevel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final onboard_Provider = context.watch<OnboardProvider>();
    return SingleChildScrollView(
      physics: ScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: SizedBox(
                height: 140,
                child: AnimatedTextKit(
                  displayFullTextOnTap: true,
                  totalRepeatCount: 1,
                  animatedTexts: [
                    TyperAnimatedText(
                      Textconstant.txt_experiemnceLevel,
                      speed: Duration(milliseconds: 40),
                      textStyle: Theme.of(context).textTheme.displayLarge,
                    ),
                  ],
                ),
              ),
            ),

            Text(
              Textconstant.txt_experiemnceLevelsubheading,
              style: Theme.of(context).textTheme.headlineMedium,
            ),

            RadioGroup(
              onChanged: (value) {
                if (onboard_Provider.selectedExperienceLevel == null) {
                  onboard_Provider.setExperienceLevel(value!);
                }
              },
              groupValue: onboard_Provider.selectedExperienceLevel,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  experienceLevelCard(
                    context: context,
                    iconBackgroundColor: ColorConstant.color_blueDark_shade,
                    iconColor: ColorConstant.color_bluelight,
                    icon: Icons.school_outlined,
                    experience: Textconstant.txt_beginner,
                    subtitle: Textconstant.txt_beginnersubtitle,
                  ),

                  experienceLevelCard(
                    context: context,
                    icon: Icons.auto_awesome_outlined,
                    iconBackgroundColor: ColorConstant.color_darkgreen,
                    iconColor: ColorConstant.color_lightgreen,
                    experience: Textconstant.txt_intermediate,
                    subtitle: Textconstant.txt_intermediatesubtitle,
                  ),

                  experienceLevelCard(
                    context: context,
                    icon: Icons.military_tech_outlined,
                    iconBackgroundColor: ColorConstant.color_darkskin,
                    iconColor: ColorConstant.color_lightskin,
                    experience: Textconstant.txt_advanced,
                    subtitle: Textconstant.txt_advancedsubtitle,
                  ),
                  if (onboard_Provider.error_message != null)
                    Padding(
                      padding: EdgeInsetsGeometry.symmetric(
                        horizontal: 15,
                        vertical: 5,
                      ),
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          Colors.red,
                          BlendMode.srcIn,
                        ),
                        child: Text(
                          onboard_Provider.error_message!,
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget experienceLevelCard({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required Color iconBackgroundColor,
    required String experience,
    required String subtitle,
  }) {
    // final onboard_Provider = context.watch<OnboardProvider>();
    // final isSelected = onboard_Provider.selectedlanguage == language;
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: GestureDetector(
        onTap: () {
          context.read<OnboardProvider>().setExperienceLevel(experience);
        },
        child: Container(
          padding: EdgeInsets.all(30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color:
                // ColorConstant.color_blueDark_shade
                //     :
                ColorConstant.color_white_withalpha30,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  // color: ColorConstant.color_blueDark_shade,
                  color: iconBackgroundColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                height: 80,
                width: 60,
                child: Icon(
                  size: 35,
                  icon,
                  // color: ColorConstant.color_bluelight,
                  color: iconColor,
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      experience,
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    SizedBox(height: 10),

                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
              ),
              Radio(value: experience),
            ],
          ),
        ),
      ),
    );
  }
}
