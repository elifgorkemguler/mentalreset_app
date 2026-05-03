import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import 'focus_action_controls.dart';
import 'session_type_toggle.dart';
import 'timer_circle.dart';

class FocusSessionCard extends StatelessWidget {
  final SessionType sessionType;
  final ValueChanged<SessionType> onSessionTypeChanged;
  final String currentTask;
  final Duration remaining;
  final bool started;
  final VoidCallback onSkip;
  final VoidCallback onPrimary;

  const FocusSessionCard({
    super.key,
    required this.sessionType,
    required this.onSessionTypeChanged,
    required this.currentTask,
    required this.remaining,
    required this.started,
    required this.onSkip,
    required this.onPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SessionTypeToggle(
            value: sessionType,
            onChanged: onSessionTypeChanged,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'CURRENT TASK',
            style: AppTextStyles.labelMedium.copyWith(
              letterSpacing: 1.2,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 4),
          Text(currentTask, style: AppTextStyles.titleLarge),
          const SizedBox(height: AppSpacing.xl),
          Center(child: TimerCircle(remaining: remaining)),
          const SizedBox(height: AppSpacing.xl),
          FocusActionControls(
            started: started,
            onSkip: onSkip,
            onPrimary: onPrimary,
          ),
        ],
      ),
    );
  }
}
