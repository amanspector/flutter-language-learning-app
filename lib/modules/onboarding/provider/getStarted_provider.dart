import 'package:chatbot_app/core/extensions/localization_extension.dart';
import 'package:chatbot_app/modules/onboarding/model/get_started_model.dart';
import 'package:flutter/material.dart';

class GetstartedProvider extends ChangeNotifier {
  PageController pageController = PageController();
  int currentindex = 0;

  // List<GetStartedModel> getStartedList(BuildContext context){

  //   return
  // }

  List<GetStartedModel> getStartedList(BuildContext context) {
    return [
      GetStartedModel(
        imagePath: 'assets/images/master_any_lang.png',
        title: context.l10n.masterAnyLang,
        subtitle: context.l10n.onboardSubtitle1,
      ),
      GetStartedModel(
        imagePath: 'assets/images/chat_naturally.png',
        title: context.l10n.learnAnytime,
        subtitle: context.l10n.onboardSubtitle2,
      ),
      GetStartedModel(
        imagePath: 'assets/images/track_progress.png',
        title: context.l10n.unlockYourPotential,
        subtitle: context.l10n.onboardSubtitle3,
      ),
    ];
  }

  void onPageChanged(int index) {
    currentindex = index;
    notifyListeners();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
