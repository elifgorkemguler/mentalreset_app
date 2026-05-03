enum ThoughtIntensity { low, medium, high }

enum ThoughtKind { release, action, unsorted }

extension ThoughtIntensityX on ThoughtIntensity {
  String get label {
    switch (this) {
      case ThoughtIntensity.high:
        return 'High Intensity';
      case ThoughtIntensity.medium:
        return 'Medium Intensity';
      case ThoughtIntensity.low:
        return 'Low Intensity';
    }
  }

  static ThoughtIntensity? fromName(String? value) {
    if (value == null) return null;
    return ThoughtIntensity.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ThoughtIntensity.medium,
    );
  }
}

extension ThoughtKindX on ThoughtKind {
  static ThoughtKind fromName(String value) {
    return ThoughtKind.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ThoughtKind.unsorted,
    );
  }
}

class Thought {
  final String id;
  final String text;
  final ThoughtIntensity? intensity;
  final ThoughtKind kind;
  final DateTime createdAt;
  final DateTime? releasedAt;

  const Thought({
    required this.id,
    required this.text,
    required this.kind,
    required this.createdAt,
    this.intensity,
    this.releasedAt,
  });

  bool get isReleased => releasedAt != null;

  Thought copyWith({
    ThoughtKind? kind,
    ThoughtIntensity? intensity,
    DateTime? releasedAt,
  }) =>
      Thought(
        id: id,
        text: text,
        kind: kind ?? this.kind,
        intensity: intensity ?? this.intensity,
        createdAt: createdAt,
        releasedAt: releasedAt ?? this.releasedAt,
      );

  factory Thought.fromJson(Map<String, dynamic> json) => Thought(
        id: json['id'] as String,
        text: json['text'] as String,
        kind: ThoughtKindX.fromName(json['kind'] as String? ?? 'unsorted'),
        intensity: ThoughtIntensityX.fromName(json['intensity'] as String?),
        createdAt: DateTime.parse(json['created_at'] as String),
        releasedAt: json['released_at'] == null
            ? null
            : DateTime.parse(json['released_at'] as String),
      );

  Map<String, dynamic> toInsertJson({required String userId}) => {
        'user_id': userId,
        'text': text,
        'kind': kind.name,
        if (intensity != null) 'intensity': intensity!.name,
      };
}
