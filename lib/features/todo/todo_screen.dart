import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/ai_task_feed.dart';
import '../../models/task_item.dart';
import 'data/task_recommender.dart';
import 'widgets/todo_filter_chips.dart';
import 'widgets/todo_header.dart';
import 'widgets/todo_task_card.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  TaskCategory? _filter; // null = All

  // Rule-based recommendations (from onboarding) — stable across the screen's life.
  late final List<TaskItem> _ruleTasks = TaskRecommender.recommend();

  // Local "done" overrides keyed by task id — applies to both AI and rule tasks.
  final Map<String, bool> _doneOverrides = {};

  @override
  void initState() {
    super.initState();
    AiTaskFeed.instance.tasks.addListener(_onAiTasksChanged);
  }

  @override
  void dispose() {
    AiTaskFeed.instance.tasks.removeListener(_onAiTasksChanged);
    super.dispose();
  }

  void _onAiTasksChanged() {
    if (!mounted) return;
    setState(() {});
  }

  /// Merged list: AI tasks first (newest first), then rule-based.
  List<TaskItem> get _allTasks {
    final aiTasks = AiTaskFeed.instance.tasks.value.reversed.toList();
    final merged = <TaskItem>[...aiTasks, ..._ruleTasks];
    return merged
        .map((t) => _doneOverrides.containsKey(t.id)
            ? t.copyWith(done: _doneOverrides[t.id])
            : t)
        .toList();
  }

  List<TaskItem> get _visible {
    final all = _allTasks;
    if (_filter == null) return all;
    return all.where((t) => t.category == _filter).toList();
  }

  void _toggleDone(String id) {
    setState(() {
      final current = _allTasks.firstWhere(
        (t) => t.id == id,
        orElse: () => _allTasks.first,
      );
      _doneOverrides[id] = !current.done;
    });
  }

  Duration get _totalRemaining {
    return _visible
        .where((t) => !t.done)
        .fold(Duration.zero, (acc, t) => acc + t.estimated);
  }

  String _formatTotal(Duration d) {
    if (d.inMinutes < 60) return '${d.inMinutes} min total';
    final h = d.inHours;
    final m = d.inMinutes % 60;
    return m == 0 ? '$h hr total' : '${h}h ${m}m total';
  }

  @override
  Widget build(BuildContext context) {
    final tasks = _visible;
    final aiTaskCount = AiTaskFeed.instance.tasks.value.length;

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
            const TodoHeader(),
            const SizedBox(height: AppSpacing.lg),
            TodoFilterChips(
              selected: _filter,
              onChanged: (c) => setState(() => _filter = c),
            ),
            const SizedBox(height: AppSpacing.lg),
            _SummaryRow(
              count: tasks.length,
              totalLabel: _formatTotal(_totalRemaining),
              aiCount: aiTaskCount,
            ),
            const SizedBox(height: AppSpacing.md),
            if (tasks.isEmpty)
              const _EmptyState()
            else
              for (final t in tasks) ...[
                TodoTaskCard(
                  task: t,
                  onToggleDone: () => _toggleDone(t.id),
                ),
                const SizedBox(height: AppSpacing.md),
              ],
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final int count;
  final String totalLabel;
  final int aiCount;

  const _SummaryRow({
    required this.count,
    required this.totalLabel,
    required this.aiCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              '$count ${count == 1 ? "TASK" : "TASKS"}',
              style: AppTextStyles.labelMedium,
            ),
            if (aiCount > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.accentLavender,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '$aiCount AI',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.accentLavenderDeep,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ],
        ),
        Text(
          totalLabel.toUpperCase(),
          style: AppTextStyles.labelMedium,
        ),
      ],
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
          const Icon(Icons.task_alt_rounded,
              size: 48, color: AppColors.accentPeachDeep),
          const SizedBox(height: AppSpacing.base),
          Text('Nothing here.', style: AppTextStyles.titleMedium),
          const SizedBox(height: 4),
          Text(
            'Switch filters or capture a new thought from Home.',
            style: AppTextStyles.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}