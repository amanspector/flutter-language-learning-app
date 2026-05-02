import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chatbot_app/appconstants/color_constant.dart';
import 'package:chatbot_app/appconstants/text_constant.dart';
import 'package:chatbot_app/provider/onboard_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Languageselection extends StatelessWidget {
  Languageselection({super.key});

  @override
  Widget build(BuildContext context) {
    final onboard_Provider = context.watch<OnboardProvider>();
    return Padding(
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
                    Textconstant.txt_whatdoyouwanttolearn,
                    speed: Duration(milliseconds: 40),
                    textStyle: Theme.of(context).textTheme.displayLarge,
                  ),
                ],
              ),
            ),
          ),

          Text(
            Textconstant.txt_chooselanguage,
            style: Theme.of(context).textTheme.displaySmall,
          ),

          RadioGroup(
            onChanged: (value) {
              if (onboard_Provider.selectedlanguage == null) {
                onboard_Provider.setSelectedLanguage(value!);
              }
            },
            groupValue: onboard_Provider.selectedlanguage,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                languageCard(
                  context: context,
                  imgurl: "assets/icon/icon_uk_flag.png",
                  language: "English",
                ),

                languageCard(
                  context: context,
                  imgurl: "assets/icon/icon_india_flag.png",
                  language: "Hindi",
                ),
                languageCard(
                  context: context,
                  imgurl: "assets/icon/icon_spain_flag.png",
                  language: "Spanish",
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
    );
  }

  static Widget languageCard({
    required BuildContext context,
    required String imgurl,
    required String language,
  }) {
    final onboard_Provider = context.watch<OnboardProvider>();
    final isSelected = onboard_Provider.selectedlanguage == language;
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: GestureDetector(
        onTap: () {
          context.read<OnboardProvider>().setSelectedLanguage(language);
        },
        child: Container(
          height: 100,
          width: MediaQuery.widthOf(context),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: isSelected
                ? ColorConstant.color_blueDark_shade
                : ColorConstant.color_white_withalpha30,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: CircleAvatar(
                  foregroundImage: AssetImage(imgurl),
                  maxRadius: 30,
                  // child: Image.asset("assets/icon/icon_Ukflag.png"),
                ),
              ),

              Expanded(
                child: Text(
                  language,
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Radio(value: language),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
