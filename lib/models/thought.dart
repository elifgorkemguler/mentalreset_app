/// Allowed values for `Thought.category`.
abstract class ThoughtCategory {
  static const release = 'release';
  static const action = 'action';
  static const unsorted = 'unsorted';
}

/// Allowed values for `Thought.intensity`.
abstract class ThoughtIntensity {
  static const low = 'low';
  static const medium = 'medium';
  static const high = 'high';
}

class Thought {
  final String id;
  final String userId;
  final String content;
  final String category;
  final String intensity;
  final bool isReleased;
  final DateTime createdAt;

  const Thought({
    required this.id,
    required this.userId,
    required this.content,
    this.category = ThoughtCategory.release,
    this.intensity = ThoughtIntensity.medium,
    this.isReleased = false,
    required this.createdAt,
  });

  Thought copyWith({
    String? category,
    String? intensity,
    bool? isReleased,
  }) =>
      Thought(
        id: id,
        userId: userId,
        content: content,
        category: category ?? this.category,
        intensity: intensity ?? this.intensity,
        isReleased: isReleased ?? this.isReleased,
        createdAt: createdAt,
      );

  factory Thought.fromMap(Map<String, dynamic> map) => Thought(
        id: map['id'] as String,
        userId: (map['user_id'] as String?) ?? '',
        content: map['content'] as String,
        category: (map['category'] as String?) ?? ThoughtCategory.release,
        intensity: (map['intensity'] as String?) ?? ThoughtIntensity.medium,
        isReleased: (map['is_released'] as bool?) ?? false,
        createdAt: DateTime.parse(map['created_at'] as String),
      );

  /// Full serialization — every field, server-side names. For inserts the
  /// `id` and `created_at` keys are usually ignored (defaults handle them).
  Map<String, dynamic> toMap() => {
        'id': id,
        'user_id': userId,
        'content': content,
        'category': category,
        'intensity': intensity,
        'is_released': isReleased,
        'created_at': createdAt.toUtc().toIso8601String(),
      };
}
