import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/thought.dart';
import 'thought_repository.dart';

class SupabaseThoughtRepository implements ThoughtRepository {
  final SupabaseClient _client;
  SupabaseThoughtRepository(this._client);

  static const _table = 'thoughts';

  String get _userId {
    final u = _client.auth.currentUser;
    if (u == null) {
      throw StateError('No authenticated user — sign in before querying thoughts.');
    }
    return u.id;
  }

  @override
  Future<List<Thought>> fetchReleaseThoughts() async {
    final rows = await _client
        .from(_table)
        .select()
        .eq('user_id', _userId)
        .eq('kind', ThoughtKind.release.name)
        .filter('released_at', 'is', null)
        .order('created_at', ascending: false);

    return (rows as List)
        .cast<Map<String, dynamic>>()
        .map(Thought.fromJson)
        .toList();
  }

  @override
  Future<void> markReleased(String id) async {
    await _client
        .from(_table)
        .update({'released_at': DateTime.now().toUtc().toIso8601String()})
        .eq('id', id)
        .eq('user_id', _userId);
  }

  @override
  Future<void> create({
    required String text,
    required ThoughtKind kind,
    ThoughtIntensity? intensity,
  }) async {
    await _client.from(_table).insert({
      'user_id': _userId,
      'text': text,
      'kind': kind.name,
      if (intensity != null) 'intensity': intensity.name,
    });
  }
}
