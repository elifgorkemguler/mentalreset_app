import '../../models/thought.dart';

/// Data-access boundary for thoughts. The mock implementation runs in-memory
/// (used when Supabase is not configured); the Supabase implementation talks
/// to the `public.thoughts` table guarded by RLS.
abstract class ThoughtRepository {
  /// Active thoughts in the "release" pile for the current user, ordered
  /// newest first. Excludes already-released ones (`is_released = true`).
  Future<List<Thought>> fetchReleaseThoughts();

  /// Inserts a new thought and returns the persisted row (with the
  /// server-assigned id and created_at).
  Future<Thought> addThought({
    required String content,
    String category = ThoughtCategory.release,
    String intensity = ThoughtIntensity.medium,
  });

  /// Marks a thought as released (`is_released = true`). Does NOT hard-delete
  /// — Insights and history can still count it later.
  Future<void> releaseThought(String id);

  /// Hard-deletes the row. Not used from the UI today; reserved for an
  /// eventual "clear history" / GDPR-style flow.
  Future<void> deleteThoughtPermanently(String id);
}
