import 'package:chatbot_app/core/extensions/localization_extension.dart';
import 'package:chatbot_app/core/extensions/theme_extension.dart';
import 'package:chatbot_app/core/widgets/app_button.dart';
import 'package:chatbot_app/core/widgets/app_screen.dart';
import 'package:chatbot_app/modules/auth/screen/loginscreen.dart';
import 'package:chatbot_app/modules/onboarding/model/get_started_model.dart';
import 'package:chatbot_app/modules/onboarding/provider/getStarted_provider.dart';
import 'package:chatbot_app/modules/splashScreen/screen/ambient_background.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter/material.dart';

class Getstarted extends StatefulWidget {
  const Getstarted({super.key});

  @override
  State<Getstarted> createState() => _GetstartedState();
}

class _GetstartedState extends State<Getstarted> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GetstartedProvider>();
    return AppScreen(
      bottomNavigation: Padding(
        padding: EdgeInsets.only(bottom: 20.r, left: 10.r, right: 10.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppButton(
              width: MediaQuery.widthOf(context),
              buttonFunc: () {
                if (provider.currentindex != 2) {
                  provider.pageController.nextPage(
                    duration: Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                  );
                } else {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Loginscreen()),
                  );
                }
              },
              childWidget: Text(
                provider.currentindex != 2
                    ? context.l10n.next
                    : context.l10n.getStarted,
                style: context.text.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
      body: AmbientBackground(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 40.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Loginscreen()),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.all(8.r),
                    child: Text(
                      context.l10n.skip,
                      style: context.text.headlineSmall?.copyWith(
                        color: context.theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 20.h),
            Expanded(
              child: PageView.builder(
                controller: provider.pageController,
                itemCount: provider.getStartedList(context).length,
                itemBuilder: (context, index) {
                  final GetStartedModel item = provider.getStartedList(
                    context,
                  )[index];
                  return Column(
                    children: [
                      SizedBox(
                        height: 350.h,
                        child: Image.asset(item.imagePath, fit: BoxFit.contain),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.r),
                        child: Text(
                          textAlign: TextAlign.center,
                          item.title,
                          style: context.text.displayLarge,
                        ),
                      ),

                      SizedBox(height: 20.h),

                      Padding(
                        padding: EdgeInsets.all(8.r),
                        child: Text(
                          item.subtitle,
                          textAlign: TextAlign.center,
                          style: context.text.headlineSmall?.copyWith(
                            color: context.theme.colorScheme.outline,
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                    ],
                  );
                },
                onPageChanged: (value) => provider.onPageChanged(value),
              ),
            ),

            Center(
              child: AnimatedSmoothIndicator(
                activeIndex: provider.currentindex,
                count: 3,
                effect: WormEffect(
                  activeDotColor: context.theme.colorScheme.primary,
                  dotColor: context.theme.colorScheme.outline,
                ),
              ),
            ),

            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }
}
