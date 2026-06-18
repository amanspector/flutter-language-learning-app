import 'package:chatbot_app/core/extensions/theme_extension.dart';
import 'package:chatbot_app/core/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppAlertdialog {
  static Future<bool?> showConfirmationDialog({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String message,
    required String cancelText,
    required String confirmText,
    Color? confirmBgColor,
    Color? confirmButtonColor,
    Color? confirmBorderColor,
    double iconSize = 36,
  }) {
    return showDialog<bool>(
      context: context,
      barrierColor: context.theme.colorScheme.onSurface.withValues(alpha: 0.6),
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          decoration: BoxDecoration(
            color: context.theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: [
              BoxShadow(
                color: context.theme.colorScheme.onSurface.withValues(
                  alpha: 0.25,
                ),
                blurRadius: 30,
                spreadRadius: 0,
                offset: Offset(0, 10),
              ),
              BoxShadow(
                color: context.theme.colorScheme.primary.withValues(
                  alpha: 0.08,
                ),
                blurRadius: 20.r,
                spreadRadius: 0,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(24.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon badge
                Container(
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor, size: iconSize),
                ),
                SizedBox(height: 16.h),

                // Title
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: context.text.headlineMedium,
                ),
                SizedBox(height: 8.h),

                // Message
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: context.text.titleMedium?.copyWith(
                    color: context.theme.colorScheme.outline,
                  ),
                ),
                SizedBox(height: 10.h),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        child: AppButton(
                          buttonFunc: () => Navigator.pop(context, false),
                          borderColor: context.theme.colorScheme.outline
                              .withValues(alpha: 0.3),
                          buttonColor: context.theme.colorScheme.outline
                              .withValues(alpha: 0.3),

                          backgroundColor: context.theme.colorScheme.surface,
                          childWidget: Text(
                            cancelText,
                            style: context.text.titleMedium
                                ?.copyWith(
                                  color: context
                                      .theme
                                      .colorScheme
                                      .onPrimaryContainer,
                                ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        child: AppButton(
                          buttonFunc: () => Navigator.pop(context, true),
                          // borderColor: ,
                          backgroundColor: confirmBgColor ?? null,
                          buttonColor: confirmButtonColor ?? null,
                          borderColor: confirmBorderColor ?? null,

                          childWidget: Text(
                            confirmText,
                            style: context.text.titleMedium
                                ?.copyWith(
                                  color: context.theme.colorScheme.onPrimary,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
