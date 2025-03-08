import 'package:flutter/material.dart';

class UiConstants {
  static const BoxDecoration backgroundGradient = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFF0A0118),
        Color(0xFF1A0E33),
      ],
    ),
  );

  static const Color lightGrey = Color(0xFFBDBDBD);
  static const Color darkGrey = Color(0xFF757575);
  static const Color purple = Color(0xFF6366F1);
  static const Color deepPurple = Color(0xFF4338CA);
}
