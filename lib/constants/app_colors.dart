import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors - Slightly Darker & Premium
  static const Color primary = Color(0xFF4F46E5); // Deeper Indigo
  static const Color primaryLight = Color(0xFF6366F1);
  static const Color primaryDark = Color(0xFF3730A3);
  static const Color secondary = Color(0xFF1E293B); // Dark Slate
  
  // Neutral Colors - Premium Dark Mode / Slate
  static const Color background = Color(0xFF0F172A); // Deep Navy/Slate Background
  static const Color surface = Color(0xFF1E293B); // Slate Surface for Cards
  static const Color textPrimary = Colors.white; // White for readability on dark
  static const Color textSecondary = Color(0xFF94A3B8); // Muted Slate
  static const Color textTertiary = Color(0xFF64748B);
  static const Color textOnPrimary = Colors.white;
  static const Color textHint = Color(0xFF475569);
  
  // Semantic Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);
  
  // UI Elements
  static const Color borderLight = Color(0xFF334155);
  static const Color borderMedium = Color(0xFF475569);
  static const Color cardBackground = Color(0xFF1E293B);
  static const Color shadowLight = Color(0x40000000);

  // Category Colors (Vibrant but modern)
  static const Color food = Color(0xFFF43F5E);
  static const Color transport = Color(0xFF8B5CF6);
  static const Color shopping = Color(0xFFEC4899);
  static const Color entertainment = Color(0xFFF97316);
  static const Color bills = Color(0xFF06B6D4);
  static const Color health = Color(0xFF22C55E);
  static const Color coffee = Color(0xFFB45309);
  static const Color others = Color(0xFF94A3B8);

  // Premium Gradients for Cards
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient surfaceGradient = LinearGradient(
    colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFFF43F5E), Color(0xFFE11D48)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient successGradient = LinearGradient(
    colors: [success, success.withOpacity(0.8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static Color primaryWithOpacity(double opacity) => primary.withOpacity(opacity);
}