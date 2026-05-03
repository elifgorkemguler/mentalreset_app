import 'package:shared_preferences/shared_preferences.dart';

import 'onboarding_data.dart';

/// Persistence boundary for onboarding answers. Today: shared_preferences.
/// Tomorrow: swap the body of these methods to upsert into Supabase
/// `profiles` (and related) tables — callers stay unchanged.
class OnboardingStorage {
  OnboardingStorage._();

  static const _kData = 'onboarding.data.v1';
  static const _kCompleted = 'onboarding.completed.v1';

  static Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kData, OnboardingData.instance.encode());
    await prefs.setBool(_kCompleted, true);
  }

  /// Loads any persisted answers into the singleton. Returns true if data
  /// was found.
  static Future<bool> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kData);
    if (raw == null) return false;
    OnboardingData.instance.decode(raw);
    return true;
  }

  static Future<bool> isCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kCompleted) ?? false;
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kData);
    await prefs.remove(_kCompleted);
    OnboardingData.instance.reset();
  }
}
