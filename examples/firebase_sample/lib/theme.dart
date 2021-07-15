import 'package:flutter/material.dart';

class AppTheme extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;
  set themeMode(ThemeMode value) {
    _themeMode = value;
    notifyListeners();
  }
}
