import 'package:flutter/material.dart';

/// Shared brand tokens for Gebeya.
class GebeyaColors {
  GebeyaColors._();

  static const Color ink = Color(0xFF15120F); // near-black hero background
  static const Color inkSoft = Color(0xFF211C17); // lighter ink panel
  static const Color orange = Color(0xFFE8791E); // primary market orange
  static const Color amber = Color(0xFFF6A93E); // secondary accent
  static const Color cream = Color(0xFFFBF6EF); // form background
  static const Color creamSoft = Color(0xFFF2EAE0); // input fill
  static const Color creamBorder = Color(0xFFE4D9C8); // input border
  static const Color textMuted = Color(0xFF8A8178); // secondary text on cream
  static const Color textMutedOnInk = Color(0xFFC9C0B4); // secondary text on ink
  static const Color success = Color(0xFF3F8F52); // confirmations / checkout
  static const Color danger = Color(0xFFD1483F); // destructive actions
}

/// App-wide Material theme built from the Gebeya brand tokens above, so
/// every screen (not just the auth flow) shares the same look.
class GebeyaTheme {
  GebeyaTheme._();

  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: GebeyaColors.orange,
      brightness: Brightness.light,
    ).copyWith(
      primary: GebeyaColors.orange,
      onPrimary: Colors.white,
      secondary: GebeyaColors.amber,
      surface: Colors.white,
      error: GebeyaColors.danger,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: GebeyaColors.cream,
      splashColor: GebeyaColors.orange.withValues(alpha: 0.08),
      highlightColor: Colors.transparent,
      dividerColor: GebeyaColors.creamBorder,
      appBarTheme: const AppBarTheme(
        backgroundColor: GebeyaColors.ink,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.white),
        actionsIconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.3,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: GebeyaColors.ink,
          foregroundColor: Colors.white,
          disabledBackgroundColor: GebeyaColors.textMuted,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: GebeyaColors.ink,
          side: const BorderSide(color: GebeyaColors.creamBorder, width: 1.4),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: GebeyaColors.orange,
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: GebeyaColors.creamSoft,
        hintStyle: const TextStyle(color: Color(0xFFB2A796)),
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: GebeyaColors.creamBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: GebeyaColors.creamBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: GebeyaColors.orange, width: 1.4),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: GebeyaColors.orange,
        unselectedItemColor: GebeyaColors.textMuted,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 11.5),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 11.5),
        elevation: 8,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: GebeyaColors.ink,
        contentTextStyle: const TextStyle(color: Colors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: GebeyaColors.orange,
      ),
    );
  }
}
