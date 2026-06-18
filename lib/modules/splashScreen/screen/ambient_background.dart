import 'package:chatbot_app/core/extensions/theme_extension.dart';
import 'package:flutter/material.dart';

class AmbientBackground extends StatelessWidget {
  final Widget child;

  const AmbientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.theme.colorScheme.secondaryContainer,
            context.theme.colorScheme.onPrimary,
          ], // Sharp split exactly in the middle
          stops: [0.1, 0.7],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: child,
    );
  }
}
