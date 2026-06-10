import 'package:chatbot_app/core/appconstants/color_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppErrorwidget {
  Widget showError(String error, BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 15.r, vertical: 5.r),
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(ColorConstant.colorRed, BlendMode.srcIn),
        child: Text(
          error,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.error,
            fontSize: 15.sp,
          ),
        ),
      ),
    );
  }
}
