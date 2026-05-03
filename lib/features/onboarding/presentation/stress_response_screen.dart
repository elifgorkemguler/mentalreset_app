import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/router/routes.dart';
import '../data/onboarding_data.dart';
import '../theme/onb_text_styles.dart';
import '../widgets/onboarding_primary_button.dart';
import '../widgets/onboarding_scaffold.dart';
import '../widgets/selectable_card.dart';

class StressResponseScreen extends StatefulWidget {
  const StressResponseScreen({super.key});

  @override
  State<StressResponseScreen> createState() => _StressResponseScreenState();
}

class _StressResponseScreenState extends State<StressResponseScreen> {
  static const _items = [
    (key: 'freeze', title: 'Freeze up', subtitle: 'Hard to start, hard to move', icon: LucideIcons.pauseCircle),
    (key: 'overthink', title: 'Overthink', subtitle: 'Mind spins, scenarios multiply', icon: LucideIcons.refreshCw),
    (key: 'procrastinate', title: 'Procrastinate', subtitle: 'Tomorrow, not now', icon: LucideIcons.clock),
    (key: 'distract', title: 'Distract yourself', subtitle: 'Scrolling, snacking, escaping', icon: LucideIcons.shuffle),
  ];

  OnboardingData get _data => OnboardingData.instance;

  @override
  Widget build(BuildContext context) {
    return OnboardingScaffold(
      currentStep: 3,
      onSkip: () => context.go(AppRoutes.onboardingReady),
      bottomAction: OnboardingPrimaryButton(
        label: 'Continue',
        onPressed: _data.stressResponse != null
            ? () => context.push(AppRoutes.onboardingAiTone)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('3 / 6', style: OnbTextStyles.stepCounter),
          const SizedBox(height: 8),
          Text('When stressed, you tend to...', style: OnbTextStyles.h1),
          const SizedBox(height: 8),
          Text('Our AI will speak to you the way you respond best',
              style: OnbTextStyles.body),
          const SizedBox(height: 24),
          for (final i in _items) ...[
            SelectableCard(
              title: i.title,
              subtitle: i.subtitle,
              leadingIcon: i.icon,
              selected: _data.stressResponse == i.key,
              onTap: () => setState(() => _data.stressResponse = i.key),
            ),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}
