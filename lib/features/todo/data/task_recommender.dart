import '../../../models/task_item.dart';
import '../../onboarding/data/onboarding_data.dart';

/// Builds a personalized task list from the user's onboarding answers.
///
/// Rule-based for now — each [stressSources] entry contributes 1–2 themed
/// templates, [rankedGoals] + [aiTone] shape the "Why this matters" copy,
/// and [stressResponse] picks which task gets flagged for attention.
///
/// When onboarding hasn't been completed (singleton empty) we fall back to a
/// short generic list so the screen never looks empty.
class TaskRecommender {
  TaskRecommender._();

  static List<TaskItem> recommend() {
    final d = OnboardingData.instance;

    if (d.stressSources.isEmpty &&
        d.roleKey == null &&
        d.rankedGoals.isEmpty) {
      return _generic();
    }

    final why = _whyMessage(d);
    final flag = _flagPolicy(d.stressResponse);

    final pool = <_TaskTemplate>[];
    for (final source in d.stressSources) {
      pool.addAll(_templatesForStressSource(source));
    }
    if (pool.length < 4 && d.roleKey != null) {
      pool.addAll(_templatesForRole(d.roleKey!));
    }
    if (pool.length < 3) {
      pool.addAll(_genericTemplates);
    }

    final seen = <String>{};
    final unique = pool.where((t) => seen.add(t.id)).take(6).toList();

    final tasks = <TaskItem>[];
    for (var i = 0; i < unique.length; i++) {
      final t = unique[i];
      tasks.add(TaskItem(
        id: 'rec_${t.id}',
        title: t.title,
        category: t.category,
        estimated: t.estimated,
        whyItMatters: why,
        flagged: flag(i),
      ));
    }

    return tasks.isEmpty ? _generic() : tasks;
  }

  // ---------------------------------------------------------------------------
  // Templates
  // ---------------------------------------------------------------------------

  static List<_TaskTemplate> _templatesForStressSource(String key) {
    switch (key) {
      case 'school':
        return const [
          _TaskTemplate('school1', "Outline tomorrow's assignment",
              TaskCategory.school, Duration(minutes: 30)),
          _TaskTemplate('school2', 'Email the professor one quick question',
              TaskCategory.school, Duration(minutes: 10)),
        ];
      case 'work':
        return const [
          _TaskTemplate('work1', 'Write your top 3 priorities',
              TaskCategory.work, Duration(minutes: 10)),
          _TaskTemplate('work2', 'Prep notes for the next 1:1',
              TaskCategory.work, Duration(minutes: 15)),
        ];
      case 'relationships':
        return const [
          _TaskTemplate('rel1', "Reply to that one message you've been avoiding",
              TaskCategory.personal, Duration(minutes: 10)),
          _TaskTemplate('rel2', "Send a 'thinking of you' text",
              TaskCategory.personal, Duration(minutes: 5)),
        ];
      case 'family':
        return const [
          _TaskTemplate('fam1', 'Call mom or dad',
              TaskCategory.family, Duration(minutes: 15)),
          _TaskTemplate('fam2', 'Send a check-in text to family',
              TaskCategory.family, Duration(minutes: 5)),
        ];
      case 'money':
        return const [
          _TaskTemplate('mon1', "Review this month's spending",
              TaskCategory.personal, Duration(minutes: 20)),
          _TaskTemplate('mon2', 'Pay one pending bill',
              TaskCategory.personal, Duration(minutes: 10)),
        ];
      case 'social':
        return const [
          _TaskTemplate('soc1', '30 minutes phone-free, right now',
              TaskCategory.personal, Duration(minutes: 30)),
          _TaskTemplate('soc2', 'Mute notifications for the next hour',
              TaskCategory.personal, Duration(minutes: 5)),
        ];
      case 'future':
        return const [
          _TaskTemplate('fut1', 'Write one small step toward your goal',
              TaskCategory.personal, Duration(minutes: 15)),
          _TaskTemplate('fut2', 'Read a 5-min article on something you care about',
              TaskCategory.personal, Duration(minutes: 10)),
        ];
      case 'health':
        return const [
          _TaskTemplate('hea1', 'Take a 10-minute walk',
              TaskCategory.personal, Duration(minutes: 10)),
          _TaskTemplate('hea2', 'Drink a glass of water and stretch',
              TaskCategory.personal, Duration(minutes: 5)),
        ];
      case 'uncertainty':
        return const [
          _TaskTemplate('unc1', 'Write 3 things you can control today',
              TaskCategory.personal, Duration(minutes: 10)),
        ];
      default:
        return const [];
    }
  }

