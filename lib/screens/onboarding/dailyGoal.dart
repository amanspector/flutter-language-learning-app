import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chatbot_app/appconstants/color_constant.dart';
import 'package:chatbot_app/appconstants/text_constant.dart';
import 'package:chatbot_app/provider/onboard_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Dailygoal extends StatelessWidget {
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
                height: 80,
                child: AnimatedTextKit(
                  displayFullTextOnTap: true,
                  totalRepeatCount: 1,
                  animatedTexts: [
                    TyperAnimatedText(
                      Textconstant.txt_setyourdailygoal,
                      speed: Duration(milliseconds: 40),
                      textStyle: Theme.of(context).textTheme.displayLarge,
                    ),
                  ],
                ),
              ),
            ),

            Text(
              Textconstant.txt_consistencyiskey,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              Textconstant.txt_chooseapace,
              style: Theme.of(context).textTheme.headlineMedium,
            ),

            RadioGroup(
              onChanged: (value) {
                if (onboard_Provider.selectedDailyGoal == null) {
                  onboard_Provider.setDailyGoal(value!);
                }
              },
              groupValue: onboard_Provider.selectedDailyGoal,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  dailyGoalSelectionCard(
                    context: context,
                    iconBackgroundColor: ColorConstant.color_darkgreen,
                    iconColor: ColorConstant.color_lightgreen,
                    icon: Icons.coffee,
                    dailygoal: Textconstant.txt_casual,
                    dailygoalsubtitle: Textconstant.txt_5minperday,
                  ),

                  dailyGoalSelectionCard(
                    context: context,
                    iconBackgroundColor: ColorConstant.color_bluelight,
                    iconColor: ColorConstant.color_darkblueshade500,
                    icon: Icons.timer,
                    dailygoal: Textconstant.txt_regular,
                    dailygoalsubtitle: Textconstant.txt_10minperday,
                  ),

                  dailyGoalSelectionCard(
                    context: context,
                    iconBackgroundColor: ColorConstant.color_darkskin,
                    iconColor: ColorConstant.color_lightskin,
                    icon: Icons.trending_up,
                    dailygoal: Textconstant.txt_serious,
                    dailygoalsubtitle: Textconstant.txt_15minperday,
                  ),
                  dailyGoalSelectionCard(
                    context: context,
                    iconBackgroundColor: ColorConstant.color_red,
                    iconColor: ColorConstant.color_lightred,
                    icon: Icons.bolt,
                    dailygoal: Textconstant.txt_intense,
                    dailygoalsubtitle: Textconstant.txt_20minperday,
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

  Widget dailyGoalSelectionCard({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required Color iconBackgroundColor,
    required String dailygoal,
    required String dailygoalsubtitle,
  }) {
    // final onboard_Provider = context.watch<OnboardProvider>();
    // final isSelected = onboard_Provider.selectedlanguage == language;
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: GestureDetector(
        onTap: () {
          context.read<OnboardProvider>().setDailyGoal(dailygoal);
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
                  borderRadius: BorderRadius.circular(30),
                ),
                height: 60,
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
                      dailygoal,
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    SizedBox(height: 10),

                    Text(
                      dailygoalsubtitle,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
              ),
              Radio(value: dailygoal),
            ],
          ),
        ),
      ),
    );
  }
}
