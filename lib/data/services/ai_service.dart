// MindFlow AI Service
// Calls the Supabase Edge Function `sort-thought` which proxies Anthropic Claude.

import 'package:supabase_flutter/supabase_flutter.dart';

/// Single emotional item the AI surfaced from a thought.
class EmotionalClutter {
  final String description;
  EmotionalClutter(this.description);
}

/// A single actionable task the AI surfaced from a thought.
class AiTask {
  final String task;
  final String category; // "work", "school", "family", "personal"
  final int estimatedMinutes;

  AiTask({
    required this.task,
    required this.category,
    required this.estimatedMinutes,
  });

  factory AiTask.fromMap(Map<String, dynamic> m) => AiTask(
        task: (m['task'] as String?)?.trim() ?? '',
        category: (m['category'] as String?)?.toLowerCase() ?? 'personal',
        estimatedMinutes: (m['estimated_minutes'] as num?)?.toInt() ?? 15,
      );
}

/// Result of sorting a single thought via AI.
class ThoughtSortResult {
  final List<EmotionalClutter> emotionalClutter;
  final List<AiTask> actionableTasks;
  final String reflection;

  ThoughtSortResult({
    required this.emotionalClutter,
    required this.actionableTasks,
    required this.reflection,
  });

  bool get isEmpty =>
      emotionalClutter.isEmpty && actionableTasks.isEmpty && reflection.isEmpty;

  factory ThoughtSortResult.fromMap(Map<String, dynamic> m) {
    final emotions = (m['emotional_clutter'] as List? ?? const [])
        .map((e) => EmotionalClutter(e.toString()))
        .toList();
    final tasks = (m['actionable_tasks'] as List? ?? const [])
        .whereType<Map>()
        .map((t) => AiTask.fromMap(Map<String, dynamic>.from(t)))
        .toList();
    return ThoughtSortResult(
      emotionalClutter: emotions,
      actionableTasks: tasks,
      reflection: (m['reflection'] as String?)?.trim() ?? '',
    );
  }

  /// Empty fallback if AI fails.
  factory ThoughtSortResult.empty() => ThoughtSortResult(
        emotionalClutter: const [],
        actionableTasks: const [],
        reflection: '',
      );
}

/// Calls the `sort-thought` Edge Function. Throws on failure.
class AiService {
  AiService._();
  static final instance = AiService._();

  final _client = Supabase.instance.client;

  Future<ThoughtSortResult> sortThought(String thought) async {
    if (thought.trim().isEmpty) {
      return ThoughtSortResult.empty();
    }

    try {
      final response = await _client.functions.invoke(
        'sort-thought',
        body: {'thought': thought},
      );

      final data = response.data;
      if (data is! Map) {
        throw AiServiceException('Unexpected AI response shape');
      }
      // Edge function might wrap or return directly; handle both.
      final map = Map<String, dynamic>.from(data);
      if (map.containsKey('error')) {
        throw AiServiceException(map['error']?.toString() ?? 'AI error');
      }
      return ThoughtSortResult.fromMap(map);
    } on FunctionException catch (e) {
      throw AiServiceException('Edge function error: ${e.details}');
    } catch (e) {
      throw AiServiceException('AI service failed: $e');
    }
  }
}

class AiServiceException implements Exception {
  final String message;
  AiServiceException(this.message);

  @override
  String toString() => 'AiServiceException: $message';
}