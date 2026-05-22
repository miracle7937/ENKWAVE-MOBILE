import 'package:enk_pay_project/Constant/colors.dart';
import 'package:flutter/material.dart';

class PrimarySwatchColor {
  static MaterialColor get() {
    return MaterialColor(
      0xFF6B21A8,
      <int, Color>{
        50: const Color(0xFFFAF5FF),
        100: const Color(0xFFF3E8FF),
        200: const Color(0xFFE9D5FF),
        300: const Color(0xFFD8B4FE),
        400: const Color(0xFFC084FC),
        500: EPColors.appMainLightColor,
        600: const Color(0xFF7E22CE),
        700: EPColors.appMainColor,
        800: EPColors.appMainDark,
        900: const Color(0xFF3B0764),
      },
    );
  }
}
