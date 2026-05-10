import 'package:flutter/foundation.dart';

/// Cross-screen "thoughts changed" signal. Bumps a revision number whenever
/// any caller writes to the thought store. Screens (e.g. Release) listen and
/// re-fetch automatically — saves us from threading callbacks through the
/// widget tree.
class ThoughtFeed {
  ThoughtFeed._();

  static final ValueNotifier<int> revision = ValueNotifier(0);

  static void notifyChanged() {
    revision.value++;
  }
}
