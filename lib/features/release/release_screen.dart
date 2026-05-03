import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/repositories/thought_repository.dart';
import '../../data/service_locator.dart';
import '../../models/thought.dart';
import 'widgets/release_header.dart';
import 'widgets/release_info_row.dart';
import 'widgets/release_thought_card.dart';

class ReleaseScreen extends StatefulWidget {
  const ReleaseScreen({super.key});

  @override
  State<ReleaseScreen> createState() => _ReleaseScreenState();
}

class _ReleaseScreenState extends State<ReleaseScreen> {
  late final ThoughtRepository _repo = ServiceLocator.thoughts;
  late Future<List<Thought>> _future;

  @override
  void initState() {
    super.initState();
    _future = _repo.fetchReleaseThoughts();
  }

  Future<void> _refresh() async {
    final fresh = _repo.fetchReleaseThoughts();
    setState(() => _future = fresh);
    await fresh;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refresh,
          color: AppColors.primary,
          child: FutureBuilder<List<Thought>>(
            future: _future,
            builder: (context, snapshot) {
              final thoughts = snapshot.data ?? const <Thought>[];
              final loading = snapshot.connectionState == ConnectionState.waiting;
              final error = snapshot.error;

              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.xxl,
                ),
                children: [
                  const ReleaseHeader(),
                  const SizedBox(height: AppSpacing.lg),
                  ReleaseInfoRow(count: thoughts.length),
                  const SizedBox(height: AppSpacing.base),
                  if (loading) const _LoadingState(),
                  if (error != null) _ErrorState(message: error.toString()),
                  if (!loading && error == null && thoughts.isEmpty)
                    const _EmptyState(),
                  if (!loading && error == null)
                    for (final t in thoughts) ...[
                      ReleaseThoughtCard(
                        thought: t,
                        onTap: () => _release(t),
                      ),
                      const SizedBox(height: AppSpacing.md),
                    ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _release(Thought t) async {
    HapticFeedback.lightImpact();
    await _repo.markReleased(t.id);
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text('Released — that one is off your shoulders.',
            style: AppTextStyles.bodyMedium
                .copyWith(color: AppColors.textOnPrimary)),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ));
    await _refresh();
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.xxl),
      child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  const _ErrorState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
      child: Center(
        child: Text(
          'Could not load thoughts.\n$message',
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyMedium,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xxxl),
      child: Column(
        children: [
          const Icon(Icons.spa_rounded,
              size: 56, color: AppColors.accentMintDeep),
          const SizedBox(height: AppSpacing.base),
          Text('All clear for now.', style: AppTextStyles.titleMedium),
          const SizedBox(height: 4),
          Text(
            'When something is weighing on you, capture it from Home.',
            style: AppTextStyles.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
