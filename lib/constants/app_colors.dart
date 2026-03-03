import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF673AB7); // Deep Purple
  static const Color primaryLight = Color(0xFF9C27B0); // Purple
  static const Color primaryDark = Color(0xFF512DA8); // Dark Purple
  
  // Secondary Colors
  static const Color secondary = Color(0xFF03DAC6); // Teal
  static const Color secondaryLight = Color(0xFF66FFF9);
  static const Color secondaryDark = Color(0xFF00A693);
  
  // Background Colors
  static const Color background = Color(0xFFFAFAFA); // Light Grey
  static const Color surface = Color(0xFFFFFFFF); // White
  static const Color cardBackground = Color(0xFFFFFFFF); // White
  
  // Text Colors
  static const Color textPrimary = Color(0xFF212121); // Dark Grey
  static const Color textSecondary = Color(0xFF757575); // Medium Grey
  static const Color textHint = Color(0xFF9E9E9E); // Light Grey
  static const Color textOnPrimary = Color(0xFFFFFFFF); // White
  
  // Status Colors
  static const Color success = Color(0xFF4CAF50); // Green
  static const Color warning = Color(0xFFFF9800); // Orange
  static const Color error = Color(0xFFF44336); // Red
  static const Color info = Color(0xFF2196F3); // Blue
  
  // Category Colors
  static const Color foodColor = Color(0xFFE91E63); // Pink
  static const Color transportColor = Color(0xFFF44336); // Red
  static const Color billsColor = Color(0xFF4CAF50); // Green
  static const Color shoppingColor = Color(0xFF2196F3); // Blue
  static const Color healthcareColor = Color(0xFF9C27B0); // Purple
  static const Color entertainmentColor = Color(0xFF3F51B5); // Indigo
  static const Color coffeeColor = Color(0xFF795548); // Brown
  static const Color gymColor = Color(0xFF8BC34A); // Light Green
  static const Color petColor = Color(0xFF00BCD4); // Cyan
  
  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF8F9FA)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  // Border Colors
  static const Color borderLight = Color(0xFFE0E0E0);
  static const Color borderMedium = Color(0xFFBDBDBD);
  static const Color borderDark = Color(0xFF9E9E9E);
  
  // Shadow Colors
  static Color shadowLight = Colors.black.withValues(alpha: 0.05);
  static Color shadowMedium = Colors.black.withValues(alpha: 0.1);
  static Color shadowDark = Colors.black.withValues(alpha: 0.15);
  
  // Opacity Colors
  static Color primaryWithOpacity(double opacity) => primary.withValues(alpha: opacity);
  static Color successWithOpacity(double opacity) => success.withValues(alpha: opacity);
  static Color warningWithOpacity(double opacity) => warning.withValues(alpha: opacity);
  static Color errorWithOpacity(double opacity) => error.withValues(alpha: opacity);
  static Color infoWithOpacity(double opacity) => info.withValues(alpha: opacity);
}