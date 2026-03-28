import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_radius.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: AppColors.lightBackground,
    cardColor: AppColors.lightCard,

    appBarTheme: const AppBarTheme(
      centerTitle: false,
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: AppColors.lightTextPrimary,
      titleTextStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: AppColors.lightTextPrimary,
      ),
    ),

    dividerColor: AppColors.borderLight,

    cardTheme: CardThemeData(
      color: AppColors.lightCard,
      elevation: 0,
      shadowColor: Colors.black.withValues(alpha: 0.04),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: const BorderSide(color: AppColors.borderLight),
      ),
      margin: EdgeInsets.zero,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      hintStyle: const TextStyle(
        color: AppColors.lightTextSecondary,
        fontWeight: FontWeight.w500,
      ),
      labelStyle: const TextStyle(
        fontWeight: FontWeight.w600,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.borderLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.borderLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 52),
        elevation: 0,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 15,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 52),
        side: const BorderSide(color: AppColors.borderLight),
        foregroundColor: AppColors.lightTextPrimary,
        textStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 15,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: AppColors.darkBackground,
    cardColor: AppColors.darkCard,

    appBarTheme: const AppBarTheme(
      centerTitle: false,
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: AppColors.darkTextPrimary,
      titleTextStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: AppColors.darkTextPrimary,
      ),
    ),

    dividerColor: AppColors.borderDark,

    cardTheme: CardThemeData(
      color: AppColors.darkCard,
      elevation: 0,
      shadowColor: Colors.black.withValues(alpha: 0.10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: const BorderSide(color: AppColors.borderDark),
      ),
      margin: EdgeInsets.zero,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkCard,
      hintStyle: const TextStyle(
        color: AppColors.darkTextSecondary,
        fontWeight: FontWeight.w500,
      ),
      labelStyle: const TextStyle(
        fontWeight: FontWeight.w600,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.borderDark),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.borderDark),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 52),
        elevation: 0,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 15,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 52),
        side: const BorderSide(color: AppColors.borderDark),
        foregroundColor: AppColors.darkTextPrimary,
        textStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 15,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
    ),
  );
}