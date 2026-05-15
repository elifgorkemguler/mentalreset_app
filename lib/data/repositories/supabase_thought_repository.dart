import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/thought.dart';
import 'thought_repository.dart';

/// Auth-required exception. Modals catch this and show a clear "please sign
/// in" message instead of a stack trace.
class NotAuthenticatedException implements Exception {
  const NotAuthenticatedException();
  @override
  String toString() => 'User is not signed in.';
}

class SupabaseThoughtRepository implements ThoughtRepository {
  final SupabaseClient _client;
  SupabaseThoughtRepository(this._client);

  /// The app reads and writes the `thoughts` table — NOT `inputs`.
  static const _table = 'thoughts';

  String get _userId {
    final u = _client.auth.currentUser;
    if (u == null) throw const NotAuthenticatedException();
    return u.id;
  }

  @override
  Future<List<Thought>> fetchReleaseThoughts() async {
    final userId = _userId;
    debugPrint('[thoughts] fetchReleaseThoughts for user=$userId');
    try {
      final rows = await _client
          .from(_table)
          .select()
          .eq('user_id', userId)
          .eq('category', ThoughtCategory.release)
          .eq('is_released', false)
          .order('created_at', ascending: false);

      final list = (rows as List)
          .cast<Map<String, dynamic>>()
          .map(Thought.fromMap)
          .toList();
      debugPrint('[thoughts] fetched ${list.length} release row(s)');
      return list;
    } catch (e) {
      debugPrint('[thoughts] fetch FAILED: $e');
      rethrow;
    }
  }

  @override
  Future<Thought> addThought({
    required String content,
    String category = ThoughtCategory.release,
    String intensity = ThoughtIntensity.medium,
  }) async {
    final userId = _userId;
    debugPrint('[thoughts] addThought user=$userId category=$category '
        'content="${content.length > 40 ? '${content.substring(0, 40)}...' : content}"');
    try {
      final inserted = await _client
          .from(_table)
          .insert({
            'user_id': userId,
            'content': content,
            'category': category,
            'intensity': intensity,
            'is_released': false,
          })
          .select()
          .single();
      debugPrint('[thoughts] inserted row id=${inserted['id']}');
      return Thought.fromMap(inserted);
    } catch (e) {
      debugPrint('[thoughts] insert FAILED: $e');
      rethrow;
    }
  }

  @override
  Future<void> releaseThought(String id) async {
    await _client
        .from(_table)
        .update({'is_released': true})
        .eq('id', id)
        .eq('user_id', _userId);
  }

  @override
  Future<void> deleteThoughtPermanently(String id) async {
    await _client
        .from(_table)
        .delete()
        .eq('id', id)
        .eq('user_id', _userId);
  }
}
