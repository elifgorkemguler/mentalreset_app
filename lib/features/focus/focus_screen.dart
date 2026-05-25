import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  Timer? _ticker;
  late int _remainingSeconds;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = _durationFor(_sessionType).inSeconds;
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  Duration _durationFor(SessionType type) =>
      type == SessionType.deepWork ? _deepWorkDuration : _breakDuration;

  Duration get _remaining => Duration(seconds: _remainingSeconds);

  void _togglePrimary() {
    if (_started) {
      _pause();
    } else {
      _start();
    }
  }

  void _start() {
    if (_remainingSeconds <= 0) {
      _remainingSeconds = _durationFor(_sessionType).inSeconds;
    }
    setState(() => _started = true);
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remainingSeconds <= 1) {
        _ticker?.cancel();
        _ticker = null;
        setState(() {
          _remainingSeconds = 0;
          _started = false;
        });
        HapticFeedback.mediumImpact();
      } else {
        setState(() => _remainingSeconds--);
      }
    });
  }

  void _pause() {
    _ticker?.cancel();
    _ticker = null;
    setState(() => _started = false);
  }

  void _skip() {
    _ticker?.cancel();
    _ticker = null;
    setState(() {
      _started = false;
      _remainingSeconds = _durationFor(_sessionType).inSeconds;
    });
  }

  void _changeSessionType(SessionType type) {
    _ticker?.cancel();
    _ticker = null;
    setState(() {
      _sessionType = type;
      _started = false;
      _remainingSeconds = _durationFor(type).inSeconds;
    });
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
                  if (m != FocusMode.timer) {
                    _ticker?.cancel();
                    _ticker = null;
                  }
                  setState(() {
                    _mode = m;
                    if (m == FocusMode.timer) {
                      _activeBreathing = null;
                      _started = false;
                    }
                  });
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              if (_mode == FocusMode.timer)
                FocusSessionCard(
                  sessionType: _sessionType,
                  onSessionTypeChanged: _changeSessionType,
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
