import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'supabase_config.dart';

class SupabaseInit {
  SupabaseInit._();

  static Future<void> maybeInitialize() async {
    if (!SupabaseConfig.isConfigured) {
      debugPrint('[Supabase] config not set — running in mock mode.');
      return;
    }
    await Supabase.initialize(
      url: SupabaseConfig.url,
      anonKey: SupabaseConfig.anonKey,
    );
    debugPrint('[Supabase] initialized.');
  }
}
