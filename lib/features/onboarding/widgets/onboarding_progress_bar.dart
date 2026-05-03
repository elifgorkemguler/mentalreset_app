import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// 6 horizontal segments, 3px tall, 4px gaps, full-width.
/// Active/completed segments use [AppColors.onbTextPrimary] (near-black).
/// Purple is reserved for the CTA — never used here.
class OnboardingProgressBar extends StatelessWidget {
  static const int totalSteps = 6;

  /// 0..6. 0 = no segments active. 6 = all active.
  final int currentStep;

  const OnboardingProgressBar({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps, (i) {
        final active = i < currentStep;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i == totalSteps - 1 ? 0 : 4),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 3,
              decoration: BoxDecoration(
                color: active ? AppColors.onbTextPrimary : AppColors.onbBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        );
      }),
    );
  }
}
