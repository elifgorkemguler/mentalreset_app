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

  static const _table = 'thoughts';

  String get _userId {
    final u = _client.auth.currentUser;
    if (u == null) throw const NotAuthenticatedException();
    return u.id;
  }

  @override
  Future<List<Thought>> fetchReleaseThoughts() async {
    final rows = await _client
        .from(_table)
        .select()
        .eq('user_id', _userId)
        .eq('category', ThoughtCategory.release)
        .eq('is_released', false)
        .order('created_at', ascending: false);

    return (rows as List)
        .cast<Map<String, dynamic>>()
        .map(Thought.fromMap)
        .toList();
  }

  @override
  Future<Thought> addThought({
    required String content,
    String category = ThoughtCategory.release,
    String intensity = ThoughtIntensity.medium,
  }) async {
    final inserted = await _client
        .from(_table)
        .insert({
          'user_id': _userId,
          'content': content,
          'category': category,
          'intensity': intensity,
          'is_released': false,
        })
        .select()
        .single();

    return Thought.fromMap(inserted);
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
