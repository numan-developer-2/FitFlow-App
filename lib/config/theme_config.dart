import 'package:flutter/material.dart';

class ThemeConfig {
  // Primary Colors
  static const Color primaryColor = Color(0xFF4CAF50);
  static const Color secondaryColor = Color(0xFF81C784);
  static const Color accentColor = Color(0xFF4CAF50);

  // Background Colors
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color cardColor = Colors.white;

  // Text Colors
  static const Color textColor = Color(0xFF212121);
  static const Color errorColor = Color(0xFFE53935);

  // Dark Theme Colors
  static const Color darkPrimaryColor = Color(0xFF2E7D32);
  static const Color darkSecondaryColor = Color(0xFF4CAF50);
  static const Color darkBackgroundColor = Color(0xFF121212);
  static const Color darkCardColor = Color(0xFF1E1E1E);
  static const Color darkTextColor = Color(0xFFFFFFFF);

  // Additional Colors
  static const Color successColor = Color(0xFF4CAF50);
  static const Color warningColor = Color(0xFFFF9800);
  static const Color infoColor = Color(0xFF2196F3);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryColor, secondaryColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [darkPrimaryColor, darkSecondaryColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
