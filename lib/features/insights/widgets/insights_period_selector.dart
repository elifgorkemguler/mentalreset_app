import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_text_styles.dart';

enum InsightsPeriod { week, month, year }

class InsightsPeriodSelector extends StatelessWidget {
  final InsightsPeriod value;
  final ValueChanged<InsightsPeriod> onChanged;

  const InsightsPeriodSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  String _label(InsightsPeriod p) {
    switch (p) {
      case InsightsPeriod.week:
        return 'Week';
      case InsightsPeriod.month:
        return 'Month';
      case InsightsPeriod.year:
        return 'Year';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        children: [
          for (final p in InsightsPeriod.values)
            Expanded(
              child: _Segment(
                label: _label(p),
                selected: value == p,
                onTap: () {
                  HapticFeedback.selectionClick();
                  onChanged(p);
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _Segment({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: selected ? AppColors.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          boxShadow: selected ? AppShadows.subtle : const [],
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppTextStyles.labelLarge.copyWith(
            color: selected ? AppColors.textPrimary : AppColors.textSecondary,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
