import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Common Text Theme Construction
  static TextTheme _buildTextTheme(TextTheme base, Color color) {
    return GoogleFonts.interTextTheme(base).copyWith(
      displayLarge: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.bold, color: color, letterSpacing: -1),
      displayMedium: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.bold, color: color, letterSpacing: -0.5),
      displaySmall: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold, color: color),
      headlineMedium: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w600, color: color),
      titleMedium: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: color),
      bodyLarge: GoogleFonts.inter(fontSize: 16, color: color.withOpacity(0.9)),
      bodyMedium: GoogleFonts.inter(fontSize: 14, color: color.withOpacity(0.85)),
      labelSmall: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: color.withOpacity(0.6), letterSpacing: 0.5),
    );
  }

  // Common Input Decoration
  static InputDecorationTheme _buildInputTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final fillColor = isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9);
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    return InputDecorationTheme(
      filled: true,
      fillColor: fillColor,
      contentPadding: const EdgeInsets.all(20),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
      hintStyle: TextStyle(color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8), fontSize: 14),
    );
  }

  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
        surface: Colors.white,
        onSurface: const Color(0xFF0F172A),
      ),
      textTheme: _buildTextTheme(ThemeData.light().textTheme, const Color(0xFF0F172A)),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: Color(0xFF0F172A)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      inputDecorationTheme: _buildInputTheme(Brightness.light),
    );
  }

  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: const Color(0xFF0F172A),
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
        surface: const Color(0xFF1E293B),
        onSurface: Colors.white,
      ),
      textTheme: _buildTextTheme(ThemeData.dark().textTheme, Colors.white),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      inputDecorationTheme: _buildInputTheme(Brightness.dark),
    );
  }
}