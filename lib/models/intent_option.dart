import 'package:flutter/material.dart';

class IntentOption {
  final String id;
  final String label;
  final String description;
  final String emoji;
  final Color accent;

  const IntentOption({
    required this.id,
    required this.label,
    required this.description,
    required this.emoji,
    required this.accent,
  });
}
