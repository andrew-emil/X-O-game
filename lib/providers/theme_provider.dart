import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/theme_enum.dart';

final themeProvider = StateNotifierProvider<ThemeProvider, ThemeEnum>(
  (_) => ThemeProvider(),
);

class ThemeProvider extends StateNotifier<ThemeEnum> {
  ThemeProvider() : super(ThemeEnum.light) {
    _loadTheme();
  }
  final prefKey = "isDarkMode";

  Future<void> _loadTheme() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final isDarkMode = preferences.getBool(prefKey) ?? false;
    state = isDarkMode ? ThemeEnum.dark : ThemeEnum.light;
  }

  Future<void> toggleTheme() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.getBool(prefKey) == true) {
      await preferences.setBool(prefKey, false);
      state = ThemeEnum.light;
    } else {
      await preferences.setBool(prefKey, true);
      state = ThemeEnum.dark;
    }
  }
}
