import 'package:shared_preferences/shared_preferences.dart';

/// In-memory + shared_preferences user profile. Holds whatever we capture from
/// sign-up before we wire real Supabase auth. Migration plan: replace [load]
/// and [save] with `supabase.auth.currentUser` + a `profiles` row read.
class UserSession {
  UserSession._();
  static final UserSession instance = UserSession._();

  String? name;
  String? email;

  static const _kName = 'user.name';
  static const _kEmail = 'user.email';

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    if (name != null && name!.trim().isNotEmpty) {
      await prefs.setString(_kName, name!.trim());
    }
    if (email != null && email!.trim().isNotEmpty) {
      await prefs.setString(_kEmail, email!.trim());
    }
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    name = prefs.getString(_kName);
    email = prefs.getString(_kEmail);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kName);
    await prefs.remove(_kEmail);
    name = null;
    email = null;
  }

  /// First name only, or "there" as a graceful fallback.
  String get displayName {
    final n = name?.trim();
    if (n == null || n.isEmpty) return 'there';
    return n.split(RegExp(r'\s+')).first;
  }
}
