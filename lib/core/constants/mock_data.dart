import 'package:flutter/material.dart';

import '../../models/activity_entry.dart';
import '../../models/focus_session.dart';
import '../../models/mood.dart';
import '../theme/app_colors.dart';

class MockData {
  MockData._();

  static const List<Mood> homeMoods = [
    Mood(id: 'calm', label: 'Calm', emoji: '😌', accent: AppColors.accentMint),
    Mood(id: 'anxious', label: 'Anxious', emoji: '😟', accent: AppColors.accentPeach),
    Mood(id: 'down', label: 'Down', emoji: '🌧️', accent: AppColors.accentSky),
    Mood(id: 'good', label: 'Good', emoji: '🌸', accent: AppColors.accentRose),
    Mood(id: 'excited', label: 'Excited', emoji: '✨', accent: AppColors.accentLavender),
    Mood(id: 'tired', label: 'Tired', emoji: '😴', accent: AppColors.surfaceMuted),
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
