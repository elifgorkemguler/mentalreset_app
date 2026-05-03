import 'package:flutter/material.dart';

import '../../core/constants/mock_data.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/activity_tile.dart';
import '../../widgets/capture_action_button.dart';
import '../../widgets/mood_chip_card.dart';
import '../../widgets/section_header.dart';
import '../../widgets/soft_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _selectedMoodId;

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning';
    if (h < 18) return 'Good afternoon';
    return 'Good evening';
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
            _GreetingHeader(greeting: '${_greeting()}, ${MockData.userName}'),
            const SizedBox(height: AppSpacing.xl),
            _MoodCheckInCard(
              moods: MockData.homeMoods,
              selectedId: _selectedMoodId,
              onSelect: (id) => setState(() => _selectedMoodId = id),
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
        Container(
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
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _openVoiceModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _VoiceCapturePlaceholder(),
    );
  }
}

class _VoiceCapturePlaceholder extends StatelessWidget {
  const _VoiceCapturePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xxl)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Capture Your Thoughts', style: AppTextStyles.titleLarge),
            const SizedBox(height: AppSpacing.lg),
            Text('Voice modal coming in phase 2.',
                style: AppTextStyles.bodyMedium, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}
