/// lib/theme/app_theme.dart
///
/// Roti Saku Design System — Material 3 theme with warm bakery palette.
/// All tokens defined per design.md specifications.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ── Brand Colors ──────────────────────────────────────────────
  static const Color primary = Color(0xFF5D4037);       // Deep roasted brown
  static const Color primaryLight = Color(0xFF8D6E63);  // Warm taupe
  static const Color primaryDark = Color(0xFF3E2723);   // Deep espresso

  static const Color secondary = Color(0xFFF9A825);      // Golden amber
  static const Color secondaryLight = Color(0xFFFFF176); // Warm gold
  static const Color secondaryDark = Color(0xFFF57F17); // Deep saffron

  static const Color surface = Color(0xFFFFFDF7);         // Warm cream
  static const Color surfaceVariant = Color(0xFFF5F0E8);  // Parchment
  static const Color background = Color(0xFFFFFBF5);      // Off-white parchment

  static const Color error = Color(0xFFC62828);           // Warm red
  static const Color success = Color(0xFF2E7D32);         // Fresh green

  // Bakery-specific
  static const Color cinnamon = Color(0xFFA1887F);        // Warm accent border
  static const Color honey = Color(0xFFE8A317);           // Rating/promo badge
  static const Color flour = Color(0xFFEDE7D9);           // Skeleton shimmer
  static const Color chocolate = Color(0xFF3E2723);       // Nav selected
  static const Color cream = Color(0xFFFFF8E1);           // Chip bg

  // Text colors
  static const Color onSurface = Color(0xFF2C2C2C);
  static const Color onSurfaceMedium = Color(0xFF5C5C5C);
  static const Color onSurfaceMuted = Color(0xFF8A8A8A);
  static const Color onPrimary = Colors.white;
  static const Color onSecondary = Color(0xFF2C2C2C);

  // ── ThemeData ─────────────────────────────────────────────────
  static ThemeData get lightTheme {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: background,
      // Primary color scheme
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: primary,
        onPrimary: onPrimary,
        primaryContainer: primaryLight,
        onPrimaryContainer: primaryDark,
        secondary: secondary,
        onSecondary: onSecondary,
        secondaryContainer: secondaryLight,
        onSecondaryContainer: secondaryDark,
        surface: surface,
        onSurface: onSurface,
        surfaceVariant: surfaceVariant,
        onSurfaceVariant: onSurfaceMedium,
        background: background,
        onBackground: onSurface,
        error: error,
        onError: Colors.white,
        outline: cinnamon,
        outlineVariant: flour,
      ),
      // ── Typography ──────────────────────────────────────
      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        displayLarge: GoogleFonts.poppins(
          fontSize: 36,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.02,
          height: 44 / 36,
          color: onSurface,
        ),
        displayMedium: GoogleFonts.poppins(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.01,
          height: 36 / 28,
          color: onSurface,
        ),
        headlineLarge: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.01,
          height: 32 / 24,
          color: onSurface,
        ),
        headlineMedium: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
          height: 28 / 20,
          color: onSurface,
        ),
        titleLarge: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          letterSpacing: 0,
          height: 26 / 18,
          color: onSurface,
        ),
        titleMedium: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0,
          height: 24 / 16,
          color: onSurface,
        ),
        bodyLarge: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
          height: 24 / 16,
          color: onSurface,
        ),
        bodyMedium: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
          height: 22 / 14,
          color: onSurfaceMedium,
        ),
        labelLarge: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.01,
          height: 20 / 14,
          color: onPrimary,
        ),
        labelMedium: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.02,
          height: 18 / 12,
          color: onSurfaceMedium,
        ),
      ),
      // ── Input Decoration ────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceVariant,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cinnamon.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: error),
        ),
        labelStyle: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: onSurfaceMedium,
        ),
        hintStyle: GoogleFonts.poppins(
          fontSize: 14,
          color: onSurfaceMuted,
        ),
        errorStyle: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: error,
        ),
      ),
      // ── Elevation ──────────────────────────────────────
      // (elevationOverlaySurface not available in this Flutter version)
      // ── AppBar ──────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: primary,
        foregroundColor: onPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: onPrimary,
        ),
        iconTheme: const IconThemeData(color: onPrimary),
      ),
      // ── Buttons ─────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.01,
          ),
          elevation: 0,
          shadowColor: primary.withOpacity(0.3),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: const BorderSide(color: primary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      // ── Chips ───────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: cream,
        labelStyle: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: primaryDark,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      // ── Card ────────────────────────────────────────────
      // (cardTheme removed for compatibility)
      // ── Bottom Navigation ───────────────────────────────
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        elevation: 1,
        indicatorColor: primary.withOpacity(0.12),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: primary,
            );
          }
          return GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: onSurfaceMuted,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: primary, size: 24);
          }
          return IconThemeData(color: onSurfaceMuted, size: 24);
        }),
      ),
      // ── Dialog ──────────────────────────────────────────
      // ── Snakbar ─────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: surface,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        contentTextStyle: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: onSurface,
        ),
        actionTextColor: primary,
      ),
      // ── Bottom Sheet ────────────────────────────────────
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surface,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
      // ── Divider ─────────────────────────────────────────
      dividerTheme: DividerThemeData(
        color: cinnamon.withOpacity(0.3),
        thickness: 1,
        space: 1,
      ),
      // ── Icon Theme ──────────────────────────────────────
      iconTheme: const IconThemeData(
        color: onSurface,
        size: 24,
      ),
    );

    return base;
  }
}
