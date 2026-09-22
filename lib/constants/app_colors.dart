import 'package:flutter/material.dart';

/// BJB Official Brand Colors & UI Palette
class AppColors {
  AppColors._();

  // Primary BJB Palette
  static const Color primary = Color(0xFF0083C9);       // BJB Primary Blue
  static const Color secondary = Color(0xFF00588A);     // BJB Dark Blue (Top Bar & Accent)
  static const Color primaryDark = Color(0xFF00436B);   // Deep Blue
  static const Color primaryLight = Color(0xFF4DB5E8);  // Light Sky Blue

  // Accents
  static const Color accentYellow = Color(0xFFFDB913);  // Khas BJB Yellow Accent
  static const Color accentOrange = Color(0xFFFF9800);  // Secondary Orange

  // Background & Surfaces
  static const Color background = Color(0xFFF5F7FA);    // Light Grey Background Canvas
  static const Color surface = Colors.white;            // Card Surface
  static const Color cardBorder = Color(0xFFE2E8F0);    // Subtle Divider/Border

  // Text Colors
  static const Color textPrimary = Color(0xFF1A202C);   // Main Charcoal
  static const Color textSecondary = Color(0xFF718096); // Slate Grey
  static const Color textLight = Color(0xFFA0AEC0);     // Light Hint Text
  static const Color textWhite = Colors.white;

  // Status & Feedback
  static const Color success = Color(0xFF28A745);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFDC3545);
  static const Color info = Color(0xFF17A2B8);

  // Gradients
  static const LinearGradient bjbGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient bjbReverseGradient = LinearGradient(
    colors: [secondary, primary],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient headerGradient = LinearGradient(
    colors: [Color(0xFF00588A), Color(0xFF0083C9)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF0083C9), Color(0xFF004F7C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

