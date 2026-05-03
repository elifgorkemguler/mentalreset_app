import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_colors.dart';
import '../theme/onb_text_styles.dart';

class SelectableCard extends StatelessWidget {
  final String title;
  final String? subtitle;

  /// Optional Lucide icon shown in a 32x32 light-tint container on the left.
  final IconData? leadingIcon;

  /// Optional widget shown on the trailing edge (rank badge, etc.).
  final Widget? trailing;

  /// Renders [subtitle] in italics — used by the AI tone screen.
  final bool subtitleItalic;

  final bool selected;
  final VoidCallback onTap;

  const SelectableCard({
    super.key,
    required this.title,
    required this.selected,
    required this.onTap,
    this.subtitle,
    this.leadingIcon,
    this.trailing,
    this.subtitleItalic = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color:
                selected ? AppColors.onbActionPurpleLight : AppColors.onbSurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? AppColors.onbActionPurple : AppColors.onbBorder,
              width: selected ? 1 : 0.5,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (leadingIcon != null) ...[
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.onbActionPurpleLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    leadingIcon,
                    size: 16,
                    color: AppColors.onbActionPurpleDark,
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: OnbTextStyles.cardTitle.copyWith(
                        color: selected
                            ? AppColors.onbActionPurpleDark
                            : AppColors.onbTextPrimary,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: subtitleItalic
                            ? OnbTextStyles.cardSubtitleItalic
                            : OnbTextStyles.cardSubtitle,
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 12),
                trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
