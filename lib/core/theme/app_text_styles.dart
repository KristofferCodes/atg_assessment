import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle get displayLarge => GoogleFonts.manrope(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 1.2,
        letterSpacing: -0.5,
      );

  static TextStyle get displayMedium => GoogleFonts.manrope(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        height: 1.25,
        letterSpacing: -0.3,
      );

  static TextStyle get headlineLarge => GoogleFonts.manrope(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        height: 1.3,
      );

  static TextStyle get headlineMedium => GoogleFonts.manrope(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.35,
      );

  static TextStyle get bodyLarge => GoogleFonts.manrope(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  static TextStyle get bodyMedium => GoogleFonts.manrope(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  static TextStyle get bodySmall => GoogleFonts.manrope(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.4,
      );

  static TextStyle get labelLarge => GoogleFonts.manrope(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: 0.2,
      );

  static TextStyle get labelMedium => GoogleFonts.manrope(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.2,
      );

  static TextStyle get caption => GoogleFonts.manrope(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.3,
        letterSpacing: 0.1,
      );
}