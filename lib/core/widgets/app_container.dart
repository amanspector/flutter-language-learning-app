import 'package:chatbot_app/core/extensions/theme_extension.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AppContainer extends StatelessWidget {
  double? height;
  double? width;
  Widget widget;
  Color? backgroundColor;
  double? borderRadius;
  EdgeInsetsGeometry? margin;
  EdgeInsetsGeometry? padding;
  Color? borderColor;
  AppContainer({
    super.key,
    this.height,
    this.width,
    required this.widget,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.margin,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        border: Border.all(
          color:
              borderColor ??
              context.theme.colorScheme.surface.withValues(alpha: 0.4),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(borderRadius ?? 20),
        color:
            backgroundColor ??
            context.theme.colorScheme.surface.withValues(alpha: 0.3),
      ),
      width: width,
      child: widget,
    );
  }
}
