import '../../models/thought.dart';
import 'thought_repository.dart';

class MockThoughtRepository implements ThoughtRepository {
  final List<Thought> _store;

  MockThoughtRepository() : _store = List.of(_seed);

  @override
  Future<List<Thought>> fetchReleaseThoughts() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _store
        .where((t) => t.kind == ThoughtKind.release && t.releasedAt == null)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Future<void> markReleased(String id) async {
    await Future.delayed(const Duration(milliseconds: 120));
    final i = _store.indexWhere((t) => t.id == id);
    if (i == -1) return;
    _store[i] = _store[i].copyWith(releasedAt: DateTime.now());
  }

  @override
  Future<void> create({
    required String text,
    required ThoughtKind kind,
    ThoughtIntensity? intensity,
  }) async {
    _store.add(
      Thought(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        text: text,
        kind: kind,
        intensity: intensity,
        createdAt: DateTime.now(),
      ),
    );
  }

  static final List<Thought> _seed = [
    Thought(
      id: 'r1',
      text:
          'Worried about the upcoming presentation and whether I prepared enough',
      kind: ThoughtKind.release,
      intensity: ThoughtIntensity.high,
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    Thought(
      id: 'r2',
      text: 'Feeling guilty about not calling mom back yesterday',
      kind: ThoughtKind.release,
      intensity: ThoughtIntensity.medium,
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    Thought(
      id: 'r3',
      text: 'Anxious about what they think of me after that conversation',
      kind: ThoughtKind.release,
      intensity: ThoughtIntensity.high,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    Thought(
      id: 'r4',
      text: 'Frustrated that I procrastinated on my assignment again',
      kind: ThoughtKind.release,
      intensity: ThoughtIntensity.medium,
      createdAt: DateTime.now().subtract(const Duration(hours: 8)),
    ),
  ];
}
