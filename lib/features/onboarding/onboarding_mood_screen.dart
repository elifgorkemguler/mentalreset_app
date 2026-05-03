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

class OnboardingMoodScreen extends StatefulWidget {
  const OnboardingMoodScreen({super.key});

  @override
  State<OnboardingMoodScreen> createState() => _OnboardingMoodScreenState();
}

class _OnboardingMoodScreenState extends State<OnboardingMoodScreen> {
  String? _selectedId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => context.go(AppRoutes.onboardingIntent),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ProgressDots(total: 2, current: 1),
              const SizedBox(height: AppSpacing.xl),
              Text('Which word best describes how you feel right now?',
                  style: AppTextStyles.displayMedium.copyWith(fontSize: 26)),
              const SizedBox(height: AppSpacing.lg),
              Expanded(
                child: ListView.separated(
                  itemCount: MockData.onboardingMoods.length,
                  separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.md),
                  itemBuilder: (_, i) {
                    final mood = MockData.onboardingMoods[i];
                    return OptionCard(
                      emoji: mood.emoji,
                      label: mood.label,
                      accent: mood.accent,
                      selected: _selectedId == mood.id,
                      onTap: () => setState(() => _selectedId = mood.id),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.base),
              PrimaryGradientButton(
                label: 'Complete',
                trailingIcon: Icons.check_rounded,
                onPressed: _selectedId == null
                    ? null
                    : () => context.go(AppRoutes.onboardingComplete),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}
