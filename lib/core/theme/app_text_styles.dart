import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle _base(double size, FontWeight weight, {Color? color, double? height, double? letterSpacing}) {
    return GoogleFonts.poppins(
      fontSize: size,
      fontWeight: weight,
      color: color ?? AppColors.textPrimary,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle get displayLarge => _base(32, FontWeight.w700, height: 1.15, letterSpacing: -0.5);
  static TextStyle get displayMedium => _base(28, FontWeight.w700, height: 1.2, letterSpacing: -0.3);
  static TextStyle get headlineLarge => _base(24, FontWeight.w700, height: 1.25);
  static TextStyle get headlineMedium => _base(20, FontWeight.w600, height: 1.3);
  static TextStyle get titleLarge => _base(18, FontWeight.w600, height: 1.35);
  static TextStyle get titleMedium => _base(16, FontWeight.w600, height: 1.4);
  static TextStyle get bodyLarge => _base(16, FontWeight.w400, color: AppColors.textPrimary, height: 1.5);
  static TextStyle get bodyMedium => _base(14, FontWeight.w400, color: AppColors.textSecondary, height: 1.5);
  static TextStyle get bodySmall => _base(13, FontWeight.w400, color: AppColors.textSecondary, height: 1.45);
  static TextStyle get labelLarge => _base(14, FontWeight.w600);
  static TextStyle get labelMedium => _base(12, FontWeight.w600, color: AppColors.textSecondary, letterSpacing: 0.3);
  static TextStyle get labelSmall => _base(11, FontWeight.w500, color: AppColors.textMuted, letterSpacing: 0.4);

  static TextStyle get buttonLarge => _base(16, FontWeight.w600, color: AppColors.textOnPrimary);
  static TextStyle get timerDisplay => _base(72, FontWeight.w700, color: AppColors.textPrimary, letterSpacing: -2);
}
