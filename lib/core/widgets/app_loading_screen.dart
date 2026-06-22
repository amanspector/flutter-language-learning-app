import 'dart:async';
import 'package:chatbot_app/core/extensions/localization_extension.dart';
import 'package:chatbot_app/core/extensions/theme_extension.dart';
import 'package:chatbot_app/core/widgets/app_button.dart';
import 'package:chatbot_app/core/widgets/app_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AppLoadingScreen extends StatefulWidget {
  final VoidCallback? onRetry;
  final bool generationFailed;
  final String? message;

  const AppLoadingScreen({
    super.key,
    this.onRetry,
    this.generationFailed = false,
    this.message,
  });

  @override
  State<AppLoadingScreen> createState() => _AppLoadingScreenState();
}

class _AppLoadingScreenState extends State<AppLoadingScreen> {
  late Timer _timer;
  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        //   _tipIndex = (_tipIndex + 1) % _loadingTips.length;
      });
    });
  }

  @override
  void didUpdateWidget(AppLoadingScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.generationFailed && _timer.isActive) {
      _timer.cancel();
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Center(
                child: Container(
                  color: Colors.transparent,
                  child: Lottie.asset('assets/lottie/cat.json'),
                ),
              ),

              const Spacer(),
              if (widget.generationFailed) ...[
                Text(
                  context.l10n.generationFailedPleaseRetry,
                  style: context.text.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                AppButton(
                  buttonFunc: widget.onRetry ?? () {},
                  childWidget: Text(context.l10n.retry),
                ),
              ] else ...[
                // your existing LOADING... text and AnimatedSwitcher tips
                Text(
                  widget.message ?? "LOADING...",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                  ),
                ),

                // Smooth switching for tips
                // SizedBox(
                //   height: 80,
                //   child: AnimatedSwitcher(
                //     duration: const Duration(milliseconds: 500),
                //     child: Text(
                //       _loadingTips[_tipIndex],
                //       key: ValueKey<int>(_tipIndex),
                //       textAlign: TextAlign.center,
                //       style: const TextStyle(
                //         fontSize: 16,
                //         fontWeight: FontWeight.w500,
                //         color: Colors.grey,
                //       ),
                //     ),
                //   ),
                // ),
              ],
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
