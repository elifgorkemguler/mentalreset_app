import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../data/onboarding_data.dart';
import '../theme/onb_text_styles.dart';
import '../widgets/onboarding_primary_button.dart';
import '../widgets/onboarding_scaffold.dart';
import '../widgets/selectable_card.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  static const _goals = [
    (key: 'clear', title: 'Clear my mind'),
    (key: 'productive', title: 'Be more productive'),
    (key: 'anxiety', title: 'Manage anxiety'),
    (key: 'routine', title: 'Build a routine'),
    (key: 'understand', title: 'Understand myself'),
  ];

  static const _maxRanked = 2;

  OnboardingData get _data => OnboardingData.instance;

  void _tap(String key) {
    setState(() {
      final idx = _data.rankedGoals.indexOf(key);
      if (idx >= 0) {
        _data.rankedGoals.removeAt(idx);
      } else if (_data.rankedGoals.length < _maxRanked) {
        _data.rankedGoals.add(key);
      }
      // 3rd tap silently ignored.
    });
  }

  @override
  Widget build(BuildContext context) {
    final canContinue = _data.rankedGoals.length == _maxRanked;
    return OnboardingScaffold(
      currentStep: 5,
      onSkip: () => context.go(AppRoutes.onboardingReady),
      bottomAction: OnboardingPrimaryButton(
        label: 'Continue',
        onPressed:
            canContinue ? () => context.push(AppRoutes.onboardingReady) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('5 / 6', style: OnbTextStyles.stepCounter),
          const SizedBox(height: 8),
          Text('What do you want from this app?', style: OnbTextStyles.h1),
          const SizedBox(height: 8),
          Text("Rank your top 2. We'll set your streak goal accordingly.",
              style: OnbTextStyles.body),
          const SizedBox(height: 24),
          for (final g in _goals) ...[
            Builder(builder: (_) {
              final rank = _data.rankedGoals.indexOf(g.key);
              final selected = rank >= 0;
              return SelectableCard(
                title: g.title,
                selected: selected,
                onTap: () => _tap(g.key),
                trailing: selected ? _RankBadge(rank: rank + 1) : null,
              );
            }),
            const SizedBox(height: 8),
          ],
          const SizedBox(height: 12),
          _FrequencyPanel(
            value: _data.weeklyFrequency,
            onChanged: (v) =>
                setState(() => _data.weeklyFrequency = v.round()),
          ),
        ],
      ),
    );
  }
}

class _RankBadge extends StatelessWidget {
  final int rank;
  const _RankBadge({required this.rank});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.onbGradientStart, AppColors.onbGradientEnd],
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        '$rank',
        style: OnbTextStyles.cardTitle.copyWith(color: Colors.white),
      ),
    );
  }
}

class _FrequencyPanel extends StatelessWidget {
  final int value;
  final ValueChanged<double> onChanged;

  const _FrequencyPanel({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.onbSurfaceSecondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'How often do you want to use this?',
                  style: OnbTextStyles.cardSubtitle.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.onbTextSecondary,
                  ),
                ),
              ),
              Text('$value days/week', style: OnbTextStyles.sliderValue),
            ],
          ),
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 3,
              activeTrackColor: AppColors.onbActionPurple,
              inactiveTrackColor: AppColors.onbBorder,
              thumbColor: AppColors.onbActionPurple,
              overlayColor: AppColors.onbActionPurpleLight,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
              showValueIndicator: ShowValueIndicator.never,
            ),
            child: Slider(
              min: 1,
              max: 7,
              divisions: 6,
              value: value.toDouble(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
