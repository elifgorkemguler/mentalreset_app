import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/supabase/supabase_config.dart';
import 'repositories/mock_thought_repository.dart';
import 'repositories/supabase_thought_repository.dart';
import 'repositories/thought_repository.dart';

class ServiceLocator {
  ServiceLocator._();

  static late final ThoughtRepository thoughts;
  static bool _initialized = false;

  static void init() {
    if (_initialized) return;
    if (SupabaseConfig.isConfigured) {
      thoughts = SupabaseThoughtRepository(Supabase.instance.client);
    } else {
      thoughts = MockThoughtRepository();
    }
    _initialized = true;
  }
}
