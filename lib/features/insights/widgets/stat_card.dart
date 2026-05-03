import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/insight_stat.dart';

class StatCard extends StatelessWidget {
  final InsightStat stat;

  const StatCard({super.key, required this.stat});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.base),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: AppShadows.subtle,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: stat.iconBackground,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            alignment: Alignment.center,
            child: Icon(stat.icon, color: stat.iconForeground, size: 18),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(stat.label, style: AppTextStyles.bodyMedium),
          const SizedBox(height: 2),
          Text(
            stat.value,
            style: AppTextStyles.displayMedium.copyWith(
              fontSize: 26,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            stat.supportingText,
            style: AppTextStyles.bodySmall.copyWith(
              color: stat.isPositiveTrend
                  ? AppColors.success
                  : AppColors.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
