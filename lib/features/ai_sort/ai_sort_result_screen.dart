// MindFlow — AI Sort Result Screen
// Shows what AI extracted from a thought and saves it on confirm.

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/ai_task_feed.dart';
import '../../data/repositories/supabase_thought_repository.dart';
import '../../data/service_locator.dart';
import '../../data/services/ai_service.dart';
import '../../data/thought_feed.dart';
import '../../models/task_item.dart';
import '../../widgets/primary_gradient_button.dart';

class AiSortResultScreen extends StatefulWidget {
  final String originalThought;
  final ThoughtSortResult result;

  const AiSortResultScreen({
    super.key,
    required this.originalThought,
    required this.result,
  });

  @override
  State<AiSortResultScreen> createState() => _AiSortResultScreenState();
}

class _AiSortResultScreenState extends State<AiSortResultScreen> {
  bool _saving = false;

  TaskCategory _categoryFromString(String s) {
    switch (s.toLowerCase()) {
      case 'work':
        return TaskCategory.work;
      case 'school':
        return TaskCategory.school;
      case 'family':
        return TaskCategory.family;
      default:
        return TaskCategory.personal;
    }
  }

  IconData _iconForCategory(TaskCategory c) {
    switch (c) {
      case TaskCategory.work:
        return Icons.work_outline;
      case TaskCategory.school:
        return Icons.school_outlined;
      case TaskCategory.family:
        return Icons.people_outline;
      case TaskCategory.personal:
        return Icons.person_outline;
    }
  }

  Color _colorForCategory(TaskCategory c) {
    switch (c) {
      case TaskCategory.work:
        return AppColors.accentLavenderDeep;
      case TaskCategory.school:
        return AppColors.accentSkyDeep;
      case TaskCategory.family:
        return AppColors.accentPeachDeep;
      case TaskCategory.personal:
        return AppColors.accentMintDeep;
    }
  }

  Future<void> _saveAll() async {
    setState(() => _saving = true);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    try {
      // 1. Save emotional clutter as release thoughts
      for (final e in widget.result.emotionalClutter) {
        await ServiceLocator.thoughts.addThought(content: e.description);
      }

      // 2. Push AI tasks into the in-memory To-Do feed
      final aiTasks = widget.result.actionableTasks.map((t) {
        return TaskItem(
          id: 'ai_${DateTime.now().millisecondsSinceEpoch}_${t.task.hashCode}',
          title: t.task,
          category: _categoryFromString(t.category),
          estimated: Duration(minutes: t.estimatedMinutes),
          whyItMatters: 'From your thought just now.',
        );
      }).toList();
      AiTaskFeed.instance.addAll(aiTasks);

      // 3. Notify Release screen to refresh
      ThoughtFeed.notifyChanged();

      if (!mounted) return;
      navigator.pop();
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text(
            'Sorted! ${widget.result.emotionalClutter.length} to release · ${aiTasks.length} new tasks',
            style: AppTextStyles.bodyMedium
                .copyWith(color: AppColors.textOnPrimary),
          ),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
        ));
    } on NotAuthenticatedException catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(e.toString())));
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('Could not save: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final emotions = widget.result.emotionalClutter;
    final tasks = widget.result.actionableTasks;
    final reflection = widget.result.reflection;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('What we found', style: AppTextStyles.headlineMedium),
        centerTitle: false,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.sm,
            AppSpacing.lg,
            AppSpacing.xl,
          ),
          children: [
            // Reflection card
            if (reflection.isNotEmpty) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.auto_awesome,
                            color: Colors.white, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Reflection',
                          style: AppTextStyles.labelLarge.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      reflection,
                      style: AppTextStyles.bodyLarge
                          .copyWith(color: Colors.white, height: 1.5),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
            ],

            // Emotional clutter
            if (emotions.isNotEmpty) ...[
              _SectionHeader(
                emoji: '🌊',
                title: 'To release',
                count: emotions.length,
              ),
              const SizedBox(height: AppSpacing.md),
              ...emotions.map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.base),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        border: Border.all(color: AppColors.border, width: 1),
                      ),
                      child: Text(
                        e.description,
                        style: AppTextStyles.bodyLarge,
                      ),
                    ),
                  )),
              const SizedBox(height: AppSpacing.xl),
            ],

            // Actionable tasks
            if (tasks.isNotEmpty) ...[
              _SectionHeader(
                emoji: '✅',
                title: 'Action items',
                count: tasks.length,
              ),
              const SizedBox(height: AppSpacing.md),
              ...tasks.map((t) {
                final cat = _categoryFromString(t.category);
                final color = _colorForCategory(cat);
                final icon = _iconForCategory(cat);
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.base),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      border: Border.all(color: AppColors.border, width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(t.task, style: AppTextStyles.bodyLarge),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(icon, size: 14, color: color),
                            const SizedBox(width: 4),
                            Text(
                              cat.label,
                              style: AppTextStyles.labelMedium
                                  .copyWith(color: color),
                            ),
                            Text(' · ',
                                style: AppTextStyles.labelMedium
                                    .copyWith(color: AppColors.textMuted)),
                            Text(
                              '${t.estimatedMinutes} min',
                              style: AppTextStyles.labelMedium
                                  .copyWith(color: AppColors.textMuted),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: AppSpacing.xl),
            ],

            // Empty state — nothing to save
            if (emotions.isEmpty && tasks.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
                child: Column(
                  children: [
                    const Icon(Icons.spa_outlined,
                        size: 48, color: AppColors.textMuted),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Nothing pressing here.',
                      style: AppTextStyles.bodyLarge
                          .copyWith(color: AppColors.textSecondary),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

            const SizedBox(height: AppSpacing.lg),

            // Save all button
            if (emotions.isNotEmpty || tasks.isNotEmpty)
              PrimaryGradientButton(
                label: 'Save all (${emotions.length + tasks.length})',
                loading: _saving,
                onPressed: _saving ? null : _saveAll,
              )
            else
              PrimaryGradientButton(
                label: 'Done',
                onPressed: () => Navigator.of(context).pop(),
              ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String emoji;
  final String title;
  final int count;

  const _SectionHeader({
    required this.emoji,
    required this.title,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: AppSpacing.sm),
        Text(title, style: AppTextStyles.titleMedium),
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.surfaceMuted,
            borderRadius: BorderRadius.circular(99),
          ),
          child: Text(
            '$count',
            style: AppTextStyles.labelMedium
                .copyWith(color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }
}