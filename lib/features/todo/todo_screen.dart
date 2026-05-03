import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/soft_card.dart';

class TodoScreen extends StatelessWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        children: [
          Text('To-Do', style: AppTextStyles.displayMedium),
          const SizedBox(height: 4),
          Text('Turn thoughts into action', style: AppTextStyles.bodyMedium),
          const SizedBox(height: AppSpacing.xl),
          SoftCard(
            child: Text(
              'Full To-Do flow coming in phase 2 — category filters, task cards, "why this matters" link.',
              style: AppTextStyles.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}
