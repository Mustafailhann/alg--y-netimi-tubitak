import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'design_tokens.dart';

abstract final class AppTheme {
  // Common Text Theme using Google Fonts (Nunito)
  static TextTheme _buildTextTheme(Color textColor) {
    return GoogleFonts.nunitoTextTheme(
      TextTheme(
        displayLarge: TextStyle(color: textColor, fontSize: 32, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(color: textColor, fontSize: 24, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.normal),
        bodyMedium: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.normal),
        bodySmall: TextStyle(color: textColor, fontSize: 14, fontWeight: FontWeight.normal),
      ),
    );
  }

  // 1. Student Theme
  static ThemeData studentTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: AppColors.studentPrimary,
        secondary: AppColors.studentSecondary,
        surface: AppColors.studentSurface,
        background: AppColors.studentBackground,
        error: AppColors.error,
        onPrimary: AppColors.studentOnPrimary,
        onSurface: AppColors.studentOnSurface,
      ),
      textTheme: _buildTextTheme(AppColors.studentPrimary),
      scaffoldBackgroundColor: AppColors.studentBackground,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.studentSecondary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.large)),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l, vertical: AppSpacing.m),
        ),
      ),
      cardTheme: CardThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.large)),
        elevation: 0,
        color: AppColors.studentSurface,
      ),
    );
  }

  // 2. Forensics Theme (Canvas)
  static ThemeData forensicsTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.forensicsPrimary,
        secondary: AppColors.forensicsSecondary,
        surface: AppColors.forensicsSurface,
        background: AppColors.forensicsBackground,
      ),
      textTheme: _buildTextTheme(Colors.white),
      scaffoldBackgroundColor: AppColors.forensicsBackground,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.forensicsSecondary,
          foregroundColor: AppColors.forensicsPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.small)),
        ),
      ),
      cardTheme: CardThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.small)),
        color: AppColors.forensicsSurface,
      ),
    );
  }

  // 3. Admin/Teacher Theme
  static ThemeData adminTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: AppColors.adminPrimary,
        secondary: AppColors.adminSecondary,
        surface: AppColors.adminSurface,
        background: AppColors.adminBackground,
      ),
      textTheme: _buildTextTheme(AppColors.adminPrimary),
      scaffoldBackgroundColor: AppColors.adminBackground,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.adminAccent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.small)),
        ),
      ),
      cardTheme: CardThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.small)),
        elevation: 0,
        color: AppColors.adminSurface,
      ),
    );
  }
}
