import 'package:flutter/material.dart';

abstract class AppTextTheme {
  static const TextTheme lightTextTheme = TextTheme(
    bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
    titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  );

  static const TextTheme darkTextTheme = TextTheme(
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: Colors.white,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  );
}
