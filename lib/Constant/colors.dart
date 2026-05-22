import 'dart:math';

import 'package:flutter/material.dart';

export 'text_theme_compat.dart';

/// Leon purple brand palette.
class EPColors {
  static Color appMainColor = const Color(0xFF6B21A8);
  static Color appMainLightColor = const Color(0xFF9333EA);
  static Color appMainDark = const Color(0xFF4C1D95);
  static Color appAccent = const Color(0xFFE9D5FF);
  static Color appAccentStrong = const Color(0xFFC084FC);
  static Color appSurface = const Color(0xFFFAF5FF);
  static Color appCard = Colors.white;
  static Color appGreyColor = const Color(0xFF6B7280);
  static Color appMuted = const Color(0xFF9CA3AF);
  static Color appWhiteColor = Colors.white;
  static Color appBlackColor = const Color(0xFF1E1033);
  static Color appBorder = const Color(0xFFE9D5FF);
  static Color appSuccess = const Color(0xFF059669);
  static Color appWarning = const Color(0xFFB45309);
  static Color appDanger = const Color(0xFFDC2626);

  // bill color
  static Color mtnColor = const Color(0XFFe6d305);
  static Color gloColor = const Color(0XFF65ff24);
  static Color airtelColor = const Color(0XFFd91c1c);
  static Color i9mobile = const Color(0XFF000000);
  static Color dsTv = const Color(0XFF03a5fc);

  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: appMainColor.withValues(alpha: 0.12),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  static Color generateRandomColor() {
    Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }
}
