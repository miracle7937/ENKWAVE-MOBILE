import 'package:flutter/material.dart';

/// Restores pre-Material-3 [TextTheme] names used across this app.
extension LegacyTextTheme on TextTheme {
  TextStyle? get headline1 => displayLarge;
  TextStyle? get headline2 => displayMedium;
  TextStyle? get headline3 => displaySmall;
  TextStyle? get headline4 => headlineSmall;
  TextStyle? get headline5 => titleLarge;
  TextStyle? get headline6 => titleMedium;
  TextStyle? get subtitle1 => titleSmall;
  TextStyle? get subtitle2 => labelMedium;
  TextStyle? get bodyText1 => bodyLarge;
  TextStyle? get bodyText2 => bodyMedium;
  TextStyle? get caption => bodySmall;
  TextStyle? get overline => labelSmall;
  TextStyle? get button => labelLarge;
}
