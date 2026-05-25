import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'core/supabase/supabase_init.dart';
import 'data/service_locator.dart';
import 'features/auth/data/user_session.dart';
import 'features/onboarding/data/onboarding_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    if (kDebugMode) FlutterError.dumpErrorToConsole(details);
  };

  // Every startup step is wrapped so a single failure (no network, bad
  // Supabase key, slow DNS) can never stop runApp() from being reached.
  try {
    await SupabaseInit.maybeInitialize()
        .timeout(const Duration(seconds: 8));
  } catch (e, st) {
    debugPrint('[startup] Supabase init skipped: $e');
    if (kDebugMode) debugPrintStack(stackTrace: st);
  }

  try {
    ServiceLocator.init();
  } catch (e) {
    debugPrint('[startup] ServiceLocator init failed: $e');
  }

  try {
    await UserSession.instance.load();
  } catch (e) {
    debugPrint('[startup] UserSession load failed: $e');
  }

  try {
    await OnboardingStorage.load();
  } catch (e) {
    debugPrint('[startup] OnboardingStorage load failed: $e');
  }

  runApp(const MindFlowApp());
}
