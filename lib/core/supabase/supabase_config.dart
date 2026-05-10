class SupabaseConfig {
  SupabaseConfig._();

  // Paste from Supabase → Project Settings → API
  // Leave both empty to keep the app running on local mock data.
  static const String url = 'https://klfqcwluwsqwczzoykym.supabase.co';
  static const String anonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtsZnFjd2x1d3Nxd2N6em95a3ltIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzc4MDY0MjUsImV4cCI6MjA5MzM4MjQyNX0.oxIp7TWXq-52IAgnp7qKmvcbisawWTurouS5F4iLw-I';

  static bool get isConfigured => url.isNotEmpty && anonKey.isNotEmpty;
}
