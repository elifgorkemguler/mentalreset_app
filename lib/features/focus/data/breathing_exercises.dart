import '../../../models/breathing_exercise.dart';

class BreathingExercises {
  BreathingExercises._();

  static const box = BreathingExercise(
    id: 'box',
    name: 'Box breathing',
    tagline: '4 · 4 · 4 · 4',
    summary: 'Equal inhale, hold, exhale, hold. Steadies focus before deep work.',
    cycles: 5,
    recommendedFor: 'procrastinate',
    phases: [
      BreathingPhase(
        label: 'Breathe in',
        duration: Duration(seconds: 4),
        action: BreathingAction.expand,
      ),
      BreathingPhase(
        label: 'Hold',
        duration: Duration(seconds: 4),
        action: BreathingAction.hold,
      ),
      BreathingPhase(
        label: 'Breathe out',
        duration: Duration(seconds: 4),
        action: BreathingAction.contract,
      ),
      BreathingPhase(
        label: 'Hold',
        duration: Duration(seconds: 4),
        action: BreathingAction.hold,
      ),
    ],
  );

  static const fourSevenEight = BreathingExercise(
    id: '478',
    name: '4 · 7 · 8 relax',
    tagline: 'Inhale 4, hold 7, exhale 8',
    summary: 'A long exhale slows a racing mind. Good before sleep.',
    cycles: 4,
    recommendedFor: 'overthink',
    phases: [
      BreathingPhase(
        label: 'Breathe in',
        duration: Duration(seconds: 4),
        action: BreathingAction.expand,
      ),
      BreathingPhase(
        label: 'Hold',
        duration: Duration(seconds: 7),
        action: BreathingAction.hold,
      ),
      BreathingPhase(
        label: 'Breathe out',
        duration: Duration(seconds: 8),
        action: BreathingAction.contract,
      ),
    ],
  );

  static const coherent = BreathingExercise(
    id: 'coherent',
    name: 'Coherent 5 · 5',
    tagline: 'Inhale 5, exhale 5',
    summary: 'Even rhythm — calms heart rate and brings you back to centre.',
    cycles: 6,
    recommendedFor: 'distract',
    phases: [
      BreathingPhase(
        label: 'Breathe in',
        duration: Duration(seconds: 5),
        action: BreathingAction.expand,
      ),
      BreathingPhase(
        label: 'Breathe out',
        duration: Duration(seconds: 5),
        action: BreathingAction.contract,
      ),
    ],
  );

  static const belly = BreathingExercise(
    id: 'belly',
    name: 'Belly breath',
    tagline: 'Inhale 4, exhale 6',
    summary: 'A gentle warm-up. Soft inhale, longer exhale.',
    cycles: 6,
    recommendedFor: 'freeze',
    phases: [
      BreathingPhase(
        label: 'Breathe in',
        duration: Duration(seconds: 4),
        action: BreathingAction.expand,
      ),
      BreathingPhase(
        label: 'Breathe out',
        duration: Duration(seconds: 6),
        action: BreathingAction.contract,
      ),
    ],
  );

  static const all = [box, fourSevenEight, coherent, belly];
}
