import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:todo_test_task/theme/color_palettes.dart';

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  primaryColor: ColorPalettes.lightPrimary,
  scaffoldBackgroundColor: ColorPalettes.lightBackground,
  colorScheme: const ColorScheme.light(
    primary: ColorPalettes.lightPrimary,
    secondary: ColorPalettes.lightAccent,
    surface: ColorPalettes.lightSurface,
    onPrimary: ColorPalettes.lightOnPrimary,
    onSecondary: Colors.white,
    onSurface: ColorPalettes.lightOnSurface,
    error: Colors.redAccent,
    onError: Colors.white,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: ColorPalettes.lightBackground,
    foregroundColor: ColorPalettes.lightOnPrimary,
    elevation: 4,
    titleTextStyle: GoogleFonts.lato(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: ColorPalettes.lightOnSurface,
    ),
    iconTheme: const IconThemeData(
      color: ColorPalettes.lightOnSurface,
    ),
    actionsIconTheme: const IconThemeData(
      color: ColorPalettes.lightOnSurface,
    ),
  ),
  dividerTheme: DividerThemeData(
    color: ColorPalettes.lightOnSurface.withValues(alpha: .3),
    thickness: .5,
  ),
  textTheme: TextTheme(
    displayLarge: GoogleFonts.montserrat(
        fontSize: 57,
        fontWeight: FontWeight.bold,
        color: ColorPalettes.lightOnBackground),
    displayMedium: GoogleFonts.montserrat(
        fontSize: 45,
        fontWeight: FontWeight.bold,
        color: ColorPalettes.lightOnBackground),
    displaySmall: GoogleFonts.montserrat(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        color: ColorPalettes.lightOnBackground),
    headlineLarge: GoogleFonts.lato(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: ColorPalettes.lightOnBackground),
    headlineMedium: GoogleFonts.lato(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: ColorPalettes.lightOnBackground),
    headlineSmall: GoogleFonts.lato(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: ColorPalettes.lightOnBackground),
    titleLarge: GoogleFonts.lato(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: ColorPalettes.lightOnSurface),
    titleMedium: GoogleFonts.lato(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: ColorPalettes.lightOnSurface),
    titleSmall: GoogleFonts.lato(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: ColorPalettes.lightOnSurface),
    bodyLarge:
        GoogleFonts.roboto(fontSize: 16, color: ColorPalettes.lightOnSurface),
    bodyMedium:
        GoogleFonts.roboto(fontSize: 14, color: ColorPalettes.lightOnSurface),
    bodySmall:
        GoogleFonts.roboto(fontSize: 12, color: ColorPalettes.lightOnSurface),
    labelLarge: GoogleFonts.lato(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: ColorPalettes.lightOnPrimary,
    ),
  ),
  navigationBarTheme: NavigationBarThemeData(
    indicatorColor: ColorPalettes.lightPrimary.withValues(alpha: .5),
    backgroundColor: ColorPalettes.lightPrimaryLight,
    surfaceTintColor: ColorPalettes.lightPrimary,
    elevation: 4,
    labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
    iconTheme: WidgetStateProperty.all(
      const IconThemeData(size: 32),
    ),
    labelTextStyle: MaterialStateProperty.all(
      GoogleFonts.lato(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: ColorPalettes.lightOnSurface,
      ),
    ),
  ),
);

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  primaryColor: ColorPalettes.darkPrimary,
  scaffoldBackgroundColor: ColorPalettes.darkBackground,
  colorScheme: const ColorScheme.dark(
    primary: ColorPalettes.darkPrimary,
    secondary: ColorPalettes.darkAccent,
    surface: ColorPalettes.darkSurface,
    onPrimary: ColorPalettes.darkOnPrimary,
    onSecondary: Colors.white,
    onSurface: ColorPalettes.darkOnSurface,
    error: ColorPalettes.errorColor,
    onError: Colors.white,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: ColorPalettes.darkSurface,
    foregroundColor: ColorPalettes.darkOnPrimary,
    elevation: 2,
    titleTextStyle: GoogleFonts.lato(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: ColorPalettes.darkOnSurface,
    ),
    iconTheme: const IconThemeData(
      color: ColorPalettes.darkOnSurface,
    ),
    actionsIconTheme: const IconThemeData(
      color: ColorPalettes.darkOnSurface,
    ),
  ),
  dividerTheme: DividerThemeData(
    color: ColorPalettes.darkOnSurface.withValues(alpha: .3),
    thickness: .5,
  ),
  textTheme: TextTheme(
    displayLarge: GoogleFonts.montserrat(
        fontSize: 57,
        fontWeight: FontWeight.bold,
        color: ColorPalettes.darkOnBackground),
    displayMedium: GoogleFonts.montserrat(
        fontSize: 45,
        fontWeight: FontWeight.bold,
        color: ColorPalettes.darkOnBackground),
    displaySmall: GoogleFonts.montserrat(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        color: ColorPalettes.darkOnBackground),
    headlineLarge: GoogleFonts.lato(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: ColorPalettes.darkOnBackground),
    headlineMedium: GoogleFonts.lato(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: ColorPalettes.darkOnBackground),
    headlineSmall: GoogleFonts.lato(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: ColorPalettes.darkOnBackground),
    titleLarge: GoogleFonts.lato(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: ColorPalettes.darkOnSurface),
    titleMedium: GoogleFonts.lato(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: ColorPalettes.darkOnSurface),
    titleSmall: GoogleFonts.lato(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: ColorPalettes.darkOnSurface),
    bodyLarge:
        GoogleFonts.roboto(fontSize: 16, color: ColorPalettes.darkOnSurface),
    bodyMedium:
        GoogleFonts.roboto(fontSize: 14, color: ColorPalettes.darkOnSurface),
    bodySmall:
        GoogleFonts.roboto(fontSize: 12, color: ColorPalettes.darkOnSurface),
    labelLarge: GoogleFonts.lato(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: ColorPalettes.darkOnPrimary,
    ),
  ),
  navigationBarTheme: NavigationBarThemeData(
    indicatorColor: ColorPalettes.darkPrimary.withValues(alpha: .5),
    backgroundColor: ColorPalettes.darkSurface,
    surfaceTintColor: ColorPalettes.darkPrimary,
    elevation: 2,
    labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
    iconTheme: WidgetStateProperty.all(
      const IconThemeData(size: 32, color: ColorPalettes.darkOnSurface),
    ),
    labelTextStyle: MaterialStateProperty.all(
      GoogleFonts.lato(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: ColorPalettes.darkOnSurface,
      ),
    ),
  ),
  checkboxTheme: CheckboxThemeData(
    fillColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.disabled)) {
        return Colors.grey.shade700;
      }
      if (states.contains(MaterialState.selected)) {
        return ColorPalettes.darkPrimary;
      }
      return Colors.grey.shade600;
    }),
    checkColor: MaterialStateProperty.all(ColorPalettes.darkOnPrimary),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    splashRadius: 20,
  ),
);
