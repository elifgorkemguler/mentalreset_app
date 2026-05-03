import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class FocusHeader extends StatelessWidget {
  const FocusHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.accentLavender,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          alignment: Alignment.center,
          child: const Icon(
            Icons.bolt_rounded,
            color: AppColors.primary,
            size: 26,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Focus', style: AppTextStyles.displayMedium),
              const SizedBox(height: 2),
              Text('Deep work, mindful breaks',
                  style: AppTextStyles.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}
