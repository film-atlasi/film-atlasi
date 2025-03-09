import 'package:film_atlasi/core/constants/AppConstants.dart';
import 'package:flutter/material.dart';

class AppTheme {
  /// **🔥 Karanlık Tema**
  ///
  /// - `brightness`: Karanlık
  /// - `primaryColor`: Kırmızı
  /// - `hintColor`: Beyaz
  ///
  ///
  ///
  ///
  ///
  ///

  final AppConstants appConstants;
  const AppTheme(this.appConstants);

  ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        primaryColor: appConstants.primaryColor, // Kırmızı
        hintColor: Colors.white,
        drawerTheme: DrawerThemeData(
          backgroundColor: appConstants.secondaryColor,
        ),
        scaffoldBackgroundColor: appConstants.backgroundColor, // Siyah Arkaplan
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: appConstants.secondaryColor,
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.white,
          selectionColor: Colors.white,
          selectionHandleColor: Colors.black,
        ),

        bottomAppBarTheme: BottomAppBarTheme(
          color: appConstants.bottomColor,
        ),
        cardTheme: CardTheme(
          color: appConstants.backgroundColor,
        ),
        dialogTheme: DialogTheme(
          backgroundColor: appConstants.secondaryColor,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: appConstants.primaryColor,
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(color: appConstants.textLightColor),
          fillColor: appConstants.secondaryColor,
          filled: true,
          labelStyle: TextStyle(color: appConstants.textLightColor),
          contentPadding: EdgeInsets.all(20),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: appConstants.textLightColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: appConstants.bottomColor),
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: appConstants.primaryColor,
          contentTextStyle: TextStyle(color: Colors.white),
        ),
        tabBarTheme: const TabBarTheme(
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
          bodyMedium: TextStyle(color: Colors.white70, fontSize: 16),
          titleLarge: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.black,
          primary: appConstants.primaryColor,
          secondary: appConstants.secondaryColor,
          surface: Colors.black,
          error: Colors.red,
          onPrimary: Colors.white,
          onSecondary: Colors.black,
          onSurface: Colors.white,
          onError: Colors.white,
          brightness: Brightness.dark,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: appConstants.primaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(color: Colors.white),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
          alignment: Alignment.center,
          foregroundColor: appConstants.secondaryColor,
          backgroundColor: appConstants.primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: BorderSide(color: appConstants.appBarColor),
          ),
        )),
        appBarTheme: AppBarTheme(
          backgroundColor: appConstants.secondaryColor,
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
      );

  /// **🌞 Açık Tema**
  ThemeData get lightTheme => ThemeData(
        brightness: Brightness.light,
        primaryColor: appConstants.primaryColor, // Kırmızı
        hintColor: Colors.black,
        drawerTheme: DrawerThemeData(
          backgroundColor: appConstants.secondaryColor,
        ),
        scaffoldBackgroundColor: Colors.white, // Açık arkaplan
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: appConstants.secondaryColor,
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.black,
          selectionColor: Colors.black45,
          selectionHandleColor: Colors.black,
        ),
        bottomAppBarTheme: BottomAppBarTheme(
          color: appConstants.bottomColor,
        ),
        cardTheme: const CardTheme(
          color: Colors.white,
        ),
        dialogTheme: DialogTheme(
          backgroundColor: appConstants.secondaryColor,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: appConstants.primaryColor,
        ),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(color: appConstants.textLightColor),
          fillColor: appConstants.secondaryColor,
          filled: true,
          labelStyle: TextStyle(color: appConstants.textLightColor),
          contentPadding: EdgeInsets.all(20),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: appConstants.textLightColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: appConstants.bottomColor),
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: appConstants.primaryColor,
          contentTextStyle: TextStyle(color: Colors.white),
        ),
        tabBarTheme: const TabBarTheme(
          labelColor: Colors.black,
          unselectedLabelColor: Colors.black54,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
          bodyMedium: TextStyle(color: Colors.black87, fontSize: 16),
          titleLarge: TextStyle(
              color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.white,
          primary: appConstants.primaryColor,
          secondary: appConstants.secondaryColor,
          surface: Colors.white,
          error: Colors.red,
          onPrimary: Colors.white,
          onSecondary: Colors.black,
          onSurface: Colors.black,
          onError: Colors.white,
          brightness: Brightness.light,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: appConstants.primaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Colors.black),
            ),
          ),
        ),
        cardColor: appConstants.scaffoldColor,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          titleTextStyle: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: const IconThemeData(color: Colors.black),
        ),
      );
}
