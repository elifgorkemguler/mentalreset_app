import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/service_locator.dart';
import '../../../models/concern_metric.dart';
import '../../../models/insight_stat.dart';
import '../../onboarding/data/onboarding_data.dart';
import '../../todo/data/task_recommender.dart';

class InsightsSnapshot {
  final List<InsightStat> stats;
  final String weeklyInsightTitle;
  final String weeklyInsightBody;
  final String weeklyInsightHighlight;
  final List<ConcernMetric> concerns;

  const InsightsSnapshot({
    required this.stats,
    required this.weeklyInsightTitle,
    required this.weeklyInsightBody,
    required this.weeklyInsightHighlight,
    required this.concerns,
  });
}

class InsightsProvider {
  InsightsProvider._();

  static Future<InsightsSnapshot> snapshot() async {
    final repo = ServiceLocator.thoughts;
    final activeReleases = await repo.fetchReleaseThoughts();
    final captured = activeReleases.length;
    final tasks = TaskRecommender.recommend();
    final openTasks = tasks.where((t) => !t.done).length;

    final d = OnboardingData.instance;

    return InsightsSnapshot(
      stats: _buildStats(captured, openTasks, d),
      weeklyInsightTitle: _insightTitle(d),
      weeklyInsightBody: _insightBody(d, captured),
      weeklyInsightHighlight: _insightHighlight(d, captured),
      concerns: _buildConcerns(d),
    );
  }

  // ---------------------------------------------------------------------------
  // Stats
  // ---------------------------------------------------------------------------

  static List<InsightStat> _buildStats(int captured, int openTasks, OnboardingData d) {
    final freq = d.weeklyFrequency;
    return [
      InsightStat(
        label: 'Captured',
        value: '$captured',
        supportingText: captured == 0
            ? 'Speak or write to add'
            : 'Ready to release',
        icon: Icons.air_rounded,
        iconBackground: AppColors.accentMint,
        iconForeground: AppColors.accentMintDeep,
        isPositiveTrend: captured > 0,
      ),
      InsightStat(
        label: 'To-do',
        value: '$openTasks',
        supportingText: openTasks == 0
            ? "You're caught up"
            : 'Recommended for you',
        icon: Icons.task_alt_rounded,
        iconBackground: AppColors.accentPeach,
        iconForeground: AppColors.accentPeachDeep,
        isPositiveTrend: openTasks > 0,
      ),
      InsightStat(
        label: 'Goal',
        value: '$freq',
        supportingText: 'days / week',
        icon: Icons.bolt_rounded,
        iconBackground: AppColors.accentLavender,
        iconForeground: AppColors.primary,
      ),
      InsightStat(
        label: 'Tone',
        value: _toneLabel(d.aiTone),
        supportingText: 'AI mentor style',
        icon: Icons.local_fire_department_rounded,
        iconBackground: AppColors.accentRose,
        iconForeground: AppColors.accentRoseDeep,
      ),
    ];
  }

  static String _toneLabel(String? tone) {
    return switch (tone) {
      'direct' => 'Direct',
      'warm' => 'Warm',
      'coach' => 'Coach',
      'reflective' => 'Calm',
      _ => '—',
    };
  }

  // ---------------------------------------------------------------------------
  // Weekly insight card
  // ---------------------------------------------------------------------------

  static String _insightTitle(OnboardingData d) {
    return switch (d.aiTone) {
      'direct' => 'Real talk',
      'warm' => 'Notice this',
      'coach' => "Here's the win",
      'reflective' => 'Just noticing',
      _ => "This week's pattern",
    };
  }

  static String _insightHighlight(OnboardingData d, int captured) {
    if (captured == 0) return 'one small step';
    if (d.stressSources.isNotEmpty) {
      return _stressLabel(d.stressSources.first);
    }
    return '$captured thoughts';
  }

  static String _insightBody(OnboardingData d, int captured) {
    if (captured == 0) {
      return d.stressSources.isEmpty
          ? 'Capture a thought to start spotting patterns.'
          : "Capture what's on your mind around ${_stressLabel(d.stressSources.first)} — one small step is all it takes.";
    }
    final topConcern = d.stressSources.isNotEmpty
        ? _stressLabel(d.stressSources.first)
        : 'whatever surfaces';
    return switch (d.aiTone) {
      'direct' =>
        "You've captured $captured thought${captured == 1 ? '' : 's'}. Most touch on $topConcern — keep moving.",
      'warm' =>
        "You've been carrying a lot — $captured thought${captured == 1 ? '' : 's'} so far, mostly around $topConcern.",
      'coach' =>
        '$captured thought${captured == 1 ? '' : 's'} captured! Your top theme: $topConcern. Keep going.',
      'reflective' =>
        '$captured thought${captured == 1 ? '' : 's'} captured. $topConcern keeps surfacing — sit with it.',
      _ =>
        "You've captured $captured thought${captured == 1 ? '' : 's'}. Top theme: $topConcern.",
    };
  }

  // ---------------------------------------------------------------------------
  // Top concerns
  // ---------------------------------------------------------------------------

  static List<ConcernMetric> _buildConcerns(OnboardingData d) {
    if (d.stressSources.isEmpty) {
      return const [
        ConcernMetric(
          label: 'Complete onboarding',
          percentage: 0,
          color: AppColors.textMuted,
        ),
      ];
    }

    const colors = [
      AppColors.primary,
      AppColors.accentRoseDeep,
      AppColors.accentMintDeep,
    ];

    // Order = priority. Show illustrative weights (45/30/25).
    const weights = [45, 30, 25];

    final result = <ConcernMetric>[];
    final picked = d.stressSources.take(3).toList();
    for (var i = 0; i < picked.length; i++) {
      result.add(ConcernMetric(
        label: _stressLabel(picked[i]),
        percentage: weights[i],
        color: colors[i % colors.length],
      ));
    }
    return result;
  }

  static String _stressLabel(String key) {
    return switch (key) {
      'school' => 'School / Exams',
      'work' => 'Work / Career',
      'relationships' => 'Relationships',
      'family' => 'Family',
      'money' => 'Money',
      'social' => 'Social media',
      'future' => 'The future',
      'health' => 'Health',
      'uncertainty' => 'Uncertainty',
      _ => key,
    };
  }
}
