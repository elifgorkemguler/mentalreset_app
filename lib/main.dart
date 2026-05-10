import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app.dart';
import 'core/supabase/supabase_init.dart';
import 'data/service_locator.dart';
import 'features/auth/data/user_session.dart';
import 'features/onboarding/data/onboarding_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Don't fetch fonts over the network at runtime. Without this, devices
  // without internet (e.g. fresh Android emulators with broken DNS) crash
  // when google_fonts can't reach fonts.gstatic.com. With it off, we fall
  // back to the system font silently. Bundle the .ttf files in assets/
  // when you want the real Poppins look offline.
  GoogleFonts.config.allowRuntimeFetching = false;
  FlutterError.onError = (details) {
    if (kDebugMode) FlutterError.dumpErrorToConsole(details);
  };

  await SupabaseInit.maybeInitialize();
  ServiceLocator.init();
  await UserSession.instance.load();
  await OnboardingStorage.load();
  runApp(const MindFlowApp());
}
