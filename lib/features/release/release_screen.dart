import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/repositories/supabase_thought_repository.dart';
import '../../data/repositories/thought_repository.dart';
import '../../data/service_locator.dart';
import '../../data/thought_feed.dart';
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
    ThoughtFeed.revision.addListener(_onFeedChanged);
  }

  @override
  void dispose() {
    ThoughtFeed.revision.removeListener(_onFeedChanged);
    super.dispose();
  }

  void _onFeedChanged() {
    if (!mounted) return;
    _refresh();
  }

  Future<void> _refresh() async {
    final fresh = _repo.fetchReleaseThoughts();
    setState(() => _future = fresh);
    await fresh;
  }

  Future<void> _release(Thought t) async {
    HapticFeedback.mediumImpact();
    final messenger = ScaffoldMessenger.of(context);

// Optimistic: kartı UI'dan hemen sil
    setState(() {
      _future = _future.then((list) => list.where((th) => th.id != t.id).toList());
    });

    try {
      await _repo.releaseThought(t.id);
    } on NotAuthenticatedException catch (e) {
      // Card stays visible — server didn't change anything.
      if (!mounted) return;
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(e.toString())));
      return;
    } catch (e) {
      // Card stays visible — release failed. Don't refresh.
      if (!mounted) return;
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('Could not release: $e')));
      return;
    }

    if (!mounted) return;
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text('Thought released.',
            style: AppTextStyles.bodyMedium
                .copyWith(color: AppColors.textOnPrimary)),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ));
    await _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            RefreshIndicator(
              onRefresh: _refresh,
              color: AppColors.primary,
              child: FutureBuilder<List<Thought>>(
                future: _future,
                builder: (context, snapshot) {
                  final thoughts = snapshot.data ?? const <Thought>[];
                  final loading =
                      snapshot.connectionState == ConnectionState.waiting;
                  final error = snapshot.error;

                  return ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.lg,
                      AppSpacing.lg,
                      // Reserve room for the floating trash bin so the last
                      // card isn't hidden behind it when scrolled to bottom.
                      120,
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
                          _DraggableThoughtCard(thought: t),
                          const SizedBox(height: AppSpacing.md),
                        ],
                    ],
                  );
                },
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 16,
              child: Center(
                child: DragTarget<Thought>(
                  builder: (context, candidate, rejected) {
                    return _TrashBin(active: candidate.isNotEmpty);
                  },
                  onAcceptWithDetails: (details) async {
                    await _release(details.data);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DraggableThoughtCard extends StatelessWidget {
  final Thought thought;

  const _DraggableThoughtCard({required this.thought});

  @override
  Widget build(BuildContext context) {
    final card = ReleaseThoughtCard(thought: thought);
    final width = MediaQuery.of(context).size.width - (AppSpacing.lg * 2);

    return LongPressDraggable<Thought>(
      data: thought,
      hapticFeedbackOnStart: true,
      delay: const Duration(milliseconds: 250),
      feedback: Material(
        color: Colors.transparent,
        elevation: 12,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: SizedBox(width: width, child: card),
      ),
      childWhenDragging: Opacity(opacity: 0.3, child: card),
      child: card,
    );
  }
}

class _TrashBin extends StatelessWidget {
  final bool active;

  const _TrashBin({required this.active});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      width: active ? 84 : 68,
      height: active ? 84 : 68,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active ? AppColors.intensityHighBg : AppColors.surface,
        border: Border.all(
          color: active ? AppColors.intensityHigh : AppColors.border,
          width: active ? 2 : 1,
        ),
        boxShadow: active ? AppShadows.cardLift : AppShadows.card,
      ),
      alignment: Alignment.center,
      child: Text(
        '🗑️',
        style: TextStyle(fontSize: active ? 38 : 30),
      ),
    );
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
          Text('No thoughts to release yet', style: AppTextStyles.titleMedium),
          const SizedBox(height: 4),
          Text(
            'Capture a thought from Home and it will appear here.',
            style: AppTextStyles.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
