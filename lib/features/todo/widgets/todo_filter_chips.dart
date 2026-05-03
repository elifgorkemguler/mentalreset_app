import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/task_item.dart';

/// `null` selected = "All".
class TodoFilterChips extends StatelessWidget {
  final TaskCategory? selected;
  final ValueChanged<TaskCategory?> onChanged;

  const TodoFilterChips({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  static const _options = <TaskCategory?>[
    null,
    TaskCategory.work,
    TaskCategory.school,
    TaskCategory.family,
    TaskCategory.personal,
  ];

  String _label(TaskCategory? c) => c == null ? 'All' : c.label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        itemCount: _options.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final c = _options[i];
          final isSelected = selected == c;
          return _Chip(
            label: _label(c),
            selected: isSelected,
            onTap: () {
              HapticFeedback.selectionClick();
              onChanged(c);
            },
          );
        },
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.md),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.base, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? AppColors.textPrimary : AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: selected ? AppColors.textPrimary : AppColors.border,
              width: 1,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: AppTextStyles.labelLarge.copyWith(
              color: selected ? AppColors.textOnPrimary : AppColors.textSecondary,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
