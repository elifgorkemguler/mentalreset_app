import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/supabase/supabase_config.dart';
import 'repositories/mock_mood_repository.dart';
import 'repositories/mock_thought_repository.dart';
import 'repositories/mood_repository.dart';
import 'repositories/supabase_mood_repository.dart';
import 'repositories/supabase_thought_repository.dart';
import 'repositories/thought_repository.dart';

class ServiceLocator {
  ServiceLocator._();

  static late final ThoughtRepository thoughts;
  static late final MoodRepository moods;
  static bool _initialized = false;

  static void init() {
    if (_initialized) return;
    if (SupabaseConfig.isConfigured) {
      final client = Supabase.instance.client;
      thoughts = SupabaseThoughtRepository(client);
      moods = SupabaseMoodRepository(client);
      debugPrint('[ServiceLocator] mode = SUPABASE (table: thoughts)');
    } else {
      thoughts = MockThoughtRepository();
      moods = MockMoodRepository();
      debugPrint('[ServiceLocator] mode = MOCK (in-memory, lost on restart)');
    }
    _initialized = true;
  }
}
