import 'package:flutter/material.dart';

import '../../core/constants/mock_data.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/task_item.dart';
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
  late final List<TaskItem> _tasks = List.of(MockData.tasks);

  List<TaskItem> get _visible {
    if (_filter == null) return _tasks;
    return _tasks.where((t) => t.category == _filter).toList();
  }

  void _toggleDone(String id) {
    setState(() {
      final i = _tasks.indexWhere((t) => t.id == id);
      if (i == -1) return;
      _tasks[i] = _tasks[i].copyWith(done: !_tasks[i].done);
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

  const _SummaryRow({required this.count, required this.totalLabel});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$count ${count == 1 ? "TASK" : "TASKS"}',
          style: AppTextStyles.labelMedium,
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
