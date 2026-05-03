import 'package:flutter/material.dart';

class Mood {
  final String id;
  final String label;
  final String emoji;
  final Color accent;

  const Mood({
    required this.id,
    required this.label,
    required this.emoji,
    required this.accent,
  });
}
