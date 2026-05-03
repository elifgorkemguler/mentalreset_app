import 'package:flutter/material.dart';

import 'app.dart';
import 'core/supabase/supabase_init.dart';
import 'data/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseInit.maybeInitialize();
  ServiceLocator.init();
  runApp(const MentalResetApp());
}
