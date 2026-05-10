import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/breathing_exercise.dart';

class BreathingSession extends StatefulWidget {
  final BreathingExercise exercise;
  final VoidCallback onExit;

  const BreathingSession({
    super.key,
    required this.exercise,
    required this.onExit,
  });

  @override
  State<BreathingSession> createState() => _BreathingSessionState();
}

class _BreathingSessionState extends State<BreathingSession>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Animation<double> _scale = const AlwaysStoppedAnimation(_minScale);
  Timer? _phaseTimer;

  static const double _minScale = 0.55;
  static const double _maxScale = 1.0;

  bool _running = false;
  int _phaseIndex = 0;
  int _completedCycles = 0;
  bool _done = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _phaseTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  BreathingExercise get _ex => widget.exercise;

  BreathingPhase get _currentPhase => _ex.phases[_phaseIndex];

  void _start() {
    HapticFeedback.mediumImpact();
    setState(() {
      _running = true;
      _done = false;
      _phaseIndex = 0;
      _completedCycles = 0;
    });
    _runPhase();
  }

  void _stop() {
    _phaseTimer?.cancel();
    _controller.stop();
    HapticFeedback.lightImpact();
    setState(() {
      _running = false;
    });
  }

  void _runPhase() {
    if (!_running || !mounted) return;
    final phase = _currentPhase;
    final from = _scale.value;
    final to = switch (phase.action) {
      BreathingAction.expand => _maxScale,
      BreathingAction.contract => _minScale,
      BreathingAction.hold => from,
    };
    _controller.duration = phase.duration;
    _scale = Tween<double>(begin: from, end: to)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.forward(from: 0);
    setState(() {});

    _phaseTimer?.cancel();
    _phaseTimer = Timer(phase.duration, _onPhaseEnd);
  }

  void _onPhaseEnd() {
    if (!_running || !mounted) return;
    if (_phaseIndex + 1 < _ex.phases.length) {
      _phaseIndex++;
      _runPhase();
      return;
    }
    final cycles = _completedCycles + 1;
    if (cycles >= _ex.cycles) {
      HapticFeedback.heavyImpact();
      setState(() {
        _running = false;
        _done = true;
        _completedCycles = cycles;
      });
      return;
    }
    setState(() {
      _completedCycles = cycles;
      _phaseIndex = 0;
    });
    _runPhase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_ex.name, style: AppTextStyles.titleLarge),
                    const SizedBox(height: 2),
                    Text(_ex.tagline, style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  _stop();
                  widget.onExit();
                },
                icon: const Icon(Icons.close_rounded,
                    color: AppColors.textSecondary),
                tooltip: 'Back',
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Center(
            child: SizedBox(
              width: 240,
              height: 240,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, _) {
                      final s = _scale.value;
                      return Container(
                        width: 240 * s,
                        height: 240 * s,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppGradients.calm,
                        ),
                      );
                    },
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _statusLabel(),
                        style: AppTextStyles.titleLarge.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _statusSubtitle(),
                        style: AppTextStyles.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: _SessionButton(
                  label: _running
                      ? 'Stop'
                      : (_done ? 'Restart' : 'Start session'),
                  filled: !_running,
                  icon: _running ? Icons.stop_rounded : Icons.play_arrow_rounded,
                  onTap: _running ? _stop : _start,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _statusLabel() {
    if (_done) return 'Nicely done.';
    if (!_running) return 'Ready';
    return _currentPhase.label;
  }

  String _statusSubtitle() {
    if (_done) return '${_ex.cycles} cycles complete';
    if (!_running) return '${_ex.cycles} cycles · ${_ex.cycleLength.inSeconds}s each';
    return 'Cycle ${_completedCycles + 1} of ${_ex.cycles}';
  }
}

class _SessionButton extends StatelessWidget {
  final String label;
  final bool filled;
  final IconData icon;
  final VoidCallback onTap;

  const _SessionButton({
    required this.label,
    required this.filled,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = filled ? AppColors.primary : AppColors.surfaceMuted;
    final fg = filled ? AppColors.textOnPrimary : AppColors.textPrimary;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.pill),
        onTap: onTap,
        child: Container(
          height: 52,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            boxShadow: filled ? AppShadows.button : const [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: fg, size: 20),
              const SizedBox(width: 8),
              Text(label, style: AppTextStyles.buttonLarge.copyWith(color: fg)),
            ],
          ),
        ),
      ),
    );
  }
}
