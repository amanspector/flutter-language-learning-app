import 'package:chatbot_app/appconstants/color_constant.dart';
import 'package:chatbot_app/appconstants/text_constant.dart';
import 'package:chatbot_app/provider/onboard_provider.dart';
import 'package:chatbot_app/provider/vocab_provider.dart';
import 'package:chatbot_app/screens/onboarding/dailyGoal.dart';
import 'package:chatbot_app/screens/onboarding/experienceLevel.dart';
import 'package:chatbot_app/screens/onboarding/goalSelection.dart';
import 'package:chatbot_app/screens/onboarding/languageSelection.dart';
import 'package:chatbot_app/screens/vocabscreen.dart';
import 'package:chiclet/chiclet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainOnboarding extends StatelessWidget {
  const MainOnboarding({super.key});
  @override
  Widget build(BuildContext context) {
    final onboard_Provider = context.watch<OnboardProvider>();
    final PageController _pagecontroller = PageController();

    final onbordingpages = [
      Languageselection(),
      Goalselection(),
      Dailygoal(),
      Experiencelevel(),
    ];

    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConstant.color_darkblueshade500,
        appBar: AppBar(
          bottom: PreferredSize(
            preferredSize: Size(20, 10),
            child: TweenAnimationBuilder(
              builder: (context, value, child) =>
                  LinearProgressIndicator(value: value),
              tween: Tween(end: (onboard_Provider.currentPage + 1) / 4),
              duration: Duration(milliseconds: 300),
              // child:
            ),
          ),
          backgroundColor: ColorConstant.color_blueDark_shade,
          surfaceTintColor: ColorConstant.color_transparent,
          title: Center(
            child: Text(
              "STEPS ${onboard_Provider.currentPage + 1} OF 4",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          actions: [
            IconButton(
              disabledColor: ColorConstant.color_transparent,
              highlightColor: ColorConstant.color_transparent,
              onPressed: () {},
              icon: Icon(Icons.close),
            ),
          ],
          leading: IconButton(
            onPressed: () {
              if (_pagecontroller.page != 0) {
                _pagecontroller.previousPage(
                  duration: Duration(milliseconds: 30),
                  curve: Curves.easeInOut,
                );
              }
            },
            icon: Icon(Icons.arrow_back_outlined),
          ),
        ),
        body: PageView.builder(
          physics: NeverScrollableScrollPhysics(),
          onPageChanged: onboard_Provider.setCurrentPageIndex,
          itemCount: onbordingpages.length,
          itemBuilder: (context, index) {
            return onbordingpages[index];
          },
          controller: _pagecontroller,
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: ChicletOutlinedAnimatedButton(
            width: MediaQuery.widthOf(context),
            borderColor: ColorConstant.color_blue,
            buttonColor: ColorConstant.color_bluelight,
            backgroundColor: ColorConstant.color_blue,
            onPressed: () async {
              onboard_Provider.validate(onboard_Provider.currentPage);
              if (onboard_Provider.error_message != null) return;

              final isLastPage =
                  onboard_Provider.currentPage == onbordingpages.length - 1;

              if (isLastPage) {
                final vocabProvider = context.read<VocabProvider>();

                print(onboard_Provider.selectedlanguage);
                print(onboard_Provider.selectedExperienceLevel);
                print(onboard_Provider.selectedgoal);

                await vocabProvider.loadWords(
                  langauage: onboard_Provider.selectedlanguage!,
                  experienceLevel: onboard_Provider.selectedExperienceLevel!,
                  category: onboard_Provider.selectedgoal!,
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VocabScreen()),
                );
              } else {
                _pagecontroller.nextPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }

              // if (onboard_Provider.selectedlanguage == null) {
              //   onboard_Provider.validateLanguage();
              //   return;
              // }
            },
            buttonType: ChicletButtonTypes.roundedRectangle,
            child: Text(
              Textconstant.txt_continue,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
        ),
      ),
    );
  }
}
