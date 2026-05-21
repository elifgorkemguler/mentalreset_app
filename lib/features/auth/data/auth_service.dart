import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/supabase/supabase_config.dart';
import '../../onboarding/data/onboarding_data.dart';
import '../../onboarding/data/onboarding_storage.dart';
import 'user_session.dart';

class AuthResult {
  /// True if Supabase needs the user to confirm their email before signing in.
  /// Mock mode and projects with confirm-email disabled return false.
  final bool needsEmailConfirmation;
  const AuthResult._({required this.needsEmailConfirmation});

  factory AuthResult.signedIn() =>
      const AuthResult._(needsEmailConfirmation: false);
  factory AuthResult.confirmEmail() =>
      const AuthResult._(needsEmailConfirmation: true);
}

/// Single auth API the app calls. Picks the real Supabase backend if
/// `SupabaseConfig.isConfigured`, otherwise falls back to local-only fake
/// auth (UserSession), so the app stays fully usable offline / before keys
/// are wired in.
class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  bool get _useSupabase => SupabaseConfig.isConfigured;

  SupabaseClient get _client => Supabase.instance.client;

  bool get isSignedIn {
    if (_useSupabase) return _client.auth.currentUser != null;
    return UserSession.instance.email != null &&
        UserSession.instance.email!.isNotEmpty;
  }

  /// Stream that fires whenever sign-in state changes. Used by the router so
  /// it re-runs `redirect` and pushes the user where they belong.
  Stream<AuthState> get authStateChanges {
    if (!_useSupabase) return const Stream.empty();
    return _client.auth.onAuthStateChange;
  }

  Future<AuthResult> signUp({
    required String email,
    required String password,
    String? name,
  }) async {
    UserSession.instance.email = email;
    if (name != null && name.isNotEmpty) {
      UserSession.instance.name = name;
    }
    await UserSession.instance.save();

    if (!_useSupabase) return AuthResult.signedIn();

    final res = await _client.auth.signUp(
      email: email,
      password: password,
      data: {if (name != null && name.isNotEmpty) 'name': name},
    );

    // No active session → Supabase project requires email confirmation.
    if (res.session == null) return AuthResult.confirmEmail();
    return AuthResult.signedIn();
  }

  Future<AuthResult> signIn({
    required String email,
    required String password,
  }) async {
    UserSession.instance.email = email;
    await UserSession.instance.save();

    if (!_useSupabase) return AuthResult.signedIn();

    await _client.auth.signInWithPassword(email: email, password: password);

    final user = _client.auth.currentUser;
    if (user == null) {
      throw const AuthException('Sign in failed.');
    }

    // Pull display name from auth metadata if we don't have one locally.
    final metaName = user.userMetadata?['name'] as String?;
    final localName = UserSession.instance.name;
    if ((localName == null || localName.isEmpty) &&
        metaName != null &&
        metaName.isNotEmpty) {
      UserSession.instance.name = metaName;
      await UserSession.instance.save();
    }

    return AuthResult.signedIn();
  }

  /// Convenience: email of the currently signed-in user, or null.
  String? get currentUserEmail => _client.auth.currentUser?.email;
  
  Future<void> signOut() async {
    if (_useSupabase && _client.auth.currentUser != null) {
      await _client.auth.signOut();
    }
    await UserSession.instance.clear();
    //await OnboardingStorage.clear();
    OnboardingData.instance.reset();
  }
}
