import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/soft_card.dart';

class ReleaseScreen extends StatelessWidget {
  const ReleaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        children: [
          Text('Release', style: AppTextStyles.displayMedium),
          const SizedBox(height: 4),
          Text('Let go of what weighs you down', style: AppTextStyles.bodyMedium),
          const SizedBox(height: AppSpacing.xl),
          SoftCard(
            child: Text(
              'Full Release flow coming in phase 2 — drag-to-trash thought cards with intensity colors.',
              style: AppTextStyles.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}
