import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/breathing_exercise.dart';
import '../../onboarding/data/onboarding_data.dart';
import '../data/breathing_exercises.dart';

class BreathingPicker extends StatelessWidget {
  final ValueChanged<BreathingExercise> onPick;

  const BreathingPicker({super.key, required this.onPick});

  @override
  Widget build(BuildContext context) {
    final response = OnboardingData.instance.stressResponse;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Pick a breathing exercise',
          style: AppTextStyles.titleLarge,
        ),
        const SizedBox(height: 4),
        Text(
          'A few minutes resets your nervous system.',
          style: AppTextStyles.bodyMedium,
        ),
        const SizedBox(height: AppSpacing.lg),
        for (final ex in BreathingExercises.all) ...[
          _ExerciseCard(
            exercise: ex,
            recommended: response != null && ex.recommendedFor == response,
            onTap: () {
              HapticFeedback.selectionClick();
              onPick(ex);
            },
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ],
    );
  }
}

class _ExerciseCard extends StatelessWidget {
  final BreathingExercise exercise;
  final bool recommended;
  final VoidCallback onTap;

  const _ExerciseCard({
    required this.exercise,
    required this.recommended,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.base),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColors.border, width: 1),
            boxShadow: AppShadows.subtle,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.accentSky,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.air_rounded,
                    color: AppColors.accentSkyDeep, size: 22),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(exercise.name,
                              style: AppTextStyles.titleMedium),
                        ),
                        if (recommended)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.accentLavender,
                              borderRadius: BorderRadius.circular(99),
                            ),
                            child: Text(
                              'For you',
                              style: AppTextStyles.labelSmall.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(exercise.tagline, style: AppTextStyles.bodySmall),
                    const SizedBox(height: 6),
                    Text(exercise.summary, style: AppTextStyles.bodyMedium),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right_rounded,
                  color: AppColors.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}
