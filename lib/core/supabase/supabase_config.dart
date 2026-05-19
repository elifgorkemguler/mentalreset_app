class SupabaseConfig {
  SupabaseConfig._();

  // Paste from Supabase → Project Settings → API
  // Leave both empty to keep the app running on local mock data.
  static const String url = 'https://vrlkadyhfzldvkxmamsh.supabase.co';
  static const String anonKey = 'sb_publishable_tB0O2hFmzG8o_uSYT3NotA_ASUyKczy';

  static bool get isConfigured => url.isNotEmpty && anonKey.isNotEmpty;
}
