enum BreathingAction { expand, hold, contract }

class BreathingPhase {
  final String label;
  final Duration duration;
  final BreathingAction action;

  const BreathingPhase({
    required this.label,
    required this.duration,
    required this.action,
  });
}

class BreathingExercise {
  final String id;
  final String name;
  final String tagline;
  final String summary;
  final List<BreathingPhase> phases;
  final int cycles;

  /// Optional hint mapping to `OnboardingData.stressResponse` so the picker
  /// can mark this exercise "Recommended for you".
  final String? recommendedFor;

  const BreathingExercise({
    required this.id,
    required this.name,
    required this.tagline,
    required this.summary,
    required this.phases,
    required this.cycles,
    this.recommendedFor,
  });

  Duration get cycleLength =>
      phases.fold(Duration.zero, (acc, p) => acc + p.duration);
}
