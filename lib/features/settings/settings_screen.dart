// MindFlow — Settings Screen
// Required for App Store: account deletion, privacy/terms links, crisis resources.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/services/account_service.dart';
import '../auth/data/auth_service.dart';
import 'widgets/crisis_resources_sheet.dart';
import 'widgets/medical_disclaimer_sheet.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  static const String version = '1.0.0';

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _busy = false;

  String get _userEmail {
    return AuthService.instance.currentUserEmail ?? 'Not signed in';
  }

  Future<void> _signOut() async {
    setState(() => _busy = true);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    try {
      await AuthService.instance.signOut();
      if (!mounted) return;
      navigator.popUntil((route) => route.isFirst);
    } catch (e) {
      if (!mounted) return;
      setState(() => _busy = false);
      messenger.showSnackBar(SnackBar(content: Text('Sign out failed: $e')));
    }
  }

  Future<void> _confirmDeleteAccount() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text('Delete account?', style: AppTextStyles.titleMedium),
        content: Text(
          'This will permanently delete your account, thoughts, mood check-ins, '
          'and all data. This action cannot be undone.',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text('Cancel',
                style: AppTextStyles.labelLarge
                    .copyWith(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text('Delete forever',
                style: AppTextStyles.labelLarge
                    .copyWith(color: AppColors.error)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    if (!mounted) return;

    HapticFeedback.heavyImpact();
    setState(() => _busy = true);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    try {
      await AccountService.instance.deleteCurrentUserAccount();
      if (!mounted) return;
      navigator.popUntil((route) => route.isFirst);
      messenger.showSnackBar(SnackBar(
        content: Text(
          'Your account has been deleted.',
          style: AppTextStyles.bodyMedium
              .copyWith(color: AppColors.textOnPrimary),
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ));
    } catch (e) {
      if (!mounted) return;
      setState(() => _busy = false);
      messenger.showSnackBar(SnackBar(
        content: Text('Could not delete account: $e'),
        backgroundColor: AppColors.error,
      ));
    }
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _showDisclaimer() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const MedicalDisclaimerSheet(),
    );
  }

  void _showCrisisResources() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const CrisisResourcesSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Settings', style: AppTextStyles.headlineMedium),
        centerTitle: false,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.sm,
            AppSpacing.lg,
            AppSpacing.xxl,
          ),
          children: [
            _SectionHeader('ACCOUNT'),
            _SettingsTile(
              icon: Icons.email_outlined,
              title: _userEmail,
              subtitle: 'Signed in',
            ),

            const SizedBox(height: AppSpacing.xl),
            _SectionHeader('ABOUT'),
            _SettingsTile(
              icon: Icons.info_outline,
              title: 'About MindFlow',
              subtitle: 'Turn mental clutter into clarity',
            ),
            _SettingsTile(
              icon: Icons.warning_amber_outlined,
              title: 'Important notice',
              subtitle: 'Not medical advice',
              onTap: _showDisclaimer,
              showChevron: true,
            ),
            _SettingsTile(
              icon: Icons.favorite_outline,
              title: 'Get help in crisis',
              subtitle: 'Resources for support',
              onTap: _showCrisisResources,
              showChevron: true,
              iconColor: AppColors.accentRoseDeep,
            ),
            _SettingsTile(
              icon: Icons.star_outline,
              title: 'Version',
              subtitle: SettingsScreen.version,
            ),

            const SizedBox(height: AppSpacing.xl),
            _SectionHeader('PRIVACY'),
            _SettingsTile(
              icon: Icons.lock_outline,
              title: 'Privacy Policy',
              onTap: () => _openUrl('https://mindflow.app/privacy'),
              showChevron: true,
            ),
            _SettingsTile(
              icon: Icons.description_outlined,
              title: 'Terms of Service',
              onTap: () => _openUrl('https://mindflow.app/terms'),
              showChevron: true,
            ),

            const SizedBox(height: AppSpacing.xl),
            _SectionHeader('ACTIONS'),
            _SettingsTile(
              icon: Icons.logout,
              title: 'Sign out',
              onTap: _busy ? null : _signOut,
              showChevron: true,
            ),
            const SizedBox(height: AppSpacing.sm),
            _SettingsTile(
              icon: Icons.delete_outline,
              title: 'Delete account',
              subtitle: 'Permanently remove all data',
              onTap: _busy ? null : _confirmDeleteAccount,
              showChevron: true,
              iconColor: AppColors.error,
              titleColor: AppColors.error,
            ),

            const SizedBox(height: AppSpacing.xxl),
            Center(
              child: Text(
                'Made with care · MindFlow ${SettingsScreen.version}',
                style: AppTextStyles.labelMedium
                    .copyWith(color: AppColors.textMuted),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.sm, AppSpacing.sm, AppSpacing.sm, AppSpacing.sm),
      child: Text(
        title,
        style: AppTextStyles.labelMedium.copyWith(
          color: AppColors.textMuted,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool showChevron;
  final Color? iconColor;
  final Color? titleColor;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.showChevron = false,
    this.iconColor,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.base, vertical: AppSpacing.base),
            child: Row(
              children: [
                Icon(icon,
                    color: iconColor ?? AppColors.textSecondary, size: 22),
                const SizedBox(width: AppSpacing.base),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: titleColor ?? AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle!,
                          style: AppTextStyles.labelMedium
                              .copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ],
                  ),
                ),
                if (showChevron)
                  Icon(Icons.chevron_right,
                      color: AppColors.textMuted, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}