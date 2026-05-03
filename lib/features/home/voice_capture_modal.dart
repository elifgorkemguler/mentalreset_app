import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/primary_gradient_button.dart';

enum _VoiceState { idle, listening, captured }

class VoiceCaptureModal extends StatefulWidget {
  const VoiceCaptureModal({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.35),
      builder: (_) => const VoiceCaptureModal(),
    );
  }

  @override
  State<VoiceCaptureModal> createState() => _VoiceCaptureModalState();
}

class _VoiceCaptureModalState extends State<VoiceCaptureModal>
    with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final AnimationController _waveController;

  _VoiceState _state = _VoiceState.idle;
  Duration _elapsed = Duration.zero;
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _waveController.dispose();
    _ticker?.cancel();
    super.dispose();
  }

  void _toggleListening() {
    if (_state == _VoiceState.listening) {
      _stopListening();
    } else {
      _startListening();
    }
  }

  void _startListening() {
    HapticFeedback.mediumImpact();
    setState(() {
      _state = _VoiceState.listening;
      _elapsed = Duration.zero;
    });
    _pulseController.repeat();
    _waveController.repeat();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _elapsed += const Duration(seconds: 1));
    });
  }

  void _stopListening() {
    HapticFeedback.lightImpact();
    _ticker?.cancel();
    _pulseController.stop();
    _waveController.stop();
    setState(() {
      _state = _elapsed == Duration.zero ? _VoiceState.idle : _VoiceState.captured;
    });
  }

  String _statusText() {
    switch (_state) {
      case _VoiceState.idle:
        return 'Tap the mic to start';
      case _VoiceState.listening:
        return 'Listening...';
      case _VoiceState.captured:
        return 'Got it. Add more or tap Done.';
    }
  }

  String _formatElapsed() {
    final m = _elapsed.inMinutes.toString().padLeft(2, '0');
    final s = (_elapsed.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final isListening = _state == _VoiceState.listening;
    final hasCaptured = _state == _VoiceState.captured;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xxl)),
        ),
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.base,
          AppSpacing.xl,
          AppSpacing.xl,
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _DragHandle(),
              const SizedBox(height: AppSpacing.lg),
              Text('Capture Your Thoughts', style: AppTextStyles.headlineMedium),
              const SizedBox(height: 6),
              Text(
                'Speak freely. We will sort it out together.',
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xxl),
              _PulsingMicButton(
                pulse: _pulseController,
                listening: isListening,
                onTap: _toggleListening,
              ),
              const SizedBox(height: AppSpacing.xl),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                child: Text(
                  _statusText(),
                  key: ValueKey(_state),
                  style: AppTextStyles.titleMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                _formatElapsed(),
                style: AppTextStyles.labelMedium.copyWith(
                  color: isListening ? AppColors.primary : AppColors.textMuted,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              SizedBox(
                height: 56,
                child: _AudioWave(
                  controller: _waveController,
                  active: isListening,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Row(
                children: [
                  Expanded(
                    child: _SecondaryAction(
                      label: 'Cancel',
                      onTap: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: PrimaryGradientButton(
                      label: 'Done',
                      onPressed: hasCaptured
                          ? () => Navigator.of(context).pop()
                          : null,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DragHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 4,
      decoration: BoxDecoration(
        color: AppColors.border,
        borderRadius: BorderRadius.circular(99),
      ),
    );
  }
}

class _PulsingMicButton extends StatelessWidget {
  final AnimationController pulse;
  final bool listening;
  final VoidCallback onTap;

  const _PulsingMicButton({
    required this.pulse,
    required this.listening,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 200,
      child: AnimatedBuilder(
        animation: pulse,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              if (listening) ..._rings(pulse.value),
              child!,
            ],
          );
        },
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            width: listening ? 120 : 110,
            height: listening ? 120 : 110,
            decoration: BoxDecoration(
              gradient: AppGradients.primary,
              shape: BoxShape.circle,
              boxShadow: AppShadows.button,
            ),
            child: Icon(
              listening ? Icons.stop_rounded : Icons.mic_rounded,
              color: Colors.white,
              size: listening ? 44 : 48,
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _rings(double t) {
    final ringSpecs = [0.0, 0.33, 0.66];
    return ringSpecs.map((offset) {
      final phase = ((t + offset) % 1.0);
      final scale = 0.6 + phase * 1.2;
      final opacity = (1.0 - phase) * 0.45;
      return IgnorePointer(
        child: Transform.scale(
          scale: scale,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary.withValues(alpha: opacity.clamp(0.0, 1.0)),
                width: 2,
              ),
            ),
          ),
        ),
      );
    }).toList();
  }
}

class _AudioWave extends StatelessWidget {
  static const int _barCount = 21;

  final AnimationController controller;
  final bool active;

  const _AudioWave({
    required this.controller,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(_barCount, (i) => _bar(i)),
        );
      },
    );
  }

  Widget _bar(int i) {
    const baseHeight = 6.0;
    const maxHeight = 48.0;
    double height;
    if (active) {
      final phase = controller.value * 2 * math.pi + i * 0.55;
      final amplitude = 0.5 + 0.5 * math.sin(phase);
      final centerBoost = 1.0 - (i - _barCount / 2).abs() / _barCount;
      height = baseHeight + (maxHeight - baseHeight) * amplitude * centerBoost;
    } else {
      height = baseHeight;
    }
    return AnimatedContainer(
      duration: const Duration(milliseconds: 90),
      curve: Curves.easeOut,
      margin: const EdgeInsets.symmetric(horizontal: 2.5),
      width: 4,
      height: height,
      decoration: BoxDecoration(
        gradient: AppGradients.primary,
        borderRadius: BorderRadius.circular(99),
      ),
    );
  }
}

class _SecondaryAction extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SecondaryAction({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.pill),
        onTap: onTap,
        child: Container(
          height: 56,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.surfaceMuted,
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
          child: Text(
            label,
            style: AppTextStyles.labelLarge.copyWith(color: AppColors.textPrimary),
          ),
        ),
      ),
    );
  }
}
