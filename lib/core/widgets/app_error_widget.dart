import 'package:chatbot_app/core/extensions/theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppErrorwidget {
  Widget showError(String error, BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 15.r, vertical: 5.r),
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(
          context.theme.colorScheme.error,
          BlendMode.srcIn,
        ),
        child: Text(
          error,
          style: context.text.bodyMedium?.copyWith(
            color: context.theme.colorScheme.error,
            fontSize: 15.sp,
          ),
        ),
      ),
    );
  }
}
