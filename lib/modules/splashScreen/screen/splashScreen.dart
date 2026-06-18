import 'dart:developer';

import 'package:chatbot_app/core/extensions/localization_extension.dart';
import 'package:chatbot_app/core/extensions/theme_extension.dart';
import 'package:chatbot_app/core/extensions/app_animation_extension.dart';
import 'package:chatbot_app/core/widgets/app_screen.dart';
import 'package:chatbot_app/generated/l10n.dart';
import '../service/sessionManage.dart';
import 'package:chatbot_app/modules/homepage/screen/homescreen.dart';
import '../../onboarding/screen/getStarted.dart';
import '../../onboarding/screen/main_onboarding.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _initializeAppData();
  }

  Future<void> _initializeAppData() async {
    await Future.delayed(const Duration(milliseconds: 2500));
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      if (!mounted) return;
      bool isReadyForHome = await Sessionmanage.loadAndInitializeUser(
        context,
        currentUser.uid,
      );
      if (!mounted) return;

      if (isReadyForHome) {
        log("going to homescreen");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => Homescreen()),
        );
        log("reached to homescreen");
      } else {
        log("going to mainonboarding");

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => MainOnboarding()),
        );
        log("reached to mainonboarding");
      }
      log("returned....");

      return;
    }

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const Getstarted()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _LogoCard(imagePath: 'assets/icon/appicon_1.png').blurIn,
            Text(
              S.of(context).appName,
              style: context.text.displayLarge,
              textAlign: TextAlign.center,
            ).fadeInScale,
            Text(
              context.l10n.appNameSubtitle,
              textAlign: TextAlign.center,
              style: context.text.headlineSmall?.copyWith(
                color: context.theme.colorScheme.onPrimaryContainer,
              ),
            ).fadeInScale,
            SizedBox(height: 20),
            Text(
              context.l10n.syncingProgress,
              // Textconstant.syncingProgress,
              style: context.text.labelMedium?.copyWith(
                color: context.theme.colorScheme.primary,
              ),
            ).fadeInScale,
          ],
        ),
      ),
      // ),
      // ),
    );
  }
}

class _LogoCard extends StatelessWidget {
  final String imagePath;
  const _LogoCard({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 132,
      width: 130,
      decoration: BoxDecoration(
        color: context.theme.colorScheme.surface.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: context.theme.colorScheme.surface.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      alignment: Alignment.center,
      child: Image.asset(
        imagePath,
        fit: BoxFit.contain,
        height: 130,
        width: 130,
      ),
    );
  }
}
