import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/router/routes.dart';
import '../data/onboarding_data.dart';
import '../theme/onb_text_styles.dart';
import '../widgets/onboarding_primary_button.dart';
import '../widgets/onboarding_scaffold.dart';
import '../widgets/selectable_card.dart';
import '../widgets/selectable_chip.dart';

class AgeRoleScreen extends StatefulWidget {
  const AgeRoleScreen({super.key});

  @override
  State<AgeRoleScreen> createState() => _AgeRoleScreenState();
}

class _AgeRoleScreenState extends State<AgeRoleScreen> {
  static const _ages = ['16-18', '19-22', '23-26', '27-30', '30+'];

  static const _roles = [
    (key: 'student', title: "I'm a student", subtitle: 'High school or university', icon: LucideIcons.graduationCap),
    (key: 'working', title: "I'm working", subtitle: 'Full or part-time', icon: LucideIcons.briefcase),
    (key: 'both', title: 'Both', subtitle: 'Working student', icon: LucideIcons.layers),
    (key: 'transition', title: 'In transition', subtitle: 'Between things', icon: LucideIcons.compass),
  ];

  OnboardingData get _data => OnboardingData.instance;

  bool get _isValid => _data.ageRange != null && _data.roleKey != null;

  @override
  Widget build(BuildContext context) {
    return OnboardingScaffold(
      currentStep: 1,
      onSkip: () => context.go(AppRoutes.onboardingReady),
      bottomAction: OnboardingPrimaryButton(
        label: 'Continue',
        onPressed: _isValid
            ? () => context.push(AppRoutes.onboardingStressSources)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('1 / 6', style: OnbTextStyles.stepCounter),
          const SizedBox(height: 8),
          Text('Tell us a bit about you', style: OnbTextStyles.h1),
          const SizedBox(height: 8),
          Text('This helps us recommend the right content',
              style: OnbTextStyles.body),
          const SizedBox(height: 24),
          Text('YOUR AGE RANGE', style: OnbTextStyles.microLabel),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final age in _ages)
                SelectableChip(
                  label: age,
                  selected: _data.ageRange == age,
                  onTap: () => setState(() => _data.ageRange = age),
                ),
            ],
          ),
          const SizedBox(height: 24),
          Text('WHAT DESCRIBES YOU RIGHT NOW?',
              style: OnbTextStyles.microLabel),
          const SizedBox(height: 12),
          for (final role in _roles) ...[
            SelectableCard(
              title: role.title,
              subtitle: role.subtitle,
              leadingIcon: role.icon,
              selected: _data.roleKey == role.key,
              onTap: () => setState(() => _data.roleKey = role.key),
            ),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}
