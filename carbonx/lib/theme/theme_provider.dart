import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_theme.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  bool _forceDarkMode = false;

  ThemeProvider() {
    // Check system brightness on startup
    _updateThemeMode();
  }

  // Get current theme data
  ThemeData get themeData {
    return isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme;
  }

  // Get current theme mode
  ThemeMode get themeMode => _themeMode;

  // Is dark mode currently active?
  bool get isDarkMode {
    if (_forceDarkMode) return true;

    if (_themeMode == ThemeMode.system) {
      final brightness =
          WidgetsBinding.instance.platformDispatcher.platformBrightness;
      return brightness == Brightness.dark;
    }

    return _themeMode == ThemeMode.dark;
  }

  // Toggle between light and dark mode
  void toggleTheme() {
    if (_themeMode == ThemeMode.light) {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.light;
    }
    notifyListeners();
  }

  // Set theme mode directly
  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  // Force dark mode (overrides system)
  void setForceDarkMode(bool force) {
    _forceDarkMode = force;
    notifyListeners();
  }

  // Update theme based on system
  void _updateThemeMode() {
    final brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    _themeMode =
        brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  // Helper to get ThemeProvider from context - Updated to use Provider.of properly
  static ThemeProvider of(BuildContext context, {bool listen = true}) {
    try {
      return Provider.of<ThemeProvider>(context, listen: listen);
    } catch (e) {
      // If we can't get the provider, return a default instance
      // This is just a fallback and should be avoided
      debugPrint('Error getting ThemeProvider: $e');
      return ThemeProvider();
    }
  }
}
