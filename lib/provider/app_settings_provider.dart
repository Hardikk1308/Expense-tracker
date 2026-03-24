import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeModeOption { light, dark, system }

class AppSettingsProvider with ChangeNotifier {
  ThemeModeOption _themeMode = ThemeModeOption.system;
  Locale _locale = const Locale('en');

  ThemeModeOption get themeModeOption => _themeMode;
  Locale get locale => _locale;

  ThemeMode get themeMode {
    switch (_themeMode) {
      case ThemeModeOption.light: return ThemeMode.light;
      case ThemeModeOption.dark: return ThemeMode.dark;
      case ThemeModeOption.system: return ThemeMode.system;
    }
  }

  AppSettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load Theme
    final themeIndex = prefs.getInt('theme_mode') ?? 2; // Default to system
    _themeMode = ThemeModeOption.values[themeIndex];
    
    // Load Locale
    final languageCode = prefs.getString('language_code') ?? 'en';
    _locale = Locale(languageCode);
    
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeModeOption mode) async {
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('theme_mode', mode.index);
    notifyListeners();
  }

  Future<void> setLocale(String languageCode) async {
    _locale = Locale(languageCode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', languageCode);
    notifyListeners();
  }
}
