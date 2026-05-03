import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_colors.dart';
import '../../../widgets/primary_gradient_button.dart';

class FocusActionControls extends StatelessWidget {
  final bool started;
  final VoidCallback onSkip;
  final VoidCallback onPrimary;

  const FocusActionControls({
    super.key,
    required this.started,
    required this.onSkip,
    required this.onPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _SkipButton(onTap: onSkip),
        const SizedBox(width: 12),
        Expanded(
          child: PrimaryGradientButton(
            label: started ? 'Pause session' : 'Start session',
            leadingIcon: started ? Icons.pause_rounded : Icons.play_arrow_rounded,
            onPressed: onPrimary,
            fullWidth: true,
          ),
        ),
      ],
    );
  }
}

class _SkipButton extends StatelessWidget {
  final VoidCallback onTap;

  const _SkipButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: const CircleBorder(side: BorderSide(color: AppColors.border)),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        child: const SizedBox(
          width: 56,
          height: 56,
          child: Icon(
            Icons.skip_next_rounded,
            color: AppColors.textSecondary,
            size: 24,
          ),
        ),
      ),
    );
  }
}
