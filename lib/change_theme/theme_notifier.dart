import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeNotifier() {
    _loadTheme();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await _saveTheme();
    notifyListeners();
  }

  ThemeData get lightTheme => ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey.shade200,
        ),
        colorScheme: ColorScheme.light(
          onPrimary: Colors.grey.shade200,
        ),
      );

  Color getIntermediateGrey() {
    return Color.lerp(Colors.grey.shade900, Colors.grey.shade800, 0.6)!;
  }

// In your ThemeData
  ThemeData get darkTheme => ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF2A2A2A),
        dialogBackgroundColor: const Color(0xFF2A2A2A),
        appBarTheme: AppBarTheme(
          backgroundColor: getIntermediateGrey(), // Use the interpolated color
        ),
        colorScheme: ColorScheme.dark(
          onPrimary: getIntermediateGrey(), // Use the interpolated color
        ),
      );

  Future<void> _saveTheme() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    notifyListeners();
  }
}
