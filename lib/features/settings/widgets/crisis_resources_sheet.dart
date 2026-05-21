// MindFlow — Crisis Resources Sheet
// US crisis hotlines + international fallback.
// Required for mental wellness apps on the US App Store.

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class CrisisResourcesSheet extends StatelessWidget {
  const CrisisResourcesSheet({super.key});

  Future<void> _call(String number) async {
    final uri = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _sms(String number, String body) async {
    final uri = Uri(scheme: 'sms', path: number, queryParameters: {'body': body});
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Icon(Icons.favorite,
                      color: AppColors.accentRoseDeep, size: 28),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      'You are not alone',
                      style: AppTextStyles.headlineMedium,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'If you are in crisis or need someone to talk to, please reach out. '
                'Help is available 24/7.',
                style: AppTextStyles.bodyMedium.copyWith(height: 1.5),
              ),
              const SizedBox(height: AppSpacing.xl),

              // 988 — primary US crisis lifeline
              _ResourceCard(
                title: '988 Suicide & Crisis Lifeline',
                subtitle: 'Call or text 988 — free, confidential, 24/7',
                primaryLabel: 'Call 988',
                primaryAction: () => _call('988'),
                secondaryLabel: 'Text 988',
                secondaryAction: () => _sms('988', 'HOME'),
                color: AppColors.accentRoseDeep,
              ),
              const SizedBox(height: AppSpacing.md),

              // Crisis Text Line
              _ResourceCard(
                title: 'Crisis Text Line',
                subtitle: 'Text HOME to 741741 for free 24/7 support',
                primaryLabel: 'Text HOME to 741741',
                primaryAction: () => _sms('741741', 'HOME'),
                color: AppColors.accentLavenderDeep,
              ),
              const SizedBox(height: AppSpacing.md),

              // SAMHSA Helpline
              _ResourceCard(
                title: 'SAMHSA National Helpline',
                subtitle: 'Treatment referral and information · 1-800-662-4357',
                primaryLabel: 'Call SAMHSA',
                primaryAction: () => _call('1-800-662-4357'),
                color: AppColors.accentSkyDeep,
              ),
              const SizedBox(height: AppSpacing.md),

              // International
              _ResourceCard(
                title: 'International support',
                subtitle: 'Find a crisis line in your country',
                primaryLabel: 'Open findahelpline.com',
                primaryAction: () => _openUrl('https://findahelpline.com'),
                color: AppColors.accentMintDeep,
              ),

              const SizedBox(height: AppSpacing.xl),
              Container(
                padding: const EdgeInsets.all(AppSpacing.base),
                decoration: BoxDecoration(
                  color: AppColors.intensityHighBg,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.local_hospital_outlined,
                        color: AppColors.error, size: 22),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'If you are in immediate danger, please call your local emergency number (911 in the US).',
                        style: AppTextStyles.labelMedium
                            .copyWith(color: AppColors.textPrimary, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xl),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppColors.surfaceMuted,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                  ),
                  child: Text(
                    'Close',
                    style: AppTextStyles.labelLarge
                        .copyWith(color: AppColors.textPrimary),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResourceCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String primaryLabel;
  final VoidCallback primaryAction;
  final String? secondaryLabel;
  final VoidCallback? secondaryAction;
  final Color color;

  const _ResourceCard({
    required this.title,
    required this.subtitle,
    required this.primaryLabel,
    required this.primaryAction,
    this.secondaryLabel,
    this.secondaryAction,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.base),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: AppTextStyles.titleMedium
                  .copyWith(color: AppColors.textPrimary)),
          const SizedBox(height: 4),
          Text(subtitle,
              style: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.textSecondary, height: 1.4)),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: primaryAction,
                  style: TextButton.styleFrom(
                    backgroundColor: color,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                  ),
                  child: Text(
                    primaryLabel,
                    style: AppTextStyles.labelLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              if (secondaryLabel != null && secondaryAction != null) ...[
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: TextButton(
                    onPressed: secondaryAction,
                    style: TextButton.styleFrom(
                      backgroundColor: color.withValues(alpha: 0.15),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                    ),
                    child: Text(
                      secondaryLabel!,
                      style: AppTextStyles.labelLarge.copyWith(
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}