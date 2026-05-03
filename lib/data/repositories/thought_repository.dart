import '../../models/thought.dart';

abstract class ThoughtRepository {
  Future<List<Thought>> fetchReleaseThoughts();
  Future<void> markReleased(String id);
  Future<void> create({
    required String text,
    required ThoughtKind kind,
    ThoughtIntensity? intensity,
  });
}
