import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/repositories/supabase_thought_repository.dart';
import '../../data/service_locator.dart';
import '../../data/thought_feed.dart';
import '../../widgets/primary_gradient_button.dart';
import '../../data/services/ai_service.dart';
import '../ai_sort/ai_sort_result_screen.dart';

enum _VoiceState { idle, listening, captured }

/// Captures a thought via speech-to-text. The transcript flows into an
/// editable [TextField] so the user can type, fix STT mistakes, or skip the
/// mic entirely. On iOS the system needs `NSMicrophoneUsageDescription` and
/// `NSSpeechRecognitionUsageDescription` (already in Info.plist). On Android
/// we ship the `RECORD_AUDIO` permission and a `RecognitionService` query in
/// the manifest.
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
  final _speech = stt.SpeechToText();
  final _ctrl = TextEditingController();
  late final AnimationController _pulseController;
  late final AnimationController _waveController;

  _VoiceState _state = _VoiceState.idle;
  String _error = '';
  bool _speechAvailable = false;
  Duration _elapsed = Duration.zero;
  Timer? _ticker;
  bool _saving = false;

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
    _ctrl.addListener(() => setState(() {}));
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    try {
      final ok = await _speech.initialize(
        onError: (err) {
          if (!mounted) return;
          setState(() {
            _error = err.errorMsg;
            _state = _VoiceState.idle;
          });
          _stopTicker();
          _pulseController.stop();
          _waveController.stop();
        },
        onStatus: (status) {
          if (!mounted) return;
          if (status == 'notListening' && _state == _VoiceState.listening) {
            _onStoppedListening();
          }
        },
      );
      if (!mounted) return;
      setState(() {
        _speechAvailable = ok;
        if (!ok) {
          _error = 'Speech recognition is not available on this device.';
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _waveController.dispose();
    _ticker?.cancel();
    if (_speech.isListening) _speech.stop();
    _ctrl.dispose();
    super.dispose();
  }

  void _stopTicker() {
    _ticker?.cancel();
    _ticker = null;
  }

  void _toggleListening() {
    if (_state == _VoiceState.listening) {
      _stopListening();
    } else {
      _startListening();
    }
  }

  Future<void> _startListening() async {
    if (!_speechAvailable) return;
    HapticFeedback.mediumImpact();
    setState(() {
      _state = _VoiceState.listening;
      _ctrl.clear();
      _error = '';
      _elapsed = Duration.zero;
    });
    _pulseController.repeat();
    _waveController.repeat();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _elapsed += const Duration(seconds: 1));
    });
    await _speech.listen(
      localeId: 'en_US',
      listenFor: const Duration(minutes: 2),
      pauseFor: const Duration(seconds: 6),
      onResult: (result) {
        if (!mounted) return;
        _ctrl.value = TextEditingValue(
          text: result.recognizedWords,
          selection:
              TextSelection.collapsed(offset: result.recognizedWords.length),
        );
      },
      listenOptions: stt.SpeechListenOptions(
        partialResults: true,
        cancelOnError: true,
      ),
    );
  }

  Future<void> _stopListening() async {
    HapticFeedback.lightImpact();
    await _speech.stop();
    _onStoppedListening();
  }

  void _onStoppedListening() {
    if (!mounted) return;
    _stopTicker();
    _pulseController.stop();
    _waveController.stop();
    setState(() {
      _state = _ctrl.text.trim().isEmpty
          ? _VoiceState.idle
          : _VoiceState.captured;
    });
  }

  bool get _canDone => _ctrl.text.trim().isNotEmpty && !_saving;

  Future<void> _done() async {
    final text = _ctrl.text.trim();
    if (text.isEmpty) return;
    setState(() => _saving = true);

    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final rootContext = navigator.context;

    if (_speech.isListening) {
      await _speech.stop();
    }

    try {
      // 1. Call AI to sort the thought
      final result = await AiService.instance.sortThought(text);

      if (!mounted) return;

      // 2. Close the modal
      navigator.pop();

      // 3. Open the AI sort result screen
      Navigator.of(rootContext).push(
        MaterialPageRoute(
          builder: (_) => AiSortResultScreen(
            originalThought: text,
            result: result,
          ),
          fullscreenDialog: true,
        ),
      );
    } on AiServiceException catch (e) {
      if (!mounted) return;
      try {
        await ServiceLocator.thoughts.addThought(content: text);
        ThoughtFeed.notifyChanged();
        if (!mounted) return;
        navigator.pop();
        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content: Text(
              'AI unavailable, saved to Release.',
              style: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.textOnPrimary),
            ),
            backgroundColor: AppColors.primary,
            behavior: SnackBarBehavior.floating,
          ));
      } catch (_) {
        if (!mounted) return;
        setState(() => _saving = false);
        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text('Could not save: ${e.message}')));
      }
    } on NotAuthenticatedException catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(e.toString())));
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('Could not save: $e')));
    }
  }

  String _statusText() {
    if (_error.isNotEmpty) return _error;
    switch (_state) {
      case _VoiceState.idle:
        return _speechAvailable
            ? 'Tap the mic to start (English)'
            : 'Initializing speech recognition...';
      case _VoiceState.listening:
        return 'Listening...';
      case _VoiceState.captured:
        return 'Got it. Edit, add more, or tap Done.';
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(child: _DragHandle()),
                const SizedBox(height: AppSpacing.lg),
                Center(
                  child: Text('Capture your thoughts',
                      style: AppTextStyles.headlineMedium),
                ),
                const SizedBox(height: 6),
                Text(
                  'Speak in English or type below — both work.',
                  style: AppTextStyles.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.lg),
                Center(
                  child: _PulsingMicButton(
                    pulse: _pulseController,
                    listening: isListening,
                    onTap: _toggleListening,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    child: Text(
                      _statusText(),
                      key: ValueKey('${_state.name}_$_error'),
                      style: AppTextStyles.titleMedium.copyWith(
                        color: _error.isNotEmpty
                            ? AppColors.error
                            : AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Center(
                  child: Text(
                    _formatElapsed(),
                    style: AppTextStyles.labelMedium.copyWith(
                      color:
                          isListening ? AppColors.primary : AppColors.textMuted,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  height: 36,
                  child: _AudioWave(
                    controller: _waveController,
                    active: isListening,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'CAPTURED THOUGHT',
                  style: AppTextStyles.labelMedium.copyWith(
                    letterSpacing: 1.2,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceMuted,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    border: Border.all(color: AppColors.border, width: 1),
                  ),
                  padding: const EdgeInsets.all(AppSpacing.base),
                  child: TextField(
                    controller: _ctrl,
                    maxLines: 5,
                    minLines: 3,
                    style: AppTextStyles.bodyLarge,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isCollapsed: true,
                      hintText:
                          'Tap the mic and speak, or type here directly...',
                      hintStyle: AppTextStyles.bodyMedium
                          .copyWith(color: AppColors.textMuted),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
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
                        loading: _saving,
                        onPressed: _canDone ? _done : null,
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
      width: 160,
      height: 160,
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
            width: listening ? 100 : 92,
            height: listening ? 100 : 92,
            decoration: BoxDecoration(
              gradient: AppGradients.primary,
              shape: BoxShape.circle,
              boxShadow: AppShadows.button,
            ),
            child: Icon(
              listening ? Icons.stop_rounded : Icons.mic_rounded,
              color: Colors.white,
              size: listening ? 38 : 40,
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
            width: 100,
            height: 100,
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
    const baseHeight = 4.0;
    const maxHeight = 32.0;
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
