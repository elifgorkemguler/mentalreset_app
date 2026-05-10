import '../../models/mood_checkin.dart';

abstract class MoodRepository {
  /// Inserts a mood check-in for the current user. Returns the persisted row.
  Future<MoodCheckin> addMoodCheckin(String mood, {String? note});

  /// User's most recent check-ins, newest first.
  Future<List<MoodCheckin>> fetchRecentMoodCheckins({int limit = 20});
}
