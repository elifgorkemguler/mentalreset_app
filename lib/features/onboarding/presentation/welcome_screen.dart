import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../theme/onb_text_styles.dart';
import '../widgets/onboarding_primary_button.dart';
import '../widgets/onboarding_scaffold.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  static const _benefits = [
    'Personalized AI guidance',
    'Tasks tailored to how you think',
    'Coping strategies that fit your style',
  ];

  @override
  Widget build(BuildContext context) {
    return OnboardingScaffold(
      showBack: false,
      currentStep: 0,
      bottomAction: OnboardingPrimaryButton(
        label: "Let's start",
        onPressed: () => context.push(AppRoutes.onboardingAgeRole),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.onbGradientStart, AppColors.onbGradientEnd],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.psychology_alt_rounded,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text('Welcome to Mental Reset',
              style: OnbTextStyles.h1Hero, textAlign: TextAlign.left),
          const SizedBox(height: 8),
          Text(
            'We have 6 quick questions so we can build your AI mentor. Takes about 90 seconds.',
            style: OnbTextStyles.body,
          ),
          const SizedBox(height: 28),
          for (final b in _benefits) ...[
            _BenefitRow(text: b),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _BenefitRow extends StatelessWidget {
  final String text;
  const _BenefitRow({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.onbGradientStart, AppColors.onbGradientEnd],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: OnbTextStyles.bodyPrimary)),
      ],
    );
  }
}
