import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand
  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryDeep = Color(0xFF5A52E6);
  static const Color primaryLight = Color(0xFF9B91FF);
  static const Color secondary = Color(0xFF9B91FF);
  static const Color secondaryDeep = Color(0xFF7A6FF0);

  // Surfaces
  static const Color background = Color(0xFFF6F6F8);
  static const Color backgroundAlt = Color(0xFFEFEFF3);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF1F1F5);

  // Text
  static const Color textPrimary = Color(0xFF1F2430);
  static const Color textSecondary = Color(0xFF7B8190);
  static const Color textMuted = Color(0xFFA8AEBC);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Lines
  static const Color border = Color(0xFFE6E7EE);
  static const Color divider = Color(0xFFEFEFF3);

  // Soft accents (used on icon chips / pastel backgrounds)
  static const Color accentMint = Color(0xFFD8F3EE);
  static const Color accentMintDeep = Color(0xFF4FB29A);
  static const Color accentPeach = Color(0xFFFFE6D6);
  static const Color accentPeachDeep = Color(0xFFE89163);
  static const Color accentLavender = Color(0xFFE8E2FF);
  static const Color accentLavenderDeep = Color(0xFF6C63FF);
  static const Color accentSky = Color(0xFFD9EDFA);
  static const Color accentSkyDeep = Color(0xFF4F9EC9);
  static const Color accentRose = Color(0xFFFCE0EA);
  static const Color accentRoseDeep = Color(0xFFD86A91);

  // Intensity (from Release spec)
  static const Color intensityHigh = Color(0xFFFF6B6B);
  static const Color intensityHighBg = Color(0xFFFFE5E5);
  static const Color intensityMedium = Color(0xFFF4B400);
  static const Color intensityMediumBg = Color(0xFFFFF4CC);
  static const Color intensityLow = Color(0xFF4FB29A);
  static const Color intensityLowBg = Color(0xFFE3F5EC);

  // Status
  static const Color success = Color(0xFF4FB29A);
  static const Color warning = Color(0xFFF4B400);
  static const Color error = Color(0xFFFF6B6B);

  // Shadows
  static const Color shadow = Color(0x146C63FF);
  static const Color shadowSoft = Color(0x0A1F2430);

  // ---------------------------------------------------------------------------
  // Onboarding palette (`onb*`). Brief-specific tokens for the 7-screen
  // onboarding flow — kept separate so the rest of the app keeps its current
  // tone. Do not use these elsewhere.
  // ---------------------------------------------------------------------------
  static const Color onbBackground = Color(0xFFFAFAFA);
  static const Color onbSurface = Color(0xFFFFFFFF);
  static const Color onbSurfaceSecondary = Color(0xFFF3F4F6);

  static const Color onbActionPurple = Color(0xFF8B5CF6);
  static const Color onbActionPurpleLight = Color(0xFFEDE9FE);
  static const Color onbActionPurpleDark = Color(0xFF6D28D9);

  static const Color onbGradientStart = Color(0xFF8B5CF6);
  static const Color onbGradientEnd = Color(0xFFEC4899);

  static const Color onbTextPrimary = Color(0xFF1F2937);
  static const Color onbTextSecondary = Color(0xFF6B7280);
  static const Color onbTextTertiary = Color(0xFF9CA3AF);

  static const Color onbBorder = Color(0xFFE5E7EB);

  static const Color releaseTeal = Color(0xFF14B8A6);
}
