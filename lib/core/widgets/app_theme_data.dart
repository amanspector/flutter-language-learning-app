import 'package:chatbot_app/core/appconstants/color_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppThemedata {
  static ThemeData lightThemeData = ThemeData(
    // ─── Color Scheme ───────────────────────────────────────────
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: ColorConstant.colorGreen, // #58CC02
      onPrimary: ColorConstant.colorWhite, // text/icon on primary
      primaryContainer: ColorConstant.colorLightgreen, // #DDE5D2
      onPrimaryContainer: ColorConstant.forestGreen,
      secondary: ColorConstant.darkgreen, // #2AB572
      onSecondary: ColorConstant.colorWhite,
      secondaryContainer: ColorConstant.splashBg, // #CCFFA7
      onSecondaryContainer: ColorConstant.forestGreen,
      error: ColorConstant.colorRed,
      onError: ColorConstant.colorWhite,
      surface: ColorConstant.colorWhite,
      onSurface: ColorConstant.colorBlack,
      outline: ColorConstant.grey,
      shadow: ColorConstant.colorBlack26,
      onPrimaryFixed: ColorConstant.colorOrange,
    ),

    // ─── Scaffold ────────────────────────────────────────────────

    // ─── AppBar ──────────────────────────────────────────────────
    // appBarTheme: AppBarTheme(
    //   backgroundColor: ColorConstant.color_white,
    //   foregroundColor: ColorConstant.color_black,
    //   surfaceTintColor: ColorConstant.color_transparent,
    //   elevation: 0,
    //   centerTitle: true,
    //   titleTextStyle: TextStyle(
    //     fontSize: 18.sp,
    //     fontWeight: FontWeight.w700,
    //     color: ColorConstant.color_black,
    //   ),
    //   iconTheme: IconThemeData(color: ColorConstant.color_black),
    // ),

    // ─── Text Theme ──────────────────────────────────────────────
    textTheme: TextTheme(
      // headlines
      displayLarge: TextStyle(
        fontSize: 40.sp,
        fontWeight: FontWeight.w800,
        color: ColorConstant.splashTextDark, // #101418
      ),
      displayMedium: TextStyle(
        fontSize: 32.sp,
        fontWeight: FontWeight.w700,
        color: ColorConstant.splashTextDark,
      ),

      //used
      displaySmall: TextStyle(
        fontSize: 24.sp,
        fontWeight: FontWeight.w700,
        color: ColorConstant.splashTextDark,
      ),

      headlineLarge: TextStyle(
        fontSize: 22.sp,
        fontWeight: FontWeight.w700,
        color: ColorConstant.colorBlack,
      ),
      headlineMedium: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        color: ColorConstant.colorBlack,
      ),
      headlineSmall: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w500,
        color: ColorConstant.colorBlack,
      ),

      // body
      bodyLarge: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        color: ColorConstant.colorBlack,
      ),
      bodyMedium: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: ColorConstant.splashTextSubtitle, // #1F2937
      ),
      bodySmall: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        color: ColorConstant.grey, // #64748B
      ),

      // label (buttons)
      labelLarge: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w700,
        color: ColorConstant.colorWhite,
      ),
      labelMedium: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: ColorConstant.colorWhite,
      ),
      labelSmall: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
        color: ColorConstant.grey,
      ),

      // title
      titleLarge: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.w700,
        color: ColorConstant.colorBlack,
      ),

      //used
      titleMedium: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: ColorConstant.colorBlack,
      ),
      titleSmall: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: ColorConstant.grey,
      ),
    ),

    // ─── ElevatedButton ──────────────────────────────────────────
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorConstant.colorGreen,
        foregroundColor: ColorConstant.colorWhite,
        minimumSize: Size(double.infinity, 52.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        textStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
        elevation: 0,
      ),
    ),

    // ─── OutlinedButton ──────────────────────────────────────────
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: ColorConstant.colorGreen,
        side: BorderSide(color: ColorConstant.colorGreen, width: 1.5),
        minimumSize: Size(double.infinity, 52.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        textStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
      ),
    ),

    // ─── TextButton ──────────────────────────────────────────────
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: ColorConstant.forestGreen,
        textStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
      ),
    ),

    // ─── InputDecoration ─────────────────────────────────────────
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: ColorConstant.splashBgFirst, // #F4FCE8
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: ColorConstant.splashProgressTrack),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: ColorConstant.splashProgressTrack),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: ColorConstant.colorGreen, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: ColorConstant.colorRed),
      ),
      hintStyle: TextStyle(fontSize: 14.sp, color: ColorConstant.grey),
      labelStyle: TextStyle(fontSize: 14.sp, color: ColorConstant.grey),
    ),

    // ─── Card ────────────────────────────────────────────────────
    cardTheme: CardThemeData(
      color: ColorConstant.splashBgFirst,
      surfaceTintColor: ColorConstant.colorTransparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: BorderSide(color: ColorConstant.splashProgressTrack),
      ),
      margin: EdgeInsets.zero,
    ),

    // ─── Chip ────────────────────────────────────────────────────
    chipTheme: ChipThemeData(
      backgroundColor: ColorConstant.colorLightgreen,
      labelStyle: TextStyle(
        fontSize: 13.sp,
        color: ColorConstant.forestGreen,
        fontWeight: FontWeight.w600,
      ),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
    ),

    // ─── Divider ─────────────────────────────────────────────────
    dividerTheme: DividerThemeData(
      color: ColorConstant.grey,
      thickness: 1,
      indent: 20,
      endIndent: 20,
      space: 0,
    ),

    // ─── ProgressIndicator ───────────────────────────────────────
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: ColorConstant.colorGreen,
      linearTrackColor: ColorConstant.splashProgressTrack,
      circularTrackColor: ColorConstant.splashProgressTrack,
    ),

    // ─── SnackBar ────────────────────────────────────────────────
    snackBarTheme: SnackBarThemeData(
      backgroundColor: ColorConstant.colorBlack,
      contentTextStyle: TextStyle(
        fontSize: 14.sp,
        color: ColorConstant.colorWhite,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      behavior: SnackBarBehavior.floating,
    ),

    // ─── BottomNavigationBar ─────────────────────────────────────
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: ColorConstant.colorWhite,
      selectedItemColor: ColorConstant.colorGreen,
      unselectedItemColor: ColorConstant.grey,
      selectedLabelStyle: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: TextStyle(fontSize: 12.sp),
      elevation: 0,
      type: BottomNavigationBarType.fixed,
    ),

    // ─── ListTile ────────────────────────────────────────────────
    listTileTheme: ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      titleTextStyle: TextStyle(
        fontSize: 15.sp,
        fontWeight: FontWeight.w600,
        color: ColorConstant.colorBlack,
      ),
      subtitleTextStyle: TextStyle(fontSize: 12.sp, color: ColorConstant.grey),
      iconColor: ColorConstant.colorGreen,
    ),

    // ─── Icon ────────────────────────────────────────────────────
    iconTheme: IconThemeData(color: ColorConstant.colorBlack, size: 24),
  );

  // ─── Dark Theme ──────────────────────────────────────────────
  static ThemeData darkThemeData = ThemeData(
    useMaterial3: true,

    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: ColorConstant.colorGreen,
      onPrimary: ColorConstant.colorWhite,
      primaryContainer: ColorConstant.forestGreen,
      onPrimaryContainer: ColorConstant.colorLightgreen,
      secondary: ColorConstant.darkgreen,
      onSecondary: ColorConstant.colorWhite,
      secondaryContainer: ColorConstant.colorDarkgreen,
      onSecondaryContainer: ColorConstant.lightgreen,
      onTertiary: ColorConstant.colorWhite,
      onTertiaryContainer: ColorConstant.colorWhite,
      error: ColorConstant.colorRed,
      onError: ColorConstant.colorWhite,
      errorContainer: ColorConstant.colorRedWithAlpha,
      onErrorContainer: ColorConstant.colorLightred,
      surface: ColorConstant.colorBlack, // #010A1B
      onSurface: ColorConstant.colorWhite,
      surfaceContainerHighest: Color(0xFF0D1B2E),
      onSurfaceVariant: ColorConstant.colorBluegrey,
      outline: ColorConstant.colorBluegrey,
      outlineVariant: ColorConstant.colorWhite.withValues(alpha: 30),
      shadow: ColorConstant.colorBlack26,
      scrim: ColorConstant.colorBlack26,
      inverseSurface: ColorConstant.colorWhite,
      onInverseSurface: ColorConstant.colorBlack,
      inversePrimary: ColorConstant.forestGreen,
    ),

    scaffoldBackgroundColor: ColorConstant.colorTransparent,

    appBarTheme: AppBarTheme(
      backgroundColor: ColorConstant.colorBlack,
      foregroundColor: ColorConstant.colorWhite,
      surfaceTintColor: ColorConstant.colorTransparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w700,
        color: ColorConstant.colorWhite,
      ),
      iconTheme: IconThemeData(color: ColorConstant.colorWhite),
    ),

    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontSize: 40.sp,
        fontWeight: FontWeight.w800,
        color: ColorConstant.colorWhite,
      ),
      displayMedium: TextStyle(
        fontSize: 32.sp,
        fontWeight: FontWeight.w700,
        color: ColorConstant.colorWhite,
      ),
      displaySmall: TextStyle(
        fontSize: 24.sp,
        fontWeight: FontWeight.w700,
        color: ColorConstant.colorWhite,
      ),
      headlineLarge: TextStyle(
        fontSize: 22.sp,
        fontWeight: FontWeight.w700,
        color: ColorConstant.colorWhite,
      ),
      headlineMedium: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        color: ColorConstant.colorWhite,
      ),
      headlineSmall: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: ColorConstant.colorWhite,
      ),
      bodyLarge: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        color: ColorConstant.colorWhite,
      ),
      bodyMedium: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: ColorConstant.colorWhite70,
      ),
      bodySmall: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        color: ColorConstant.colorBluegrey,
      ),
      labelLarge: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w700,
        color: ColorConstant.colorWhite,
      ),
      labelMedium: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: ColorConstant.colorWhite,
      ),
      labelSmall: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
        color: ColorConstant.colorBluegrey,
      ),
      titleLarge: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.w700,
        color: ColorConstant.colorWhite,
      ),
      titleMedium: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: ColorConstant.colorWhite,
      ),
      titleSmall: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: ColorConstant.colorBluegrey,
      ),
    ),

    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: ColorConstant.colorGreen,
      linearTrackColor: ColorConstant.colorWhite.withValues(alpha: 30),
      circularTrackColor: ColorConstant.colorWhite.withValues(alpha: 30),
    ),

    snackBarTheme: SnackBarThemeData(
      backgroundColor: Color(0xFF0D1B2E),
      contentTextStyle: TextStyle(
        fontSize: 14.sp,
        color: ColorConstant.colorWhite,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      behavior: SnackBarBehavior.floating,
    ),

    dividerTheme: DividerThemeData(
      color: ColorConstant.colorRed700.withValues(alpha: 0.2),
      thickness: 1,
      space: 0,
    ),

    iconTheme: IconThemeData(color: ColorConstant.colorWhite, size: 24),
  );
}
