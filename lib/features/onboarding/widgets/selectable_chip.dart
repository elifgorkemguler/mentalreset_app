import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_colors.dart';
import '../theme/onb_text_styles.dart';

class SelectableChip extends StatelessWidget {
  final String label;
  final IconData? leadingIcon;
  final bool selected;
  final VoidCallback onTap;

  const SelectableChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.leadingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? AppColors.onbActionPurpleLight : AppColors.onbSurface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? AppColors.onbActionPurple : AppColors.onbBorder,
              width: selected ? 1 : 0.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (leadingIcon != null) ...[
                Icon(
                  leadingIcon,
                  size: 14,
                  color: selected
                      ? AppColors.onbActionPurpleDark
                      : AppColors.onbTextSecondary,
                ),
                const SizedBox(width: 6),
              ],
              Text(label,
                  style:
                      selected ? OnbTextStyles.chipSelected : OnbTextStyles.chip),
            ],
          ),
        ),
      ),
    );
  }
}
