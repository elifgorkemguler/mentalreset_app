import '../../models/mood_checkin.dart';
import 'mood_repository.dart';

class MockMoodRepository implements MoodRepository {
  static const _mockUserId = 'mock-user';

  final List<MoodCheckin> _store = <MoodCheckin>[];

  @override
  Future<MoodCheckin> addMoodCheckin(String mood, {String? note}) async {
    await Future.delayed(const Duration(milliseconds: 80));
    final m = MoodCheckin(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      userId: _mockUserId,
      mood: mood,
      note: note,
      createdAt: DateTime.now(),
    );
    _store.add(m);
    return m;
  }

  @override
  Future<List<MoodCheckin>> fetchRecentMoodCheckins({int limit = 20}) async {
    await Future.delayed(const Duration(milliseconds: 80));
    final sorted = List<MoodCheckin>.from(_store)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sorted.take(limit).toList();
  }
}
