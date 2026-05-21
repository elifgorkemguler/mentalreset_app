import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/mock_data.dart';
import '../../core/router/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/repositories/supabase_thought_repository.dart'
    show NotAuthenticatedException;
import '../../data/service_locator.dart';
import '../../widgets/activity_tile.dart';
import '../../widgets/capture_action_button.dart';
import '../../widgets/mood_chip_card.dart';
import '../../widgets/section_header.dart';
import '../../widgets/soft_card.dart';
import '../auth/data/auth_service.dart';
import '../settings/settings_screen.dart';
import '../auth/data/user_session.dart';
import 'text_capture_modal.dart';
import 'voice_capture_modal.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _selectedMoodId;

  String _greeting() {
    final h = DateTime.now().hour;
    if (h >= 5 && h < 12) return 'Good morning';
    if (h >= 12 && h < 17) return 'Good afternoon';
    if (h >= 17 && h < 22) return 'Good evening';
    return 'Good night';
  }

  Future<void> _onMoodSelected(String moodId) async {
    setState(() => _selectedMoodId = moodId);

    final messenger = ScaffoldMessenger.of(context);
    try {
      await ServiceLocator.moods.addMoodCheckin(moodId);
      if (!mounted) return;
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text('Mood checked in.',
              style: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.textOnPrimary)),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
        ));
    } on NotAuthenticatedException catch (e) {
      if (!mounted) return;
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(e.toString())));
    } catch (e) {
      if (!mounted) return;
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('Could not save mood: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenPadding,
            AppSpacing.lg,
            AppSpacing.screenPadding,
            AppSpacing.xxl,
          ),
          children: [
            _GreetingHeader(
              greeting: '${_greeting()}, ${UserSession.instance.displayName}',
            ),
            const SizedBox(height: AppSpacing.xl),
            _MoodCheckInCard(
              moods: MockData.homeMoods,
              selectedId: _selectedMoodId,
              onSelect: _onMoodSelected,
            ),
            const SizedBox(height: AppSpacing.lg),
            const _ThoughtCaptureCard(),
            const SizedBox(height: AppSpacing.xl),
            const SectionHeader(title: 'Recent activity'),
            const SizedBox(height: AppSpacing.md),
            ...MockData.recentActivity.map((entry) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: ActivityTile(entry: entry),
                )),
          ],
        ),
      ),
    );
  }
}

void _showAccountSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xxl)),
    ),
    builder: (sheetCtx) {
      return SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl,
            AppSpacing.lg,
            AppSpacing.xl,
            AppSpacing.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
              Text('Your account', style: AppTextStyles.titleLarge),
              const SizedBox(height: 4),
              Text(
                UserSession.instance.email ?? 'Signed in locally',
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.lg),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.settings_outlined,
                    color: AppColors.textPrimary),
                title: Text('Settings', style: AppTextStyles.titleMedium),
                trailing: const Icon(Icons.chevron_right,
                    color: AppColors.textMuted, size: 20),
                onTap: () {
                  Navigator.of(sheetCtx).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const SettingsScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.logout_rounded,
                    color: AppColors.error),
                title: Text('Sign out',
                    style: AppTextStyles.titleMedium
                        .copyWith(color: AppColors.error)),
                onTap: () async {
                  Navigator.of(sheetCtx).pop();
                  await AuthService.instance.signOut();
                  if (!context.mounted) return;
                  context.go(AppRoutes.login);
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _GreetingHeader extends StatelessWidget {
  final String greeting;
  const _GreetingHeader({required this.greeting});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(greeting, style: AppTextStyles.headlineLarge),
              const SizedBox(height: 4),
              Text("Let's check in with yourself", style: AppTextStyles.bodyMedium),
            ],
          ),
        ),
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(AppRadius.md),
            onTap: () => _showAccountSheet(context),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.md),
                boxShadow: AppShadows.subtle,
              ),
              child: const Icon(Icons.notifications_none_rounded,
                  color: AppColors.textPrimary, size: 22),
            ),
          ),
        ),
      ],
    );
  }
}

class _MoodCheckInCard extends StatelessWidget {
  final List moods;
  final String? selectedId;
  final ValueChanged<String> onSelect;

  const _MoodCheckInCard({
    required this.moods,
    required this.selectedId,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      gradient: AppGradients.softBackground,
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('How are you feeling right now?', style: AppTextStyles.titleLarge),
          const SizedBox(height: 4),
          Text('Tap a mood to check in.', style: AppTextStyles.bodyMedium),
          const SizedBox(height: AppSpacing.base),
          SizedBox(
            height: 116,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: moods.length,
              separatorBuilder: (context, index) => const SizedBox(width: AppSpacing.md),
              itemBuilder: (_, i) {
                final m = moods[i];
                return MoodChipCard(
                  mood: m,
                  selected: selectedId == m.id,
                  onTap: () => onSelect(m.id),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ThoughtCaptureCard extends StatelessWidget {
  const _ThoughtCaptureCard();

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("What's on your mind?", style: AppTextStyles.titleLarge),
          const SizedBox(height: 4),
          Text('Turn mental noise into clarity and action',
              style: AppTextStyles.bodyMedium),
          const SizedBox(height: AppSpacing.base),
          Row(
            children: [
              CaptureActionButton(
                icon: Icons.mic_none_rounded,
                label: 'Speak',
                background: AppColors.accentLavender,
                iconColor: AppColors.primaryDeep,
                onTap: () => _openVoiceModal(context),
              ),
              const SizedBox(width: AppSpacing.md),
              CaptureActionButton(
                icon: Icons.edit_note_rounded,
                label: 'Write',
                background: AppColors.accentRose,
                iconColor: AppColors.secondaryDeep,
                onTap: () => TextCaptureModal.show(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _openVoiceModal(BuildContext context) {
    VoiceCaptureModal.show(context);
  }
}
