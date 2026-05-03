import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/soft_card.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        children: [
          Text('Insights', style: AppTextStyles.displayMedium),
          const SizedBox(height: 4),
          Text('Track your growth journey', style: AppTextStyles.bodyMedium),
          const SizedBox(height: AppSpacing.xl),
          SoftCard(
            child: Text(
              'Full Insights coming in phase 2 — weekly insight, stats grid, mental release trend chart.',
              style: AppTextStyles.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}
