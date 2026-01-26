import 'package:flutter/material.dart';

import 'app_colors_ligth.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData ligth() => ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    visualDensity: VisualDensity.adaptivePlatformDensity,

    colorScheme: ColorScheme(
      brightness: Brightness.light,

      primary: AppColorsLigth.primary,
      onPrimary: AppColorsLigth.onPrimary,
      primaryContainer: AppColorsLigth.primaryContainer,
      onPrimaryContainer: AppColorsLigth.onPrimaryContainer,

      secondary: AppColorsLigth.secondary,
      onSecondary: Colors.white,
      secondaryContainer: AppColorsLigth.secondaryContainer,
      onSecondaryContainer: AppColorsLigth.onSecondaryContainer,

      tertiary: AppColorsLigth.tertiary,
      onTertiary: Colors.white,
      tertiaryContainer: AppColorsLigth.tertiaryContainer,
      onTertiaryContainer: AppColorsLigth.onTertiaryContainer,

      error: AppColorsLigth.error,
      onError: AppColorsLigth.onError,
      errorContainer: AppColorsLigth.errorContainer,
      onErrorContainer: AppColorsLigth.onErrorContainer,

      surface: AppColorsLigth.surface,
      onSurface: AppColorsLigth.onSurface,
      surfaceContainerHighest: AppColorsLigth.surfaceContainerHighest,
      onSurfaceVariant: AppColorsLigth.onSurfaceVariant,
      outline: AppColorsLigth.outline,
      outlineVariant: AppColorsLigth.outlineVariant,
      surfaceTint: AppColorsLigth.surfaceTint,

      inverseSurface: const Color(0XFF303F9F),
      onInverseSurface: Colors.white,
      inversePrimary: AppColorsLigth.secondary,

      scrim: Colors.black,
      shadow: Colors.black,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: AppColorsLigth.surface,
      foregroundColor: AppColorsLigth.primary,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontFamily: 'Poppins',
        color: AppColorsLigth.primary,
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColorsLigth.onPrimary,
      contentPadding: const EdgeInsets.symmetric(vertical: 0),
      hintStyle: TextStyle(
        color: AppColorsLigth.onSurfaceVariant,
        fontFamily: 'Poppins',
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColorsLigth.onPrimary, width: 0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColorsLigth.onPrimary, width: 0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColorsLigth.onPrimary, width: 0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColorsLigth.error),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: AppColorsLigth.secondary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        textStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColorsLigth.primary,
        textStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
}
