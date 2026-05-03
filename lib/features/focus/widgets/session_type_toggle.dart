import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_text_styles.dart';

enum SessionType { deepWork, breakTime }

class SessionTypeToggle extends StatelessWidget {
  final SessionType value;
  final ValueChanged<SessionType> onChanged;

  const SessionTypeToggle({
    super.key,
    required this.value,
    required this.onChanged,
  });

  String _label(SessionType t) =>
      t == SessionType.deepWork ? 'Deep Work' : 'Break';

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: [
        for (final t in SessionType.values)
          _Pill(
            label: _label(t),
            selected: value == t,
            onTap: () {
              HapticFeedback.selectionClick();
              onChanged(t);
            },
          ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _Pill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.pill),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? AppColors.textPrimary : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: selected
                ? null
                : Border.all(color: AppColors.border, width: 1),
          ),
          child: Text(
            label,
            style: AppTextStyles.labelLarge.copyWith(
              color:
                  selected ? AppColors.textOnPrimary : AppColors.textSecondary,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
