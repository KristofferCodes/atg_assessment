import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Initialize in main.dart');
});

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ThemeModeNotifier(prefs);
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  final SharedPreferences _prefs;

  ThemeModeNotifier(this._prefs)
      : super(
          _prefs.getString(AppConstants.themeKey) == 'dark'
              ? ThemeMode.dark
              : ThemeMode.light,
        );

  void setLight() {
    state = ThemeMode.light;
    _prefs.setString(AppConstants.themeKey, 'light');
  }

  void setDark() {
    state = ThemeMode.dark;
    _prefs.setString(AppConstants.themeKey, 'dark');
  }

  void toggle() {
    if (state == ThemeMode.light) {
      setDark();
    } else {
      setLight();
    }
  }
}