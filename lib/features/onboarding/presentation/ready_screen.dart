import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../data/onboarding_storage.dart';
import '../theme/onb_text_styles.dart';
import '../widgets/onboarding_primary_button.dart';
import '../widgets/onboarding_scaffold.dart';

class ReadyScreen extends StatefulWidget {
  const ReadyScreen({super.key});

  @override
  State<ReadyScreen> createState() => _ReadyScreenState();
}

class _ReadyScreenState extends State<ReadyScreen> {
  bool _saving = false;

  static const _steps = [
    'Stress profile created',
    'Mentor tone set',
    'Task algorithm ready',
  ];

  Future<void> _finish() async {
    setState(() => _saving = true);
    await OnboardingStorage.save();
    if (!mounted) return;
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingScaffold(
      showBack: false,
      currentStep: 6,
      bottomAction: OnboardingPrimaryButton(
        label: 'Start my first release',
        loading: _saving,
        onPressed: _saving ? null : _finish,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.onbGradientStart, AppColors.onbGradientEnd],
              ),
              borderRadius: BorderRadius.circular(40),
            ),
            child: const Icon(
              Icons.psychology_alt_rounded,
              color: Colors.white,
              size: 96,
            ),
          )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .scale(
                begin: const Offset(1.0, 1.0),
                end: const Offset(1.05, 1.05),
                duration: 2.seconds,
                curve: Curves.easeInOut,
              ),
          const SizedBox(height: 32),
          Text("You're all set!",
              style: OnbTextStyles.h1Hero, textAlign: TextAlign.center),
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 280),
            child: Text(
              'Your AI mentor is calibrated. Ready to release your first thought?',
              style: OnbTextStyles.body,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 28),
          for (final s in _steps) ...[
            _CheckRow(text: s),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

class _CheckRow extends StatelessWidget {
  final String text;
  const _CheckRow({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(LucideIcons.check, size: 16, color: AppColors.releaseTeal),
        const SizedBox(width: 8),
        Text(text, style: OnbTextStyles.bodyPrimary),
      ],
    );
  }
}
