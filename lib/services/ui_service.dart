import 'package:flutter/material.dart';
import "package:shared_preferences/shared_preferences.dart";

class UIService extends ChangeNotifier {
  bool _isDarkMode = false;
  Color _primaryColor = Colors.green;

  bool get isDarkMode => _isDarkMode;
  Color get primaryColor => _primaryColor;

  static bool isBigScreen(BuildContext context) {
    return MediaQuery.of(context).size.width > 800;
  }

  Future<void> setIsDarkMode(bool value) async {
    _isDarkMode = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("isDarkMode", value);
  }

  get colorScheme {
    if (_isDarkMode) {
      return ColorScheme.dark(
          primary: _primaryColor, secondary: _primaryColor.withAlpha(100));
    }
    return ColorScheme.light(
        primary: _primaryColor, secondary: _primaryColor.withAlpha(100));
  }

  Future<void> readSavedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    bool? isDarkMode = prefs.getBool("isDarkMode");
    String? color = prefs.getString("color");
    if (isDarkMode != null) {
      _isDarkMode = isDarkMode;
      notifyListeners();
    }
    if (color != null) {
      _primaryColor = switch (color) {
        "red" => Colors.red,
        "orange" => Colors.orange,
        "yellow" => Colors.yellow,
        "green" => Colors.green,
        "blue" => Colors.blue,
        "purple" => Colors.purple,
        "indigo" => Colors.indigo,
        "pink" => Colors.pink,
        "grey" => Colors.blueGrey,
        _ => Colors.green,
      };
      notifyListeners();
    }
  }
}
