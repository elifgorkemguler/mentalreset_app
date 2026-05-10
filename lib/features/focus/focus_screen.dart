import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../models/breathing_exercise.dart';
import 'widgets/breathing_picker.dart';
import 'widgets/breathing_session.dart';
import 'widgets/focus_header.dart';
import 'widgets/focus_mode_switch.dart';
import 'widgets/focus_session_card.dart';
import 'widgets/session_type_toggle.dart';

class FocusScreen extends StatefulWidget {
  const FocusScreen({super.key});

  @override
  State<FocusScreen> createState() => _FocusScreenState();
}

class _FocusScreenState extends State<FocusScreen> {
  FocusMode _mode = FocusMode.timer;
  SessionType _sessionType = SessionType.deepWork;
  bool _started = false;
  BreathingExercise? _activeBreathing;

  static const _deepWorkDuration = Duration(minutes: 25);
  static const _breakDuration = Duration(minutes: 5);

  Duration get _remaining => _sessionType == SessionType.deepWork
      ? _deepWorkDuration
      : _breakDuration;

  void _togglePrimary() => setState(() => _started = !_started);

  void _skip() {
    setState(() => _started = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.xxl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const FocusHeader(),
              const SizedBox(height: AppSpacing.lg),
              FocusModeSwitch(
                value: _mode,
                onChanged: (m) {
                  setState(() {
                    _mode = m;
                    if (m == FocusMode.timer) _activeBreathing = null;
                  });
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              if (_mode == FocusMode.timer)
                FocusSessionCard(
                  sessionType: _sessionType,
                  onSessionTypeChanged: (t) {
                    setState(() {
                      _sessionType = t;
                      _started = false;
                    });
                  },
                  currentTask: 'Finish assignment outline',
                  remaining: _remaining,
                  started: _started,
                  onSkip: _skip,
                  onPrimary: _togglePrimary,
                )
              else if (_activeBreathing != null)
                BreathingSession(
                  exercise: _activeBreathing!,
                  onExit: () => setState(() => _activeBreathing = null),
                )
              else
                BreathingPicker(
                  onPick: (ex) => setState(() => _activeBreathing = ex),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
