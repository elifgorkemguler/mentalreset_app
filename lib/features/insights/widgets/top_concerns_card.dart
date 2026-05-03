import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/concern_metric.dart';
import 'concern_progress_row.dart';

class TopConcernsCard extends StatelessWidget {
  final List<ConcernMetric> concerns;

  const TopConcernsCard({super.key, required this.concerns});

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Top concerns this week', style: AppTextStyles.titleMedium),
          const SizedBox(height: AppSpacing.base),
          for (var i = 0; i < concerns.length; i++) ...[
            ConcernProgressRow(concern: concerns[i]),
            if (i != concerns.length - 1)
              const SizedBox(height: AppSpacing.md),
          ],
        ],
      ),
    );
  }
}
