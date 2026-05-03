import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_radius.dart' show AppRadius;
import '../core/theme/app_shadows.dart';
import '../core/theme/app_spacing.dart';

class SoftCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final Color? color;
  final Gradient? gradient;
  final List<BoxShadow>? boxShadow;
  final BorderRadiusGeometry? borderRadius;

  const SoftCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.cardPadding),
    this.color,
    this.gradient,
    this.boxShadow,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: gradient == null ? (color ?? AppColors.surface) : null,
        gradient: gradient,
        borderRadius: borderRadius ?? BorderRadius.circular(AppRadius.xl),
        boxShadow: boxShadow ?? AppShadows.card,
      ),
      child: child,
    );
  }
}
