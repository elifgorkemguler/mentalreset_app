import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/concern_metric.dart';

class ConcernProgressRow extends StatelessWidget {
  final ConcernMetric concern;

  const ConcernProgressRow({super.key, required this.concern});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 120,
          child: Text(
            concern.label,
            style: AppTextStyles.bodyMedium
                .copyWith(color: AppColors.textPrimary),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: concern.percentage / 100,
              minHeight: 6,
              backgroundColor: AppColors.surfaceMuted,
              valueColor: AlwaysStoppedAnimation(concern.color),
            ),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 36,
          child: Text(
            '${concern.percentage}%',
            textAlign: TextAlign.right,
            style: AppTextStyles.bodyMedium
                .copyWith(color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }
}
