import 'package:flutter/material.dart';

enum ActivityKind { release, task, focus }

class ActivityEntry {
  final ActivityKind kind;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;
  final DateTime timestamp;

  const ActivityEntry({
    required this.kind,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
    required this.timestamp,
  });
}
