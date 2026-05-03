import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/soft_card.dart';

class FocusScreen extends StatelessWidget {
  const FocusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        children: [
          Text('Focus', style: AppTextStyles.displayMedium),
          const SizedBox(height: 4),
          Text('Deep work, mindful breaks', style: AppTextStyles.bodyMedium),
          const SizedBox(height: AppSpacing.xl),
          SoftCard(
            child: Text(
              'Full Focus flow coming in phase 2 — Timer/Breathing toggle, working Pomodoro, duration picker.',
              style: AppTextStyles.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}
