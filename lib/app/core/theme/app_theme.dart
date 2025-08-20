import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_test_task/app/core/theme/app_colors.dart';
import 'package:todo_test_task/app/core/theme/app_text_theme.dart';

abstract class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primary,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
    scaffoldBackgroundColor: AppColors.surfaceLight,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    useMaterial3: true,
    fontFamily: GoogleFonts.montserrat().fontFamily,
    textTheme: AppTextTheme.lightTextTheme,
  );

  static ThemeData darkTheme = ThemeData(
    primaryColor: AppColors.primary,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
    scaffoldBackgroundColor: AppColors.surfaceDark,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    useMaterial3: true,
    fontFamily: GoogleFonts.montserrat().fontFamily,
    textTheme: AppTextTheme.darkTextTheme,
  );
}