  static List<_TaskTemplate> _templatesForRole(String role) {
    switch (role) {
      case 'student':
        return const [
          _TaskTemplate('rs1', 'Review yesterday\'s notes for 15 minutes',
              TaskCategory.school, Duration(minutes: 15)),
        ];
      case 'working':
        return const [
          _TaskTemplate('rw1', 'Clear inbox to zero', TaskCategory.work,
              Duration(minutes: 20)),
        ];
      case 'both':
        return const [
          _TaskTemplate('rb1', 'Review yesterday\'s notes for 15 minutes',
              TaskCategory.school, Duration(minutes: 15)),
          _TaskTemplate('rb2', 'Clear inbox to zero', TaskCategory.work,
              Duration(minutes: 20)),
        ];
      case 'transition':
        return const [
          _TaskTemplate('rt1', 'Write 3 things you can control today',
              TaskCategory.personal, Duration(minutes: 10)),
          _TaskTemplate('rt2', 'Take a 10-minute walk',
              TaskCategory.personal, Duration(minutes: 10)),
        ];
      default:
        return const [];
    }
  }

  static const List<_TaskTemplate> _genericTemplates = [
    _TaskTemplate('gen1', 'Write 3 things on your mind',
        TaskCategory.personal, Duration(minutes: 5)),
    _TaskTemplate('gen2', 'Take a 10-minute walk',
        TaskCategory.personal, Duration(minutes: 10)),
    _TaskTemplate('gen3', 'Reply to one message',
        TaskCategory.personal, Duration(minutes: 10)),
  ];

  static List<TaskItem> _generic() {
    return _genericTemplates
        .map((t) => TaskItem(
              id: 'gen_${t.id}',
              title: t.title,
              category: t.category,
              estimated: t.estimated,
              whyItMatters: 'A small step is still a step.',
            ))
        .toList();
  }

  // ---------------------------------------------------------------------------
  // Why this matters — combines the user's top goal with their preferred tone.
  // ---------------------------------------------------------------------------

  static String _whyMessage(OnboardingData d) {
    final goal = d.rankedGoals.isNotEmpty ? d.rankedGoals.first : null;
    final tone = d.aiTone;

    final base = switch (goal) {
      'clear' => 'Less mental clutter.',
      'productive' => 'Keeps your day moving.',
      'anxiety' => 'One step out of the spiral.',
      'routine' => 'Builds the rhythm you wanted.',
      'understand' => 'A small mirror for yourself.',
      _ => 'Worth doing.',
    };

    return switch (tone) {
      'direct' => base,
      'warm' => 'Be kind to yourself — ${_lowerFirst(base)}',
      'coach' => "You've got this. $base",
      'reflective' => 'Just noticing: ${_lowerFirst(base)}',
      _ => base,
    };
  }

  static String _lowerFirst(String s) =>
      s.isEmpty ? s : '${s[0].toLowerCase()}${s.substring(1)}';

  // ---------------------------------------------------------------------------
  // Flagging policy — shaped by how the user reacts under stress.
  // ---------------------------------------------------------------------------

  static bool Function(int) _flagPolicy(String? response) {
    switch (response) {
      case 'overthink':
      case 'freeze':
      case 'distract':
        return (i) => i == 0; // anchor on the first item
      case 'procrastinate':
        return (i) => i == 1; // surface the "do this next" item
      default:
        return (_) => false;
    }
  }
}

class _TaskTemplate {
  final String id;
  final String title;
  final TaskCategory category;
  final Duration estimated;

  const _TaskTemplate(this.id, this.title, this.category, this.estimated);
}
