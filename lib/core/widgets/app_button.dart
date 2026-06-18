import 'dart:async';

import 'package:chatbot_app/core/extensions/theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AppButton extends StatefulWidget {
  final FutureOr<void> Function() buttonFunc;
  final Widget childWidget;
  final Color? buttonColor;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? width;
  final double? height;
  final bool isLoading;
  final bool isEnabled;

  const AppButton({
    super.key,
    required this.buttonFunc,
    required this.childWidget,
    this.backgroundColor,
    this.borderColor,
    this.buttonColor,
    this.width,
    this.height,
    this.isLoading = false,
    this.isEnabled = true,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _isPressed = false;

  void _onTapDown(_) {
    if (widget.isEnabled && !widget.isLoading) {
      setState(() => _isPressed = true);
    }
  }

  void _onTapUp(_) {
    if (widget.isEnabled && !widget.isLoading) {
      setState(() => _isPressed = false);
    }
  }

  void _onTapCancel() {
    if (widget.isEnabled && !widget.isLoading) {
      setState(() => _isPressed = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = !widget.isEnabled
        ? context.theme.colorScheme.outline.withValues(alpha: 0.4)
        : widget.backgroundColor ?? context.theme.colorScheme.primary;

    final shadowColor =
        (widget.buttonColor ?? context.theme.colorScheme.onPrimaryContainer);

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: (!widget.isEnabled || widget.isLoading)
          ? null
          : () async {
              await widget.buttonFunc(); // 👈 await it
            },
      // (!widget.isEnabled || widget.isLoading) ? null : await widget.buttonFunc,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        transform: Matrix4.translationValues(0, _isPressed ? 4 : 0, 0),
        height: widget.height?.h ?? 52.h,
        width: widget.width?.w ?? double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: widget.borderColor ?? context.theme.colorScheme.primary,
            width: 2,
          ),
          boxShadow: _isPressed
              ? []
              : [
                  BoxShadow(
                    color: shadowColor,
                    offset: const Offset(0, 4),
                    blurRadius: 0,
                  ),
                ],
        ),
        child: widget.isLoading
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  LoadingAnimationWidget.fourRotatingDots(
                    size: 22.r,
                    color: context.theme.colorScheme.surface,
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    'Please wait...',
                    style: context.text.labelMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              )
            : widget.childWidget,
      ),
    );
  }
}
