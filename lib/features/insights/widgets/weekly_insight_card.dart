import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class WeeklyInsightCard extends StatelessWidget {
  final String title;
  final String body;

  /// Substring of [body] to render in primary purple. If absent in [body] the
  /// whole sentence renders in muted secondary text.
  final String highlight;

  const WeeklyInsightCard({
    super.key,
    required this.title,
    required this.body,
    required this.highlight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: AppShadows.subtle,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.accentLavender,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: AppTextStyles.titleMedium),
                const SizedBox(height: 6),
                Text.rich(_buildBody()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  TextSpan _buildBody() {
    final base = AppTextStyles.bodyMedium
        .copyWith(color: AppColors.textSecondary, height: 1.5);
    final accent = AppTextStyles.bodyMedium.copyWith(
      color: AppColors.primary,
      fontWeight: FontWeight.w600,
    );

    if (highlight.isEmpty || !body.contains(highlight)) {
      return TextSpan(text: body, style: base);
    }
    final start = body.indexOf(highlight);
    final end = start + highlight.length;
    return TextSpan(
      style: base,
      children: [
        TextSpan(text: body.substring(0, start)),
        TextSpan(text: highlight, style: accent),
        TextSpan(text: body.substring(end)),
      ],
    );
  }
}
