import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/data/auth_service.dart';
import '../../features/auth/login_screen.dart';
import '../../features/focus/focus_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/insights/insights_screen.dart';
import '../../features/onboarding/data/onboarding_storage.dart';
import '../../features/onboarding/presentation/age_role_screen.dart';
import '../../features/onboarding/presentation/ai_tone_screen.dart';
import '../../features/onboarding/presentation/goals_screen.dart';
import '../../features/onboarding/presentation/ready_screen.dart';
import '../../features/onboarding/presentation/stress_response_screen.dart';
import '../../features/onboarding/presentation/stress_sources_screen.dart';
import '../../features/onboarding/presentation/welcome_screen.dart';
import '../../features/release/release_screen.dart';
import '../../features/shell/main_shell.dart';
import '../../features/todo/todo_screen.dart';
import 'routes.dart';

CupertinoPage<void> _cupertinoPage(GoRouterState state, Widget child) {
  return CupertinoPage<void>(
    key: state.pageKey,
    name: state.name,
    child: child,
  );
}

class AppRouter {
  AppRouter._();

  static final _AuthRefreshNotifier _authRefresh = _AuthRefreshNotifier();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.login,
    redirect: _redirect,
    refreshListenable: _authRefresh,
    routes: [
      GoRoute(
        path: AppRoutes.login,
        pageBuilder: (context, state) => _cupertinoPage(state, const LoginScreen()),
      ),

      // Onboarding (7 screens)
      GoRoute(
        path: AppRoutes.onboardingWelcome,
        pageBuilder: (context, state) =>
            _cupertinoPage(state, const WelcomeScreen()),
      ),
      GoRoute(
        path: AppRoutes.onboardingAgeRole,
        pageBuilder: (context, state) =>
            _cupertinoPage(state, const AgeRoleScreen()),
      ),
      GoRoute(
        path: AppRoutes.onboardingStressSources,
        pageBuilder: (context, state) =>
            _cupertinoPage(state, const StressSourcesScreen()),
      ),
      GoRoute(
        path: AppRoutes.onboardingStressResponse,
        pageBuilder: (context, state) =>
            _cupertinoPage(state, const StressResponseScreen()),
      ),
      GoRoute(
        path: AppRoutes.onboardingAiTone,
        pageBuilder: (context, state) =>
            _cupertinoPage(state, const AiToneScreen()),
      ),
      GoRoute(
        path: AppRoutes.onboardingGoals,
        pageBuilder: (context, state) =>
            _cupertinoPage(state, const GoalsScreen()),
      ),
      GoRoute(
        path: AppRoutes.onboardingReady,
        pageBuilder: (context, state) =>
            _cupertinoPage(state, const ReadyScreen()),
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

  /// Auth + onboarding gate.
  /// 1. Not signed in → only the login screen is reachable.
  /// 2. Signed in but onboarding incomplete → force onboarding before tabs.
  /// 3. Signed in and trying to view login → bounce to home.
  static Future<String?> _redirect(
      BuildContext context, GoRouterState state) async {
    final loc = state.matchedLocation;
    final isLogin = loc == AppRoutes.login;
    final isOnboarding = loc.startsWith('/onboarding');
    final isTab = loc == AppRoutes.home ||
        loc == AppRoutes.release ||
        loc == AppRoutes.todo ||
        loc == AppRoutes.focus ||
        loc == AppRoutes.insights;

    final signedIn = AuthService.instance.isSignedIn;

    if (!signedIn) {
      return isLogin ? null : AppRoutes.login;
    }

    if (isLogin) return AppRoutes.home;

    if (isTab) {
      final completed = await OnboardingStorage.isCompleted();
      if (!completed) return AppRoutes.onboardingWelcome;
    }

    // Onboarding routes pass through unchanged when signed in.
    if (isOnboarding) return null;

    return null;
  }
}

/// Bridges Supabase auth state changes into go_router so the redirect re-runs
/// automatically on sign-in / sign-out. Empty stream in mock mode → no-op.
class _AuthRefreshNotifier extends ChangeNotifier {
  StreamSubscription<dynamic>? _sub;

  _AuthRefreshNotifier() {
    _sub = AuthService.instance.authStateChanges.listen((_) => notifyListeners());
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
