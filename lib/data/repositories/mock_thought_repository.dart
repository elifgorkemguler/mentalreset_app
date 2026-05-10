import '../../models/thought.dart';
import 'thought_repository.dart';

class MockThoughtRepository implements ThoughtRepository {
  static const _mockUserId = 'mock-user';

  final List<Thought> _store = <Thought>[];

  @override
  Future<List<Thought>> fetchReleaseThoughts() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _store
        .where((t) =>
            t.category == ThoughtCategory.release && !t.isReleased)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Future<Thought> addThought({
    required String content,
    String category = ThoughtCategory.release,
    String intensity = ThoughtIntensity.medium,
  }) async {
    final thought = Thought(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      userId: _mockUserId,
      content: content,
      category: category,
      intensity: intensity,
      createdAt: DateTime.now(),
    );
    _store.add(thought);
    return thought;
  }

  @override
  Future<void> releaseThought(String id) async {
    await Future.delayed(const Duration(milliseconds: 120));
    final i = _store.indexWhere((t) => t.id == id);
    if (i == -1) return;
    _store[i] = _store[i].copyWith(isReleased: true);
  }

  @override
  Future<void> deleteThoughtPermanently(String id) async {
    _store.removeWhere((t) => t.id == id);
  }
}
