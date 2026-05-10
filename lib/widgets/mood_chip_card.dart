import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_radius.dart' show AppRadius;
import '../core/theme/app_shadows.dart';
import '../core/theme/app_text_styles.dart';
import '../models/mood.dart';

class MoodChipCard extends StatelessWidget {
  final Mood mood;
  final bool selected;
  final VoidCallback onTap;
  final double width;

  const MoodChipCard({
    super.key,
    required this.mood,
    required this.selected,
    required this.onTap,
    this.width = 96,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      width: width,
      decoration: BoxDecoration(
        color: selected ? mood.accent : AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(
          color: selected ? AppColors.primary : AppColors.border,
          width: selected ? 2 : 1.2,
        ),
        boxShadow: selected ? AppShadows.cardLift : AppShadows.card,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          onTap: () {
            HapticFeedback.selectionClick();
            onTap();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(mood.emoji, style: const TextStyle(fontSize: 30)),
                const SizedBox(height: 6),
                Text(
                  mood.label,
                  style: AppTextStyles.labelLarge,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
