import 'package:flutter/material.dart';

class InsightStat {
  final String label;
  final String value;
  final String supportingText;
  final IconData icon;
  final Color iconBackground;
  final Color iconForeground;

  /// True when [supportingText] should render in the calm-positive accent
  /// (the "↗ +12% this week" rows). False keeps it muted (e.g. "Personal best").
  final bool isPositiveTrend;

  const InsightStat({
    required this.label,
    required this.value,
    required this.supportingText,
    required this.icon,
    required this.iconBackground,
    required this.iconForeground,
    this.isPositiveTrend = false,
  });
}
