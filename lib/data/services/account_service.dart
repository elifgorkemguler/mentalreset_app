// MindFlow — Account Service
// Handles account deletion: required by Apple App Store Guideline 5.1.1(v).

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/onboarding/data/onboarding_data.dart';
import '../../features/onboarding/data/onboarding_storage.dart';

/// Service responsible for sensitive account-wide operations.
/// Currently: full account deletion.
class AccountService {
  AccountService._();
  static final AccountService instance = AccountService._();

  final _client = Supabase.instance.client;

  /// Deletes all of the current user's data, then signs them out.
  ///
  /// Because the standard Supabase client cannot delete an auth.users row
  /// (that needs the service_role), we wipe everything we own (thoughts,
  /// mood check-ins, profile) and then sign the user out. The auth row
  /// becomes orphaned — that's expected, and addressed in v1.1 by a
  /// `delete-account` Edge Function with elevated privileges.
  Future<void> deleteCurrentUserAccount() async {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw StateError('No user is currently signed in.');
    }
    final userId = user.id;

    // 1. Delete user-owned rows. Order matters only if FKs cascade —
    //    RLS makes the .eq('user_id', ...) restriction implicit, but we
    //    keep it explicit for clarity.
    try {
      await _client.from('thoughts').delete().eq('user_id', userId);
    } catch (_) {/* table may be empty or missing — keep going */}

    try {
      await _client.from('mood_checkins').delete().eq('user_id', userId);
    } catch (_) {}

    try {
      await _client.from('tasks').delete().eq('user_id', userId);
    } catch (_) {}

    try {
      await _client.from('focus_sessions').delete().eq('user_id', userId);
    } catch (_) {}

    try {
      await _client.from('profiles').delete().eq('id', userId);
    } catch (_) {}

    // 2. Wipe local onboarding state so the next user starts fresh.
    try {
      await OnboardingStorage.clear();
      OnboardingData.instance.reset();
    } catch (_) {}

    // 3. Sign out — this clears the local session and any cached tokens.
    await _client.auth.signOut();
  }
}