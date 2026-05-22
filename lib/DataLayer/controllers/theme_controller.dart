import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Constant/string_values.dart';

class ThemeController extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  ThemeController() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(ConstantString.themeModeKey);
    if (stored == 'light') {
      _themeMode = ThemeMode.light;
    } else if (stored == 'dark') {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.system;
    }
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(ConstantString.themeModeKey, mode.name);
  }

  Future<void> toggleDarkLight() async {
    final isDark = _themeMode == ThemeMode.dark;
    await setThemeMode(isDark ? ThemeMode.light : ThemeMode.dark);
  }

  bool get isDarkEnabled => _themeMode == ThemeMode.dark;
}
