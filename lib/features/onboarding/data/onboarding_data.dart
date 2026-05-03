import 'dart:convert';

/// In-memory singleton holding the user's answers across the 7 onboarding
/// screens. Survives back-navigation. JSON-serializable so [OnboardingStorage]
/// can persist it to shared_preferences today and upsert to Supabase later
/// without a model rewrite.
class OnboardingData {
  OnboardingData._();
  static final OnboardingData instance = OnboardingData._();

  // Screen 2 — Age + Role
  String? ageRange; // '16-18' | '19-22' | '23-26' | '27-30' | '30+'
  String? roleKey;  // 'student' | 'working' | 'both' | 'transition'

  // Screen 3 — Stress sources (max 3)
  final List<String> stressSources = [];

  // Screen 4 — Stress response
  String? stressResponse; // 'freeze' | 'overthink' | 'procrastinate' | 'distract'

  // Screen 5 — AI tone
  String? aiTone; // 'direct' | 'warm' | 'coach' | 'reflective'

  // Screen 6 — Top 2 ranked goals + weekly frequency
  final List<String> rankedGoals = []; // length 0..2, order = rank
  int weeklyFrequency = 3;             // 1..7

  void reset() {
    ageRange = null;
    roleKey = null;
    stressSources.clear();
    stressResponse = null;
    aiTone = null;
    rankedGoals.clear();
    weeklyFrequency = 3;
  }

  Map<String, dynamic> toJson() => {
        'ageRange': ageRange,
        'roleKey': roleKey,
        'stressSources': stressSources,
        'stressResponse': stressResponse,
        'aiTone': aiTone,
        'rankedGoals': rankedGoals,
        'weeklyFrequency': weeklyFrequency,
      };

  void applyJson(Map<String, dynamic> json) {
    ageRange = json['ageRange'] as String?;
    roleKey = json['roleKey'] as String?;
    stressSources
      ..clear()
      ..addAll(((json['stressSources'] as List?) ?? const [])
          .map((e) => e as String));
    stressResponse = json['stressResponse'] as String?;
    aiTone = json['aiTone'] as String?;
    rankedGoals
      ..clear()
      ..addAll(((json['rankedGoals'] as List?) ?? const [])
          .map((e) => e as String));
    weeklyFrequency = (json['weeklyFrequency'] as int?) ?? 3;
  }

  String encode() => jsonEncode(toJson());
  void decode(String raw) => applyJson(jsonDecode(raw) as Map<String, dynamic>);
}
