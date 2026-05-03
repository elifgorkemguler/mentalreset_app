import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/theme/app_colors.dart';
import '../theme/onb_text_styles.dart';
import 'onboarding_progress_bar.dart';

/// Wraps every onboarding screen — safe-area, optional back arrow + skip,
/// optional progress bar, scrollable content, and a bottom-anchored CTA.
class OnboardingScaffold extends StatelessWidget {
  final bool showBack;
  final VoidCallback? onSkip;
  final int? currentStep;
  final Widget child;
  final Widget? bottomAction;

  const OnboardingScaffold({
    super.key,
    required this.child,
    this.showBack = true,
    this.onSkip,
    this.currentStep,
    this.bottomAction,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.onbBackground,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(showBack: showBack, onSkip: onSkip),
            if (currentStep != null) ...[
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: OnboardingProgressBar(currentStep: currentStep!),
              ),
            ],
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                child: child,
              ),
            ),
            if (bottomAction != null)
              Padding(
                padding: EdgeInsets.fromLTRB(
                  20,
                  8,
                  20,
                  24 + MediaQuery.of(context).viewInsets.bottom,
                ),
                child: bottomAction,
              ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final bool showBack;
  final VoidCallback? onSkip;

  const _TopBar({required this.showBack, required this.onSkip});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            SizedBox(
              width: 44,
              child: showBack
                  ? IconButton(
                      icon: const Icon(LucideIcons.arrowLeft,
                          size: 24, color: AppColors.onbTextSecondary),
                      onPressed: () {
                        if (context.canPop()) {
                          context.pop();
                        }
                      },
                    )
                  : null,
            ),
            const Spacer(),
            if (onSkip != null)
              TextButton(
                onPressed: onSkip,
                style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  minimumSize: const Size(0, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text('Skip', style: OnbTextStyles.skip),
              ),
          ],
        ),
      ),
    );
  }
}
