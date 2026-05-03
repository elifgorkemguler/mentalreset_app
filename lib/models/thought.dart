enum ThoughtIntensity { low, medium, high }

enum ThoughtKind { release, action }

class Thought {
  final String id;
  final String text;
  final ThoughtIntensity intensity;
  final ThoughtKind kind;
  final DateTime createdAt;

  const Thought({
    required this.id,
    required this.text,
    required this.intensity,
    required this.kind,
    required this.createdAt,
  });
}
