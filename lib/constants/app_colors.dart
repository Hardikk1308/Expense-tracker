import 'package:flutter/material.dart';

class AppColors {
  // --- Core Brand Colors (Indigo & Slate) ---
  static const Color primary = Color(0xFF4F46E5); // Indigo 600
  static const Color primaryLight = Color(0xFF818CF8); // Indigo 400
  static const Color primaryDark = Color(0xFF3730A3); // Indigo 800
  
  // --- Semantic Status Colors ---
  static const Color success = Color(0xFF059669); // Emerald 600
  static const Color warning = Color(0xFFD97706); // Amber 600
  static const Color error = Color(0xFFDC2626);   // Red 600
  static const Color info = Color(0xFF2563EB);    // Blue 600

  // --- Theme-Aware Dynamic Getters ---
  static bool isDark(BuildContext context) => Theme.of(context).brightness == Brightness.dark;

  // Backgrounds: Using soft slates instead of pure blacks
  static Color getBackground(BuildContext context) => 
    isDark(context) ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);

  // Surfaces: Cards and sheets
  static Color getSurface(BuildContext context) => 
    isDark(context) ? const Color(0xFF1E293B) : Colors.white;

  // Modals & Popups: Slightly higher contrast than surface
  static Color getCardElevated(BuildContext context) => 
    isDark(context) ? const Color(0xFF334155) : Colors.white;

  // Typography Hierarchy
  static Color getTextPrimary(BuildContext context) => 
    isDark(context) ? Colors.white : const Color(0xFF0F172A);

  static Color getTextSecondary(BuildContext context) => 
    isDark(context) ? const Color(0xFF94A3B8) : const Color(0xFF475569);

  static Color getTextTertiary(BuildContext context) => 
    isDark(context) ? const Color(0xFF64748B) : const Color(0xFF94A3B8);

  // Borders & Dividers
  static Color getBorder(BuildContext context) => 
    isDark(context) ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

  // Input Fields
  static Color getInputFill(BuildContext context) => 
    isDark(context) ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9);

  // --- Static Constants for Legacy (Mandatory for static TextStyles) ---
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textTertiary = Color(0xFF94A3B8);
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Colors.white;
  static const Color textOnPrimary = Colors.white;

  // --- Premium UI Tokens ---
  static const double borderRadius = 16.0;
  static const double borderRadiusLarge = 24.0;
  static const double padding = 16.0;
  static const double paddingLarge = 24.0;
  
  static BoxShadow softShadow(BuildContext context) => BoxShadow(
    color: isDark(context) ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.05),
    blurRadius: 10,
    offset: const Offset(0, 4),
  );

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryLight, primary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}