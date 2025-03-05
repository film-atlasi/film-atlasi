import 'package:film_atlasi/core/constants/AppConstants.dart';
import 'package:flutter/material.dart';

class AppTheme {
  /// **🔥 Karanlık Tema**
  static ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        primaryColor: AppConstants.primaryColor, // Kırmızı
        hintColor: Colors.white,
        drawerTheme: const DrawerThemeData(
          backgroundColor: AppConstants.secondaryColor,
        ),
        scaffoldBackgroundColor: AppConstants.backgroundColor, // Siyah Arkaplan
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: AppConstants.secondaryColor,
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.white,
          selectionColor: Colors.white,
          selectionHandleColor: Colors.white,
        ),
        bottomAppBarTheme: const BottomAppBarTheme(
          color: AppConstants.bottomColor,
        ),
        cardTheme: const CardTheme(
          color: AppConstants.backgroundColor,
        ),
        dialogTheme: const DialogTheme(
          backgroundColor: AppConstants.secondaryColor,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppConstants.primaryColor,
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          hintStyle: TextStyle(color: AppConstants.textLightColor),
          fillColor: AppConstants.secondaryColor,
          filled: true,
          labelStyle: TextStyle(color: AppConstants.textLightColor),
          contentPadding: EdgeInsets.all(20),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppConstants.textLightColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppConstants.bottomColor),
          ),
        ),
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: AppConstants.primaryColor,
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
          primary: AppConstants.primaryColor,
          secondary: AppConstants.secondaryColor,
          surface: AppConstants.black,
          error: Colors.red,
          onPrimary: Colors.white,
          onSecondary: Colors.black,
          onSurface: Colors.white,
          onError: Colors.white,
          brightness: Brightness.dark,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppConstants.primaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Colors.white),
            ),
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppConstants.secondaryColor,
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
      );

  /// **🌞 Açık Tema**
  static ThemeData get lightTheme => ThemeData(
        brightness: Brightness.light,
        primaryColor: AppConstants.primaryColor, // Kırmızı
        hintColor: Colors.black,
        drawerTheme: const DrawerThemeData(
          backgroundColor: AppConstants.secondaryColor,
        ),
        scaffoldBackgroundColor: Colors.white, // Açık arkaplan
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: AppConstants.secondaryColor,
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.black,
          selectionColor: Colors.black45,
          selectionHandleColor: Colors.black,
        ),
        bottomAppBarTheme: const BottomAppBarTheme(
          color: AppConstants.bottomColor,
        ),
        cardTheme: const CardTheme(
          color: Colors.white,
        ),
        dialogTheme: const DialogTheme(
          backgroundColor: AppConstants.secondaryColor,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppConstants.primaryColor,
        ),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          hintStyle: TextStyle(color: AppConstants.textDarkGreyColor),
          fillColor: AppConstants.textLightGreyColor,
          filled: true,
          labelStyle: TextStyle(color: AppConstants.textDarkGreyColor),
          contentPadding: EdgeInsets.all(20),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppConstants.textDarkGreyColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppConstants.bottomColor),
          ),
        ),
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: AppConstants.primaryColor,
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
          primary: AppConstants.primaryColor,
          secondary: AppConstants.secondaryColor,
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
            backgroundColor: AppConstants.primaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Colors.black),
            ),
          ),
        ),
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
