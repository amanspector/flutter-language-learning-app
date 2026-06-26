import 'package:chatbot_app/core/extensions/localization_extension.dart';
import 'package:chatbot_app/core/extensions/theme_extension.dart';
import 'package:chatbot_app/core/widgets/app_button.dart';
import 'package:chatbot_app/core/widgets/app_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AppLoadingScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return AppScreen(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (generationFailed) ...[
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: context.colors.errorContainer.withValues(
                      alpha: 0.12,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.cloud_off_rounded,
                    color: context.colors.error,
                    size: 68,
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  "Connection Issue",
                  style: context.text.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.colors.error,
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    context.l10n.generationFailedPleaseRetry,
                    style: context.text.bodyMedium?.copyWith(
                      color: context.colors.onSurfaceVariant,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 36),
                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    buttonFunc: onRetry ?? () {},
                    childWidget: Text(
                      context.l10n.retry.toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
              ] else ...[
                const Spacer(flex: 3),
                Center(
                  child: SizedBox(
                    height: 250,
                    width: 250,
                    child: Lottie.asset(
                      'assets/lottie/LwLw1fHsnX.json',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const Spacer(flex: 2),
                Column(
                  children: [
                    Text(
                      message ?? context.l10n.generatingYourVocabulary,
                      style: context.text.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.colors.onSurface,
                        letterSpacing: 1.1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: 150,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          color: context.colors.primary,
                          backgroundColor: context.colors.primary.withValues(
                            alpha: 0.15,
                          ),
                          minHeight: 4,
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(flex: 3),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
