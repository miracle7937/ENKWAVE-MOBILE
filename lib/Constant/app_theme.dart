import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/UILayer/utils/primary_swatch_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTheme {
  static const Color _lightSurface = Color(0xFFFAF5FF);
  static const Color _darkSurface = Color(0xFF120A1C);
  static const Color _darkCard = Color(0xFF1C1228);

  static ThemeData light() => _build(Brightness.light);
  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final primary = EPColors.appMainColor;
    final scheme = ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: Colors.white,
      secondary: EPColors.appMainLightColor,
      onSecondary: Colors.white,
      tertiary: EPColors.appAccentStrong,
      surface: isDark ? _darkSurface : _lightSurface,
      onSurface: isDark ? const Color(0xFFF3E8FF) : EPColors.appBlackColor,
      error: EPColors.appDanger,
      onError: Colors.white,
    );

    final darkInputFill = const Color(0xFF120A1C);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      fontFamily: 'Effra',
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      cardColor: isDark ? _darkCard : EPColors.appCard,
      dividerColor:
          isDark ? const Color(0xFF3B2660) : EPColors.appBorder,
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? EPColors.appMainDark : primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: isDark ? _darkCard : EPColors.appCard,
        surfaceTintColor: Colors.transparent,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: isDark ? _darkCard : EPColors.appCard,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: isDark ? _darkCard : EPColors.appCard,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark ? _darkCard : EPColors.appBlackColor,
        contentTextStyle: TextStyle(color: scheme.onSurface),
      ),
      listTileTheme: ListTileThemeData(
        tileColor: isDark ? _darkCard : null,
        iconColor: scheme.onSurface,
        textColor: scheme.onSurface,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? darkInputFill : EPColors.appSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? const Color(0xFF3B2660) : EPColors.appBorder,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? const Color(0xFF3B2660) : EPColors.appBorder,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primary, width: 1.5),
        ),
        hintStyle: TextStyle(
          color: isDark ? const Color(0xFFA78BFA) : EPColors.appMuted,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) {
              return EPColors.appMainDark;
            }
            return primary;
          }),
          foregroundColor: const WidgetStatePropertyAll(Colors.white),
        ),
      ),
      primarySwatch: PrimarySwatchColor.get(),
      textTheme: _textTheme(scheme.onSurface),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }

  static TextTheme _textTheme(Color onSurface) {
    return TextTheme(
      displayLarge: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 14.sp, color: onSurface),
      displayMedium: TextStyle(
          fontWeight: FontWeight.w700, fontSize: 26.sp, color: onSurface),
      displaySmall: TextStyle(
          fontSize: 12.sp, fontWeight: FontWeight.bold, color: onSurface),
      headlineSmall: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 10.sp, color: onSurface),
      titleLarge: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 18.sp, color: onSurface),
      titleMedium: TextStyle(
          fontSize: 16.sp, fontWeight: FontWeight.bold, color: onSurface),
      titleSmall: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 20.sp, color: onSurface),
      labelMedium: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 7.sp, color: onSurface),
      bodyMedium: TextStyle(fontSize: 16.sp, color: onSurface),
      bodyLarge: TextStyle(fontSize: 12.sp, color: onSurface),
      bodySmall: TextStyle(fontSize: 12.sp, color: onSurface),
      labelSmall: TextStyle(fontSize: 11.sp, color: onSurface),
      labelLarge: TextStyle(fontSize: 14, color: onSurface),
    );
  }
}

extension AppThemeColors on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  Color get cardFill => isDarkMode ? const Color(0xFF1C1228) : EPColors.appCard;

  /// Scaffold / screen background — never white in dark mode.
  Color get surfaceFill =>
      isDarkMode ? const Color(0xFF120A1C) : EPColors.appSurface;

  Color get inputFill =>
      isDarkMode ? const Color(0xFF120A1C) : EPColors.appSurface;

  Color get borderColor =>
      isDarkMode ? const Color(0xFF3B2660) : EPColors.appBorder;

  Color get mutedText =>
      isDarkMode ? const Color(0xFFA78BFA) : EPColors.appMuted;

  Color get primaryText =>
      isDarkMode ? const Color(0xFFF3E8FF) : EPColors.appBlackColor;
}
