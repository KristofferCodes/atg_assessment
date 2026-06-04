import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand
  static const Color primary = Color(0xFFCC2525);       // ATG red
  static const Color primaryDark = Color(0xFFAA1A1A);
  static const Color accent = Color(0xFFB8A96A);        // gold/tan from login button

  // Light theme
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFF8F8F8);
  static const Color lightText = Color(0xFF0D0D0D);
  static const Color lightSubtext = Color(0xFF6B6B6B);
  static const Color lightBorder = Color(0xFFE0E0E0);
  static const Color lightHint = Color(0xFFAAAAAA);

  // Dark theme
  static const Color darkBackground = Color(0xFF0D0D0D);
  static const Color darkSurface = Color(0xFF1A1A1A);
  static const Color darkText = Color(0xFFF5F5F5);
  static const Color darkSubtext = Color(0xFF9E9E9E);
  static const Color darkBorder = Color(0xFF2E2E2E);
  static const Color darkHint = Color(0xFF666666);

  // Semantic
  static const Color error = Color(0xFFCC2525);
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFF57C00);

  // Onboarding overlay gradient base
  static const Color overlayDark = Color(0x99000000);
}