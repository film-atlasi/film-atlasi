import 'package:film_atlasi/app.dart';
import 'package:film_atlasi/features/user/screens/SignUpPage.dart';
import 'package:film_atlasi/features/user/screens/loginpage.dart';
import 'package:flutter/material.dart';

class AppConstants {
  /// This file contains the application-wide constants used throughout the
  /// Film Atlasi project. These constants are defined in the `AppConstants`
  /// class and are used to maintain consistency and avoid magic numbers
  /// or hard-coded values in the codebase.
  ///
  static String get AppName => "";

  static Map<String, WidgetBuilder> get routes => {
        '/giris': (context) => const Loginpage(),
        '/anasayfa': (context) => const FilmAtlasiApp(),
        '/kaydol': (context) => SignUpPage()
      };

  static Color get black => Colors.black;

  static const Color primaryColor = Color(0xFFD81F26); // Canlı kırmızı
  static const Color secondaryColor = Color(0xFF1A1A1A); // Koyu gri/siyah
  static const Color accentColor = Color(0xFFFFD700); // Altın sarısı
  static const Color textColor = Color(0xFFE4E6F1); // Açık gri/beyaz
  static const Color textLightColor = Color(0xFFB0B0B0); // Orta gri
  static const Color buttonColor = Color(0xFFD81F26); // Kırmızı butonlar için
  static const Color highlightColor = Color(0xFF3A86FF); // Mavi vurgu
  static const Color backgroundColor = Color(0xFF121212); // Siyah arkaplan
  static const Color bottomColor = Color(0xFF303030);
  static const Color appBarColor = Color(0xFF080808);
  static const Color cardColor = Color(0xFF1A1A1A);
  static const Color scaffoldColor = Color(0xFF121212); // Siyah arkaplan
  static const Color bottomAppBarColor = Color(0xFF1A1A1A);
  static const Color dialogColor = Color(0xFF1A1A1A);
  static const Color snackBarColor = Color(0xFFD81F26);
  static const Color tabBarColor = Color(0xFF1A1A1A);
  static const Color bottomSheetColor = Color(0xFF1A1A1A);
  static const Color inputColor = Color(0xFF1A1A1A);
  static const Color hintColor = Color(0xFFB0B0B0);
  static const Color iconColor = Color(0xFFE4E6F1);
  static const Color dividerColor = Color(0xFF303030);
  static const Color errorColor = Color(0xFFD81F26);
  static const Color successColor = Color(0xFF00FF00);
  static const Color textDarkGreyColor = Color(0xFFB0B0B0);
  static const Color textGreyColor = Color(0xFFE4E6F1);
  static const Color textWhiteColor = Color(0xFFFFFFFF);
  static const Color textBlackColor = Color(0xFF000000);
  static const Color textRedColor = Color(0xFFD81F26);
  static const Color textGreenColor = Color(0xFF00FF00);
  static const Color textBlueColor = Color(0xFF3A86FF);
  static const Color textYellowColor = Color(0xFFFFD700);
  static const Color textOrangeColor = Color(0xFFFFA500);
  static const Color textPurpleColor = Color(0xFF800080);
  static const Color textPinkColor = Color(0xFFFFC0CB);
  static const Color textBrownColor = Color(0xFFA52A2A);
  static const Color textCyanColor = Color(0xFF00FFFF);
  static const Color textMagentaColor = Color(0xFFFF00FF);
  static const Color textTealColor = Color(0xFF008080);
  static const Color textIndigoColor = Color(0xFF4B0082);
  static const Color textLightGreyColor = Color(0xFFD3D3D3);
}
