import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';

/// Inter typography for the onboarding flow only.
/// Sentence case, max weight 600. The rest of the app uses [AppTextStyles].
class OnbTextStyles {
  OnbTextStyles._();

  static TextStyle _i(double size, FontWeight weight,
      {Color? color, double? height, double? letterSpacing}) {
    return GoogleFonts.inter(
      fontSize: size,
      fontWeight: weight,
      color: color ?? AppColors.onbTextPrimary,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle get h1 =>
      _i(22, FontWeight.w600, height: 1.2, letterSpacing: -0.5);
  static TextStyle get h1Hero =>
      _i(26, FontWeight.w600, height: 1.2, letterSpacing: -0.5);

  static TextStyle get body =>
      _i(13, FontWeight.w400, color: AppColors.onbTextSecondary, height: 1.5);
  static TextStyle get bodyPrimary =>
      _i(13, FontWeight.w400, color: AppColors.onbTextPrimary, height: 1.5);

  static TextStyle get cardTitle => _i(14, FontWeight.w500);
  static TextStyle get cardSubtitle =>
      _i(12, FontWeight.w400, color: AppColors.onbTextSecondary, height: 1.5);
  static TextStyle get cardSubtitleItalic => _i(12, FontWeight.w400,
          color: AppColors.onbTextSecondary, height: 1.5)
      .copyWith(fontStyle: FontStyle.italic);

  static TextStyle get microLabel => _i(11, FontWeight.w500,
      color: AppColors.onbTextSecondary, letterSpacing: 0.5);

  static TextStyle get stepCounter =>
      _i(11, FontWeight.w500, color: AppColors.onbActionPurple);

  static TextStyle get chip =>
      _i(13, FontWeight.w400, color: AppColors.onbTextPrimary);
  static TextStyle get chipSelected =>
      _i(13, FontWeight.w500, color: AppColors.onbActionPurpleDark);

  static TextStyle get button =>
      _i(14, FontWeight.w600, color: Colors.white);

  static TextStyle get skip =>
      _i(12, FontWeight.w500, color: AppColors.onbTextSecondary);

  static TextStyle get sliderValue =>
      _i(14, FontWeight.w600, color: AppColors.onbTextPrimary);
}
