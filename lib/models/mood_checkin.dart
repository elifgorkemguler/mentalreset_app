/// One row in `public.mood_checkins`. Mood IDs match the Home `MockData.homeMoods`
/// keys (`calm`, `anxious`, `down`, `good`, `excited`, `tired`, ...).
class MoodCheckin {
  final String id;
  final String userId;
  final String mood;
  final String? note;
  final DateTime createdAt;

  const MoodCheckin({
    required this.id,
    required this.userId,
    required this.mood,
    this.note,
    required this.createdAt,
  });

  factory MoodCheckin.fromMap(Map<String, dynamic> map) => MoodCheckin(
        id: map['id'] as String,
        userId: (map['user_id'] as String?) ?? '',
        mood: map['mood'] as String,
        note: map['note'] as String?,
        createdAt: DateTime.parse(map['created_at'] as String),
      );

  /// Full serialization. For inserts the `id` and `created_at` keys are
  /// usually ignored (defaults handle them).
  Map<String, dynamic> toMap() => {
        'id': id,
        'user_id': userId,
        'mood': mood,
        if (note != null) 'note': note,
        'created_at': createdAt.toUtc().toIso8601String(),
      };
}
