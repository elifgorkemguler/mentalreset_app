import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/thought_feed.dart';
import 'data/insights_provider.dart';
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
  late Future<InsightsSnapshot> _future;

  @override
  void initState() {
    super.initState();
    _future = InsightsProvider.snapshot();
    ThoughtFeed.revision.addListener(_onFeedChanged);
  }

  @override
  void dispose() {
    ThoughtFeed.revision.removeListener(_onFeedChanged);
    super.dispose();
  }

  void _onFeedChanged() {
    if (!mounted) return;
    setState(() => _future = InsightsProvider.snapshot());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: FutureBuilder<InsightsSnapshot>(
          future: _future,
          builder: (context, snapshot) {
            final data = snapshot.data;
            final loading = snapshot.connectionState == ConnectionState.waiting;
            return ListView(
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
                if (loading || data == null)
                  const _LoadingState()
                else ...[
                  WeeklyInsightCard(
                    title: data.weeklyInsightTitle,
                    body: data.weeklyInsightBody,
                    highlight: data.weeklyInsightHighlight,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _StatsGrid(stats: data.stats),
                  const SizedBox(height: AppSpacing.md),
                  TopConcernsCard(concerns: data.concerns),
                ],
              ],
            );
          },
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

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxxl),
      child: Column(
        children: [
          const CircularProgressIndicator(color: AppColors.primary),
          const SizedBox(height: AppSpacing.base),
          Text('Loading your insights…', style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }
}
