import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/soft_card.dart';
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
                onChanged: (m) => setState(() => _mode = m),
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
              else
                const _BreathingPlaceholder(),
            ],
          ),
        ),
      ),
    );
  }
}

class _BreathingPlaceholder extends StatelessWidget {
  const _BreathingPlaceholder();

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.cardPadding,
        vertical: AppSpacing.xxl,
      ),
      child: Column(
        children: [
          const Icon(Icons.air_rounded,
              size: 56, color: AppColors.accentSkyDeep),
          const SizedBox(height: AppSpacing.base),
          Text('Breathing mode', style: AppTextStyles.titleLarge),
          const SizedBox(height: 4),
          Text(
            'Guided breathing exercises coming soon.',
            style: AppTextStyles.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
