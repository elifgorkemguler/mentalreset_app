import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/thought.dart';

class ReleaseThoughtCard extends StatelessWidget {
  final Thought thought;
  final VoidCallback? onTap;

  const ReleaseThoughtCard({
    super.key,
    required this.thought,
    this.onTap,
  });

  ({Color accent, String label}) _intensity() {
    switch (thought.intensity) {
      case ThoughtIntensity.high:
        return (accent: AppColors.intensityHigh, label: 'High Intensity');
      case ThoughtIntensity.low:
        return (accent: AppColors.intensityLow, label: 'Low Intensity');
      case ThoughtIntensity.medium:
      default:
        return (accent: AppColors.intensityMedium, label: 'Medium Intensity');
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = _intensity();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: AppShadows.subtle,
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(width: 4, color: style.accent),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.base,
                      AppSpacing.base,
                      AppSpacing.base,
                      AppSpacing.base,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          thought.content,
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: AppColors.textPrimary,
                            height: 1.45,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: style.accent,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              style.label,
                              style: AppTextStyles.labelMedium.copyWith(
                                color: style.accent,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
