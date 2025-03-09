import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system; // Başlangıçta sistem temasına ayarlı

  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    _loadTheme(); // Uygulama açıldığında temayı yükle
  }

  void toggleTheme(bool isDarkMode) async {
    _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();

    // Tercihi kaydet
  }

  Future<void> _loadTheme() async {
    _themeMode = ThemeMode.dark;
    notifyListeners();
  }
}
