import 'package:flutter/material.dart';

class AppTheme {
  static const Color darkBg    = Color(0xFF0D1F1A);
  static const Color sheetBg   = Color(0xFF0A0A0A);
  static const Color cardBg    = Color(0xFF1A1A1A);
  static const Color gold        = Color(0xFFB8860B);
  static const Color goldLight   = Color(0xFFD4A843);
  static const Color buttonColor = Color(0xFFC8973A);
  static const Color white     = Color(0xFFFFFFFF);
  static const Color grey      = Color(0xFF8A9E99);
  static const Color textGrey  = Color(0xFFB0B0B0);
  static const Color darkGrey  = Color(0xFF2A2A2A);

  static const TextStyle labelStyle = TextStyle(
    color: grey,
    fontSize: 10,
    letterSpacing: 1.2,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle valueStyle = TextStyle(
    color: white,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle headingStyle = TextStyle(
    color: white,
    fontSize: 22,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle goldTextStyle = TextStyle(
    color: goldLight,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle hintStyle = TextStyle(
    color: grey,
    fontSize: 11,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    color: white,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static BoxDecoration get cardDecoration => const BoxDecoration(
    color: cardBg,
    borderRadius: BorderRadius.all(Radius.circular(12)),
  );

  static const BoxDecoration bottomPanelDecoration = BoxDecoration(
    color: sheetBg,
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(20),
      topRight: Radius.circular(20),
    ),
  );

  static BoxDecoration topBarButton({bool hasBorder = false}) => BoxDecoration(
    color: Color(0xFF0A0A0A).withOpacity(0.85),
    borderRadius: BorderRadius.circular(10),
    border: hasBorder
        ? Border.all(color: goldLight.withOpacity(0.4))
        : null,
  );

  static BoxDecoration get goldButtonDecoration => const BoxDecoration(
    color: goldLight,
    borderRadius: BorderRadius.all(Radius.circular(12)),
  );

  static BoxDecoration get etaBadgeDecoration => BoxDecoration(
    color: white,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.25),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  );

  static ThemeData get themeData => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkBg,
    primaryColor: goldLight,
    colorScheme: const ColorScheme.dark(
      primary: goldLight,
      surface: cardBg,
      background: darkBg,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        foregroundColor: Colors.black87,
        disabledBackgroundColor: Color(0xFF2A2A2A),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    ),
  );
}