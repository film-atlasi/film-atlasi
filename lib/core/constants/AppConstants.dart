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
  static String get AppName => "Film Atlası";

  static Map<String, WidgetBuilder> get routes => {
        '/giris': (context) => const Loginpage(),
        '/anasayfa': (context) => const FilmAtlasiApp(),
        '/kaydol': (context) => SignUpPage()
      };

  static Color get black => Colors.black;
  static Color get red => Colors.red;
  static Color get baseColor => Color.fromARGB(255, 110, 5, 5);
}
