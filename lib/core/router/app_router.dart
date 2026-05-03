import 'package:go_router/go_router.dart';

import '../../features/auth/login_screen.dart';
import '../../features/focus/focus_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/insights/insights_screen.dart';
import '../../features/onboarding/onboarding_complete_screen.dart';
import '../../features/onboarding/onboarding_intent_screen.dart';
import '../../features/onboarding/onboarding_mood_screen.dart';
import '../../features/release/release_screen.dart';
import '../../features/shell/main_shell.dart';
import '../../features/todo/todo_screen.dart';
import 'routes.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.login,
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboardingIntent,
        builder: (context, state) => const OnboardingIntentScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboardingMood,
        builder: (context, state) => const OnboardingMoodScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboardingComplete,
        builder: (context, state) => const OnboardingCompleteScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => MainShellRouter(shell: shell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppRoutes.home,
              builder: (context, state) => const HomeScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppRoutes.release,
              builder: (context, state) => const ReleaseScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppRoutes.todo,
              builder: (context, state) => const TodoScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppRoutes.focus,
              builder: (context, state) => const FocusScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppRoutes.insights,
              builder: (context, state) => const InsightsScreen(),
            ),
          ]),
        ],
      ),
    ],
  );
}
