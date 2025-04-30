import 'package:film_atlasi/app.dart';
import 'package:film_atlasi/core/provider/ThemeProvider.dart';
import 'package:film_atlasi/features/user/screens/SignUpPage.dart';
import 'package:film_atlasi/features/user/screens/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppConstants {
  /// This file contains the application-wide constants used throughout the
  /// Film Atlasi project. These constants are defined in the `AppConstants`
  /// class and are used to maintain consistency and avoid magic numbers
  /// or hard-coded values in the codebase.
  ///
  static const String appName = "";

  final BuildContext context;
  const AppConstants(this.context);

  static Map<String, WidgetBuilder> get routes => {
        '/giris': (context) => const LoginPage(),
        '/anasayfa': (context) => const FilmAtlasiApp(),
        '/kaydol': (context) => SignUpPage(),
      };

  static Color get black => Colors.black;

  double getHeight(double height) {
    return MediaQuery.of(context).size.height * height;
  }

  double getWidth(double width) {
    return MediaQuery.of(context).size.width * width;
  }

  static const LinearGradient linearGradiant = LinearGradient(
    colors: [
      Color(0xFFD81F26), // primaryColor with 0.9 opacity
      Color(0xFFFF5252), // Colors.redAccent with 0.9 opacity
    ],
  );

  ///
  ///
  ///
  ///
  ///
  /// DARK THEME
  ///
  ///
  ///
  ///
  static const Color primaryColorDark = Color(0xFFD81F26); // Canlı kırmızı
  static const Color secondaryColorDark = Color(0xFF1A1A1A); // Koyu gri/siyah
  static const Color accentColorDark = Color(0xFFFFD700); // Altın sarısı
  static const Color textColorDark = Color(0xFFE4E6F1); // Açık gri/beyaz
  static const Color textLightColorDark = Color(0xFFB0B0B0); // Orta gri
  static const Color buttonColorDark =
      Color(0xFFD81F26); // Kırmızı butonlar için
  static const Color highlightColorDark = Color(0xFF3A86FF); // Mavi vurgu
  static const Color backgroundColorDark = Color(0xFF121212); // Siyah arkaplan
  static const Color bottomColorDark = Color(0xFF303030);
  static const Color appBarColorDark = Color(0xFF080808);
  static const Color cardColorDark = Color(0xFF1A1A1A);
  static const Color scaffoldColorDark = Color(0xFF121212); // Siyah arkaplan
  static const Color bottomAppBarColorDark = Color(0xFF1A1A1A);
  static const Color dialogColorDark = Color(0xFF1A1A1A);
  static const Color snackBarColorDark = Color(0xFFD81F26);
  static const Color tabBarColorDark = Color(0xFF1A1A1A);
  static const Color bottomSheetColorDark = Color(0xFF1A1A1A);
  static const Color inputColorDark = Color(0xFF1A1A1A);
  static const Color hintColorDark = Color(0xFFB0B0B0);
  static const Color iconColorDark = Color(0xFFE4E6F1);
  static const Color dividerColorDark = Color(0xFF303030);
  static const Color errorColorDark = Color(0xFFD81F26);
  static const Color successColorDark = Color(0xFF00FF00);

  ///
  ///
  ///
  ///
  ///
  /// LIGHT THEME
  ///
  ///
  ///
  ///
  ///
  static const Color primaryColorLight = Color(0xFFD81F26); // Canlı kırmızı
  static const Color secondaryColorLight = Color(0xFFFFFFFF); // Beyaz
  static const Color accentColorLight = Color(0xFFFFD700); // Altın sarısı
  static const Color textColorLight = Color(0xFF121212); // Siyah yazılar
  static const Color textLightColorLight =
      Color(0xFF555555); // Koyu gri yazılar
  static const Color buttonColorLight =
      Color(0xFFD81F26); // Kırmızı butonlar için
  static const Color highlightColorLight = Color(0xFF3A86FF); // Mavi vurgu
  static const Color backgroundColorLight = Color(0xFFFFFFFF); // Beyaz arkaplan
  static const Color bottomColorLight = Color(0xFFF5F5F5); // Açık gri
  static const Color appBarColorLight = Color(0xFFE0E0E0); // Açık gri
  static const Color cardColorLight = Color(0xFFF5F5F5); // Açık gri kart
  static const Color scaffoldColorLight = Color(0xFFFFFFFF); // Beyaz arkaplan
  static const Color bottomAppBarColorLight = Color(0xFFE0E0E0); // Açık gri
  static const Color dialogColorLight = Color(0xFFFFFFFF); // Beyaz
  static const Color snackBarColorLight = Color(0xFFD81F26); // Kırmızı
  static const Color tabBarColorLight = Color(0xFFE0E0E0); // Açık gri
  static const Color bottomSheetColorLight = Color(0xFFF5F5F5); // Açık gri
  static const Color inputColorLight = Color(0xFFF5F5F5); // Açık gri
  static const Color hintColorLight = Color(0xFF9E9E9E); // Açık gri
  static const Color iconColorLight = Color(0xFF121212); // Siyah ikonlar
  static const Color dividerColorLight = Color(0xFFBDBDBD); // Açık gri çizgiler
  static const Color errorColorLight = Color(0xFFD81F26); // Hata rengi
  static const Color successColorLight =
      Color(0xFF00C853); // Yeşil başarı rengi

  Color get primaryColor {
    return Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
        ? primaryColorDark
        : primaryColorLight;
  }

  Color get buttonColor {
    return Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
        ? buttonColorDark
        : buttonColorLight;
  }

  Color get secondaryColor {
    return Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
        ? secondaryColorDark
        : secondaryColorLight;
  }

  Color get textColor {
    return Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
        ? textColorDark
        : textColorLight;
  }

  Color get textLightColor {
    return Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
        ? textLightColorDark
        : textLightColorLight;
  }

  Color get highlightColor {
    return Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
        ? highlightColorDark
        : highlightColorLight;
  }

  Color get backgroundColor {
    return Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
        ? backgroundColorDark
        : backgroundColorLight;
  }

  Color get bottomColor {
    return Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
        ? bottomColorDark
        : bottomColorLight;
  }

  Color get appBarColor {
    return Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
        ? appBarColorDark
        : appBarColorLight;
  }

  Color get cardColor {
    return Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
        ? cardColorDark
        : cardColorLight;
  }

  Color get scaffoldColor {
    return Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
        ? scaffoldColorDark
        : scaffoldColorLight;
  }

  Color get bottomAppBarColor {
    return Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
        ? bottomAppBarColorDark
        : bottomAppBarColorLight;
  }

  Color get dialogColor {
    return Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
        ? dialogColorDark
        : dialogColorLight;
  }

  Color get snackBarColor {
    return Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
        ? snackBarColorDark
        : snackBarColorLight;
  }

  Color get tabBarColor {
    return Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
        ? tabBarColorDark
        : tabBarColorLight;
  }

  Color get bottomSheetColor {
    return Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
        ? bottomSheetColorDark
        : bottomSheetColorLight;
  }

  Color get inputColor {
    return Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
        ? inputColorDark
        : inputColorLight;
  }

  Color get hintColor {
    return Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
        ? hintColorDark
        : hintColorLight;
  }

  Color get iconColor {
    return Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
        ? iconColorDark
        : iconColorLight;
  }

  Color get dividerColor {
    return Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
        ? dividerColorDark
        : dividerColorLight;
  }

  Color get errorColor {
    return Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
        ? errorColorDark
        : errorColorLight;
  }

  Color get successColor {
    return Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
        ? successColorDark
        : successColorLight;
  }
}
