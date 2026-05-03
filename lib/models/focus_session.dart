class FocusSession {
  final String id;
  final String taskTitle;
  final Duration duration;
  final DateTime completedAt;

  const FocusSession({
    required this.id,
    required this.taskTitle,
    required this.duration,
    required this.completedAt,
  });
}
