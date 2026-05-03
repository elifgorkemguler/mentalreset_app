import 'package:flutter/material.dart';

import '../../models/activity_entry.dart';
import '../../models/focus_session.dart';
import '../../models/intent_option.dart';
import '../../models/mood.dart';
import '../../models/task_item.dart';
import '../../models/thought.dart';
import '../theme/app_colors.dart';

class MockData {
  MockData._();

  static const String userName = 'Elif';

  static const List<IntentOption> intents = [
    IntentOption(
      id: 'calm',
      label: 'Calm down',
      description: 'Slow the racing thoughts',
      emoji: '🌿',
      accent: AppColors.accentMint,
    ),
    IntentOption(
      id: 'recharge',
      label: 'Recharge energy',
      description: 'Find a gentle lift',
      emoji: '🌞',
      accent: AppColors.accentPeach,
    ),
    IntentOption(
      id: 'clear',
      label: 'Clear my mind',
      description: 'Sort the mental clutter',
      emoji: '🪞',
      accent: AppColors.accentLavender,
    ),
    IntentOption(
      id: 'seen',
      label: 'Feel seen',
      description: 'Be heard, without judgment',
      emoji: '💗',
      accent: AppColors.accentRose,
    ),
  ];

  static const List<Mood> onboardingMoods = [
    Mood(id: 'calm', label: 'Calm', emoji: '😌', accent: AppColors.accentMint),
    Mood(id: 'anxious', label: 'Anxious', emoji: '😟', accent: AppColors.accentPeach),
    Mood(id: 'empty', label: 'Empty', emoji: '🫥', accent: AppColors.accentLavender),
    Mood(id: 'excited', label: 'Excited', emoji: '✨', accent: AppColors.accentRose),
    Mood(id: 'tired', label: 'Tired', emoji: '😴', accent: AppColors.accentSky),
  ];

  static const List<Mood> homeMoods = [
    Mood(id: 'calm', label: 'Calm', emoji: '😌', accent: AppColors.accentMint),
    Mood(id: 'anxious', label: 'Anxious', emoji: '😟', accent: AppColors.accentPeach),
    Mood(id: 'down', label: 'Down', emoji: '🌧️', accent: AppColors.accentSky),
    Mood(id: 'good', label: 'Good', emoji: '🌸', accent: AppColors.accentRose),
    Mood(id: 'excited', label: 'Excited', emoji: '✨', accent: AppColors.accentLavender),
    Mood(id: 'tired', label: 'Tired', emoji: '😴', accent: AppColors.surfaceMuted),
  ];

  static List<Thought> releaseThoughts = [
    Thought(
      id: 't1',
      text: "I keep replaying that awkward meeting from this morning.",
      intensity: ThoughtIntensity.high,
      kind: ThoughtKind.release,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Thought(
      id: 't2',
      text: "What if I'm falling behind on everything this week?",
      intensity: ThoughtIntensity.high,
      kind: ThoughtKind.release,
      createdAt: DateTime.now().subtract(const Duration(hours: 4)),
    ),
    Thought(
      id: 't3',
      text: "Worried I forgot to reply to that one email.",
      intensity: ThoughtIntensity.medium,
      kind: ThoughtKind.release,
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
    ),
    Thought(
      id: 't4',
      text: "Annoyed about the noisy neighbours last night.",
      intensity: ThoughtIntensity.medium,
      kind: ThoughtKind.release,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Thought(
      id: 't5',
      text: "Small lingering guilt about skipping the gym.",
      intensity: ThoughtIntensity.low,
      kind: ThoughtKind.release,
      createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
    ),
  ];

  static List<TaskItem> tasks = const [
    TaskItem(
      id: 'task1',
      title: 'Finish assignment outline',
      category: TaskCategory.school,
      estimated: Duration(minutes: 45),
      whyItMatters: 'Clears space for the deeper writing tomorrow.',
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
      estimated: Duration(minutes: 20),
      whyItMatters: 'A small call, a big lift for both of you.',
    ),
    TaskItem(
      id: 'task5',
      title: 'Tidy desk before deep work',
      category: TaskCategory.personal,
      estimated: Duration(minutes: 10),
    ),
  ];

  static const List<FocusSession> focusSessions = [];

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
