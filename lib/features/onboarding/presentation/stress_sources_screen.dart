import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/router/routes.dart';
import '../data/onboarding_data.dart';
import '../theme/onb_text_styles.dart';
import '../widgets/onboarding_primary_button.dart';
import '../widgets/onboarding_scaffold.dart';
import '../widgets/selectable_chip.dart';

class StressSourcesScreen extends StatefulWidget {
  const StressSourcesScreen({super.key});

  @override
  State<StressSourcesScreen> createState() => _StressSourcesScreenState();
}

class _StressSourcesScreenState extends State<StressSourcesScreen> {
  static const _sources = [
    (key: 'school', label: 'School / Exams', icon: LucideIcons.graduationCap),
    (key: 'work', label: 'Work / Career', icon: LucideIcons.briefcase),
    (key: 'relationships', label: 'Relationships', icon: LucideIcons.messageCircle),
    (key: 'family', label: 'Family', icon: LucideIcons.home),
    (key: 'money', label: 'Money', icon: LucideIcons.wallet),
    (key: 'social', label: 'Social media', icon: LucideIcons.smartphone),
    (key: 'future', label: 'The future', icon: LucideIcons.compass),
    (key: 'health', label: 'Health', icon: LucideIcons.heart),
    (key: 'uncertainty', label: 'Uncertainty', icon: LucideIcons.helpCircle),
  ];

  static const _maxSelected = 3;

  OnboardingData get _data => OnboardingData.instance;

  void _toggle(String key) {
    setState(() {
      if (_data.stressSources.contains(key)) {
        _data.stressSources.remove(key);
      } else if (_data.stressSources.length < _maxSelected) {
        _data.stressSources.add(key);
      }
      // 4th tap is silently ignored — brief.
    });
  }

  @override
  Widget build(BuildContext context) {
    final count = _data.stressSources.length;
    return OnboardingScaffold(
      currentStep: 2,
      onSkip: () => context.go(AppRoutes.onboardingReady),
      bottomAction: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$count / $_maxSelected selected',
              style: OnbTextStyles.cardSubtitle),
          const SizedBox(height: 8),
          OnboardingPrimaryButton(
            label: 'Continue',
            onPressed: count >= 1
                ? () => context.push(AppRoutes.onboardingStressResponse)
                : null,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('2 / 6', style: OnbTextStyles.stepCounter),
          const SizedBox(height: 8),
          Text("What's most on your mind?", style: OnbTextStyles.h1),
          const SizedBox(height: 8),
          Text('Pick up to 3. Our AI uses this to suggest tasks.',
              style: OnbTextStyles.body),
          const SizedBox(height: 24),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final s in _sources)
                SelectableChip(
                  label: s.label,
                  leadingIcon: s.icon,
                  selected: _data.stressSources.contains(s.key),
                  onTap: () => _toggle(s.key),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
