import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../data/onboarding_data.dart';
import '../theme/onb_text_styles.dart';
import '../widgets/onboarding_primary_button.dart';
import '../widgets/onboarding_scaffold.dart';
import '../widgets/selectable_card.dart';

class AiToneScreen extends StatefulWidget {
  const AiToneScreen({super.key});

  @override
  State<AiToneScreen> createState() => _AiToneScreenState();
}

class _AiToneScreenState extends State<AiToneScreen> {
  static const _tones = [
    (key: 'direct', title: 'Direct & honest', quote: "Putting this off won't help. Take one step now."),
    (key: 'warm', title: 'Warm & understanding', quote: "This sounds heavy. Let's find a small step together."),
    (key: 'coach', title: 'Motivating coach', quote: "You can do this! Let's tackle the first 10 minutes."),
    (key: 'reflective', title: 'Calm & reflective', quote: 'How long has this thought been with you? Let\'s sit with it.'),
  ];

  OnboardingData get _data => OnboardingData.instance;

  @override
  Widget build(BuildContext context) {
    return OnboardingScaffold(
      currentStep: 4,
      onSkip: () => context.go(AppRoutes.onboardingReady),
      bottomAction: OnboardingPrimaryButton(
        label: 'Continue',
        onPressed: _data.aiTone != null
            ? () => context.push(AppRoutes.onboardingGoals)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('4 / 6', style: OnbTextStyles.stepCounter),
          const SizedBox(height: 8),
          Text('How should we talk to you?', style: OnbTextStyles.h1),
          const SizedBox(height: 8),
          Text(
            'Pick a tone for your AI mentor. You can change it anytime.',
            style: OnbTextStyles.body,
          ),
          const SizedBox(height: 24),
          for (final t in _tones) ...[
            SelectableCard(
              title: t.title,
              subtitle: t.quote,
              subtitleItalic: true,
              selected: _data.aiTone == t.key,
              onTap: () => setState(() => _data.aiTone = t.key),
            ),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}
