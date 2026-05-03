class SupabaseConfig {
  SupabaseConfig._();

  // Paste from Supabase → Project Settings → API
  // Leave both empty to keep the app running on local mock data.
  static const String url = '';
  static const String anonKey = '';

  static bool get isConfigured => url.isNotEmpty && anonKey.isNotEmpty;
}
