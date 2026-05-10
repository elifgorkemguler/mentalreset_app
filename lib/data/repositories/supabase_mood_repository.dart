import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/mood_checkin.dart';
import 'mood_repository.dart';
import 'supabase_thought_repository.dart' show NotAuthenticatedException;

class SupabaseMoodRepository implements MoodRepository {
  final SupabaseClient _client;
  SupabaseMoodRepository(this._client);

  static const _table = 'mood_checkins';

  String get _userId {
    final u = _client.auth.currentUser;
    if (u == null) throw const NotAuthenticatedException();
    return u.id;
  }

  @override
  Future<MoodCheckin> addMoodCheckin(String mood, {String? note}) async {
    final inserted = await _client
        .from(_table)
        .insert({
          'user_id': _userId,
          'mood': mood,
          'note': note,
        })
        .select()
        .single();

    return MoodCheckin.fromMap(inserted);
  }

  @override
  Future<List<MoodCheckin>> fetchRecentMoodCheckins({int limit = 20}) async {
    final rows = await _client
        .from(_table)
        .select()
        .eq('user_id', _userId)
        .order('created_at', ascending: false)
        .limit(limit);

    return (rows as List)
        .cast<Map<String, dynamic>>()
        .map(MoodCheckin.fromMap)
        .toList();
  }
}
