import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/mock_data.dart';
import '../../core/router/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/option_card.dart';
import '../../widgets/primary_gradient_button.dart';
import '../../widgets/progress_dots.dart';

class OnboardingIntentScreen extends StatefulWidget {
  const OnboardingIntentScreen({super.key});

  @override
  State<OnboardingIntentScreen> createState() => _OnboardingIntentScreenState();
}

class _OnboardingIntentScreenState extends State<OnboardingIntentScreen> {
  String? _selectedId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.lg),
              const ProgressDots(total: 2, current: 0),
              const SizedBox(height: AppSpacing.xl),
              Text('Hello, ${MockData.userName}!', style: AppTextStyles.displayMedium),
              const SizedBox(height: 6),
              Text('We want to get to know you better',
                  style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary)),
              const SizedBox(height: AppSpacing.xxl),
              Text('What would help you most right now?',
                  style: AppTextStyles.headlineMedium),
              const SizedBox(height: AppSpacing.lg),
              Expanded(
                child: ListView.separated(
                  itemCount: MockData.intents.length,
                  separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.md),
                  itemBuilder: (_, i) {
                    final option = MockData.intents[i];
                    return OptionCard(
                      emoji: option.emoji,
                      label: option.label,
                      description: option.description,
                      accent: option.accent,
                      selected: _selectedId == option.id,
                      onTap: () => setState(() => _selectedId = option.id),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.base),
              PrimaryGradientButton(
                label: 'Continue',
                trailingIcon: Icons.arrow_forward_rounded,
                onPressed: _selectedId == null
                    ? null
                    : () => context.go(AppRoutes.onboardingMood),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}
