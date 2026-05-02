import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chatbot_app/appconstants/color_constant.dart';
import 'package:chatbot_app/appconstants/text_constant.dart';
import 'package:chatbot_app/provider/onboard_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Goalselection extends StatelessWidget {
  const Goalselection({super.key});

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
                      Textconstant.txt_whyareyoulearning,
                      speed: Duration(milliseconds: 40),
                      textStyle: Theme.of(context).textTheme.displayLarge,
                    ),
                  ],
                ),
              ),
            ),

            Text(
              Textconstant.txt_tailoryourexperience,
              style: Theme.of(context).textTheme.headlineMedium,
            ),

            RadioGroup(
              onChanged: (value) {
                if (onboard_Provider.selectedgoal == null) {
                  onboard_Provider.setGoal(value!);
                }
              },
              groupValue: onboard_Provider.selectedgoal,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  onboard_Provider.error_message != null
                      ? Padding(
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
                        )
                      : SizedBox(),
                  goalSelectionCard(
                    context: context,
                    iconBackgroundColor: ColorConstant.color_blueDark_shade,
                    iconColor: ColorConstant.color_bluelight,
                    icon: Icons.flight_takeoff,
                    goal: Textconstant.txt_travel,
                    subtitle: Textconstant.txt_travelsubtitle,
                  ),

                  goalSelectionCard(
                    context: context,
                    icon: Icons.work_history_outlined,
                    iconBackgroundColor: ColorConstant.color_darkgreen,
                    iconColor: ColorConstant.color_lightgreen,
                    goal: Textconstant.txt_carrer,
                    subtitle: Textconstant.txt_careersubtitle,
                  ),

                  goalSelectionCard(
                    context: context,
                    icon: Icons.school_outlined,
                    iconBackgroundColor: ColorConstant.color_darkskin,
                    iconColor: ColorConstant.color_lightskin,
                    goal: Textconstant.txt_school,
                    subtitle: Textconstant.txt_schoolsubtitle,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget goalSelectionCard({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required Color iconBackgroundColor,
    required String goal,
    required String subtitle,
  }) {
    // final onboard_Provider = context.watch<OnboardProvider>();
    // final isSelected = onboard_Provider.selectedlanguage == language;
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: GestureDetector(
        onTap: () {
          context.read<OnboardProvider>().setGoal(goal);
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      // color: ColorConstant.color_blueDark_shade,
                      color: iconBackgroundColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    height: 50,
                    width: 50,
                    child: Icon(
                      size: 35,
                      icon,
                      // color: ColorConstant.color_bluelight,
                      color: iconColor,
                    ),
                  ),
                  Radio(value: goal),
                ],
              ),
              SizedBox(height: 20),

              Text(goal, style: Theme.of(context).textTheme.displayMedium),
              SizedBox(height: 10),

              Text(subtitle, style: Theme.of(context).textTheme.headlineMedium),
            ],
          ),
        ),
      ),
    );
  }
}
