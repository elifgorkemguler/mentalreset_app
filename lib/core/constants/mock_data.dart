import 'package:flutter/material.dart';

import '../../models/activity_entry.dart';
import '../../models/concern_metric.dart';
import '../../models/focus_session.dart';
import '../../models/insight_stat.dart';
import '../../models/mood.dart';
import '../../models/task_item.dart';
import '../theme/app_colors.dart';

class MockData {
  MockData._();

  static const String userName = 'Elif';

  static const List<Mood> homeMoods = [
    Mood(id: 'calm', label: 'Calm', emoji: '😌', accent: AppColors.accentMint),
    Mood(id: 'anxious', label: 'Anxious', emoji: '😟', accent: AppColors.accentPeach),
    Mood(id: 'down', label: 'Down', emoji: '🌧️', accent: AppColors.accentSky),
    Mood(id: 'good', label: 'Good', emoji: '🌸', accent: AppColors.accentRose),
    Mood(id: 'excited', label: 'Excited', emoji: '✨', accent: AppColors.accentLavender),
    Mood(id: 'tired', label: 'Tired', emoji: '😴', accent: AppColors.surfaceMuted),
  ];

  static List<TaskItem> tasks = const [
    TaskItem(
      id: 'task1',
      title: 'Finish assignment outline',
      category: TaskCategory.school,
      estimated: Duration(minutes: 30),
      whyItMatters: 'Clears space for the deeper writing tomorrow.',
      flagged: true,
    ),
    TaskItem(
      id: 'task2',
      title: 'Reply to Sarah message',
      category: TaskCategory.personal,
      estimated: Duration(minutes: 5),
      whyItMatters: 'You said you would, and you care about her.',
    ),
    TaskItem(
      id: 'task3',
      title: 'Review meeting notes',
      category: TaskCategory.work,
      estimated: Duration(minutes: 15),
    ),
    TaskItem(
      id: 'task4',
      title: 'Call mom about weekend plans',
      category: TaskCategory.family,
      estimated: Duration(minutes: 10),
      whyItMatters: 'A small call, a big lift for both of you.',
    ),
  ];

  static const List<FocusSession> focusSessions = [];

  static const List<InsightStat> insightStats = [
    InsightStat(
      label: 'Releases',
      value: '17',
      supportingText: '↗ +12% this week',
      icon: Icons.air_rounded,
      iconBackground: AppColors.accentMint,
      iconForeground: AppColors.accentMintDeep,
      isPositiveTrend: true,
    ),
    InsightStat(
      label: 'Tasks',
      value: '20',
      supportingText: '↗ +25% this week',
      icon: Icons.task_alt_rounded,
      iconBackground: AppColors.accentPeach,
      iconForeground: AppColors.accentPeachDeep,
      isPositiveTrend: true,
    ),
    InsightStat(
      label: 'Focus',
      value: '5.3h',
      supportingText: '↗ +8% this week',
      icon: Icons.bolt_rounded,
      iconBackground: AppColors.accentLavender,
      iconForeground: AppColors.primary,
      isPositiveTrend: true,
    ),
    InsightStat(
      label: 'Streak',
      value: '12',
      supportingText: 'Personal best',
      icon: Icons.local_fire_department_rounded,
      iconBackground: AppColors.accentPeach,
      iconForeground: AppColors.accentPeachDeep,
    ),
  ];

  static const List<ConcernMetric> concerns = [
    ConcernMetric(
      label: 'Work stress',
      percentage: 45,
      color: AppColors.primary,
    ),
    ConcernMetric(
      label: 'School pressure',
      percentage: 30,
      color: AppColors.accentRoseDeep,
    ),
    ConcernMetric(
      label: 'Social anxiety',
      percentage: 25,
      color: AppColors.accentMintDeep,
    ),
  ];

  static List<ActivityEntry> recentActivity = [
    ActivityEntry(
      kind: ActivityKind.release,
      title: 'Released a worry',
      subtitle: 'About this morning\'s meeting',
      icon: Icons.spa_rounded,
      accent: AppColors.accentLavender,
      timestamp: DateTime.now().subtract(const Duration(minutes: 35)),
    ),
    ActivityEntry(
      kind: ActivityKind.task,
      title: 'Completed task',
      subtitle: 'Reply to Sarah message',
      icon: Icons.check_circle_rounded,
      accent: AppColors.accentMint,
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    ActivityEntry(
      kind: ActivityKind.focus,
      title: '25-minute focus session',
      subtitle: 'Assignment outline',
      icon: Icons.bolt_rounded,
      accent: AppColors.accentPeach,
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
    ),
  ];
}
