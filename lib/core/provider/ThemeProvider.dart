import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system; // Başlangıçta sistem temasına ayarlı

  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    _loadTheme(); // Uygulama açıldığında temayı yükle
  }

  // TextStyle sorununu çözen biraz daha yumuşak bir geçiş mekanizması
  void toggleTheme(bool isDarkMode) async {
    // Tema değişikliğini bir mikrosaniye geciktirerek
    // TextStyle interpolasyon sorununu hafifletebiliriz
    await Future.delayed(const Duration(milliseconds: 1));

    _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();

    // Tercihi kaydet
  }

  Future<void> _loadTheme() async {
    _themeMode = ThemeMode.dark;
    notifyListeners();
  }
}
