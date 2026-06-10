import 'package:chatbot_app/core/appconstants/color_constant.dart';
import 'package:chatbot_app/core/appconstants/text_constant.dart';
import 'package:chatbot_app/generated/l10n.dart';
import 'package:chatbot_app/modules/splashScreen/screen/ambient_background.dart';
import 'package:flutter/services.dart';
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
  late final AnimationController _progressController;
  late final AnimationController _entryController;
  late final Animation<double> _logoScale;
  late final Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _initializeAppData();
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _logoScale = CurvedAnimation(
      parent: _entryController,
      curve: Curves.easeOutBack,
    );
    _fadeIn = CurvedAnimation(
      parent: _entryController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
    );
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 3000,
      ), // Matched to your initialization delay
    );
    _entryController.forward();
    _progressController.forward();
  }

  @override
  void dispose() {
    _entryController.dispose();
    _progressController.dispose();
    super.dispose();
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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => Homescreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => MainOnboarding()),
        );
      }
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
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: ColorConstant.colorTransparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: AmbientBackground(
          child: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(flex: 3),
                  ScaleTransition(
                    scale: Tween<double>(
                      begin: 0.85,
                      end: 1.0,
                    ).animate(_logoScale),
                    child: const _LogoCard(
                      imagePath: 'assets/icon/appicon_1.png',
                    ),
                  ),

                  FadeTransition(
                    opacity: _fadeIn,
                    child: Text(
                      S.of(context).appName,
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                  ),

                  FadeTransition(
                    opacity: _fadeIn,
                    child: Text(
                      S.of(context).appNameSubtitle,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: Theme.of(
                              context,
                            ).colorScheme.onPrimaryContainer,
                          ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  FadeTransition(
                    opacity: _fadeIn,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 64),
                          child: AnimatedBuilder(
                            animation: _progressController,
                            builder: (context, _) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0,
                                ),
                                child: LinearProgressIndicator(
                                  borderRadius: BorderRadius.circular(20),
                                  minHeight: 8,
                                  value: _progressController.value,
                                  backgroundColor: ColorConstant.lightgreen,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          Textconstant.syncingProgress,
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 320),
                ],
              ),
            ),
          ),
        ),
      ),
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
        color: ColorConstant.colorWhite.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: ColorConstant.colorWhite.withValues(alpha: 0.08),
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
