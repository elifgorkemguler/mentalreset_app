import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class TimerCircle extends StatelessWidget {
  final Duration remaining;
  final double size;

  const TimerCircle({
    super.key,
    required this.remaining,
    this.size = 220,
  });

  String _format(Duration d) {
    final m = d.inMinutes.toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.border, width: 8),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _format(remaining),
                style: AppTextStyles.timerDisplay.copyWith(fontSize: 56),
              ),
              const SizedBox(height: 6),
              Text(
                'REMAINING',
                style: AppTextStyles.labelMedium.copyWith(
                  letterSpacing: 1.2,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
