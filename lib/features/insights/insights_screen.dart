import 'package:flutter/material.dart';

import '../../core/constants/mock_data.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import 'widgets/insights_header.dart';
import 'widgets/insights_period_selector.dart';
import 'widgets/stat_card.dart';
import 'widgets/top_concerns_card.dart';
import 'widgets/weekly_insight_card.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  InsightsPeriod _period = InsightsPeriod.week;

  @override
  Widget build(BuildContext context) {
    final stats = MockData.insightStats;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.xxl,
          ),
          children: [
            const InsightsHeader(),
            const SizedBox(height: AppSpacing.lg),
            InsightsPeriodSelector(
              value: _period,
              onChanged: (p) => setState(() => _period = p),
            ),
            const SizedBox(height: AppSpacing.lg),
            const WeeklyInsightCard(),
            const SizedBox(height: AppSpacing.md),
            _StatsGrid(stats: stats),
            const SizedBox(height: AppSpacing.md),
            TopConcernsCard(concerns: MockData.concerns),
          ],
        ),
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  final List stats;

  const _StatsGrid({required this.stats});

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var i = 0; i < stats.length; i += 2) {
      final left = stats[i];
      final right = i + 1 < stats.length ? stats[i + 1] : null;
      rows.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: StatCard(stat: left)),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: right == null
                    ? const SizedBox()
                    : StatCard(stat: right),
              ),
            ],
          ),
        ),
      );
      if (i + 2 < stats.length) {
        rows.add(const SizedBox(height: AppSpacing.md));
      }
    }
    return Column(children: rows);
  }
}
