import 'package:flutter/material.dart';

class ColorConstant {
  static Color color_bluelight = const Color(0xFF60A5FA);
  // Color(0xffAECADE)
  // static Color color_bluelight = Color(0xff2F4A5A);
  static Color color_blueDark = const Color(0xFF2563EB);
  static Color color_blue = const Color(0xFF93C5FD);
  static Color color_black = Colors.black;
  static Color color_transparent = Colors.transparent;
  static Color color_white = Colors.white;
  static Color color_darkblueshade500 = Color(0xff010A1B);
  static Color color_bluegrey = Color(0xff94A3B8);
  // static Color color_darkblueshade200 = Color(0xff090F1F);
  static Color color_red = Colors.red;
  static Color color_lightgreen = Color(0xffB3CDB7);
  static Color color_darkgreen = Color(0xff354C3B);
  static Color color_lightskin = Color(0xffCBC6BD);
  static Color color_darkskin = Color(0xff494640);
  static Color color_lightred = Color(0xffFFB4AB);
  // static Color color_lightred = Color(0xffFFB4AB);

  static Color color_white_withalpha30 = color_white.withAlpha(30);
  static Color color_darkblueshade150 = Color(
    0xff202C45,
  ).withValues(alpha: 0.2);

  static final Color color_bluelight_shade = color_bluelight.withValues(
    alpha: 0.25,
  );

  static final Color color_blueDark_shade = color_blueDark.withValues(
    alpha: 0.20,
  );

  static final Color color_blue_shade = color_blue.withValues(alpha: 0.15);
}
