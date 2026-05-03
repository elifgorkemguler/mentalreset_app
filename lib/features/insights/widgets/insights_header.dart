import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class InsightsHeader extends StatelessWidget {
  const InsightsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.accentMint,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          alignment: Alignment.center,
          child: const Icon(
            Icons.trending_up_rounded,
            color: AppColors.accentMintDeep,
            size: 24,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Insights', style: AppTextStyles.displayMedium),
              const SizedBox(height: 2),
              Text('Track your growth journey',
                  style: AppTextStyles.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}
