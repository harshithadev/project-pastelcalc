import 'package:flutter/material.dart';

/// Soft pastel palette for a playful calculator feel.
class PastelColors {
  static const background = Color(0xFFFFF5F8);
  static const surface = Color(0xFFFFFBFE);
  static const displayBg = Color(0xFFF3EEFF);

  static const textPrimary = Color(0xFF4A4458);
  static const textSecondary = Color(0xFF8B8399);
  static const textOnAccent = Color(0xFF3D3550);

  static const mint = Color(0xFFB8E8D8);
  static const lavender = Color(0xFFD4C5F9);
  static const peach = Color(0xFFFFD4C4);
  static const sky = Color(0xFFB8DFF5);
  static const rose = Color(0xFFFFC8DD);
  static const butter = Color(0xFFFFF0B8);
  static const lilac = Color(0xFFE8D5FF);

  static const operator = Color(0xFFC9B8F5);
  static const equals = Color(0xFFA8E6CF);
  static const danger = Color(0xFFFFB4B4);
  static const accent = Color(0xFFB5C7F0);
}

class PastelTheme {
  static ThemeData build() {
    const fontFamily = 'Nunito';

    return ThemeData(
      useMaterial3: true,
      fontFamily: fontFamily,
      brightness: Brightness.light,
      scaffoldBackgroundColor: PastelColors.background,
      colorScheme: const ColorScheme.light(
        primary: PastelColors.lavender,
        secondary: PastelColors.mint,
        surface: PastelColors.surface,
        onSurface: PastelColors.textPrimary,
        error: Color(0xFFE57373),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: fontFamily,
          fontWeight: FontWeight.w700,
          fontSize: 48,
          color: PastelColors.textPrimary,
          letterSpacing: -1,
        ),
        titleLarge: TextStyle(
          fontFamily: fontFamily,
          fontWeight: FontWeight.w700,
          fontSize: 22,
          color: PastelColors.textPrimary,
        ),
        titleMedium: TextStyle(
          fontFamily: fontFamily,
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: PastelColors.textPrimary,
        ),
        bodyMedium: TextStyle(
          fontFamily: fontFamily,
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: PastelColors.textSecondary,
        ),
        labelLarge: TextStyle(
          fontFamily: fontFamily,
          fontWeight: FontWeight.w600,
          fontSize: 20,
          color: PastelColors.textOnAccent,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0x1A4A4458),
        thickness: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: PastelColors.textPrimary.withValues(alpha: 0.92),
      ),
    );
  }
}
