import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/task_item.dart';

class TodoTaskCard extends StatelessWidget {
  final TaskItem task;
  final VoidCallback onToggleDone;
  final VoidCallback? onWhyTap;

  const TodoTaskCard({
    super.key,
    required this.task,
    required this.onToggleDone,
    this.onWhyTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: AppShadows.subtle,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.base),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _CircularCheckbox(
                  value: task.done,
                  onTap: () {
                    HapticFeedback.selectionClick();
                    onToggleDone();
                  },
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 1),
                    child: Text(
                      task.title,
                      style: AppTextStyles.titleMedium.copyWith(
                        decoration: task.done ? TextDecoration.lineThrough : null,
                        color: task.done
                            ? AppColors.textMuted
                            : AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
                if (task.flagged) ...[
                  const SizedBox(width: AppSpacing.sm),
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppColors.intensityHighBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.priority_high_rounded,
                      size: 14,
                      color: AppColors.intensityHigh,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Padding(
              padding: const EdgeInsets.only(left: 36),
              child: Row(
                children: [
                  _CategoryPill(category: task.category),
                  const SizedBox(width: AppSpacing.md),
                  const Icon(Icons.schedule_rounded,
                      size: 14, color: AppColors.textMuted),
                  const SizedBox(width: 4),
                  Text(
                    _formatDuration(task.estimated),
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ),
            if (task.whyItMatters != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Padding(
                padding: const EdgeInsets.only(left: 36),
                child: InkWell(
                  borderRadius: BorderRadius.circular(6),
                  onTap: () {
                    HapticFeedback.selectionClick();
                    onWhyTap?.call();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.auto_awesome_rounded,
                            size: 14, color: AppColors.primary),
                        const SizedBox(width: 6),
                        Text(
                          'Why this matters',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration d) {
    if (d.inHours > 0 && d.inMinutes % 60 == 0) return '${d.inHours} hr';
    if (d.inHours > 0) return '${d.inHours}h ${d.inMinutes % 60}m';
    return '${d.inMinutes} min';
  }
}

class _CircularCheckbox extends StatelessWidget {
  final bool value;
  final VoidCallback onTap;

  const _CircularCheckbox({required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: value ? AppColors.primary : Colors.transparent,
            border: Border.all(
              color: value ? AppColors.primary : AppColors.border,
              width: 1.5,
            ),
          ),
          child: value
              ? const Icon(Icons.check_rounded, size: 16, color: Colors.white)
              : null,
        ),
      ),
    );
  }
}

class _CategoryPill extends StatelessWidget {
  final TaskCategory category;

  const _CategoryPill({required this.category});

  ({Color background, Color foreground}) _style() {
    switch (category) {
      case TaskCategory.school:
        return (
          background: AppColors.accentLavender,
          foreground: AppColors.accentLavenderDeep,
        );
      case TaskCategory.personal:
        return (
          background: AppColors.accentMint,
          foreground: AppColors.accentMintDeep,
        );
      case TaskCategory.work:
        return (
          background: AppColors.accentSky,
          foreground: AppColors.accentSkyDeep,
        );
      case TaskCategory.family:
        return (
          background: AppColors.accentPeach,
          foreground: AppColors.accentPeachDeep,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = _style();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: s.background,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        category.label,
        style: AppTextStyles.labelSmall.copyWith(
          color: s.foreground,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
        ),
      ),
    );
  }
}
