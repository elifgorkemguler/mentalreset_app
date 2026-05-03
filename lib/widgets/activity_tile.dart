import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_radius.dart' show AppRadius;
import '../core/theme/app_shadows.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import '../models/activity_entry.dart';

class ActivityTile extends StatelessWidget {
  final ActivityEntry entry;

  const ActivityTile({super.key, required this.entry});

  String _formatRelative(DateTime t) {
    final diff = DateTime.now().difference(t);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.base),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: entry.accent,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(entry.icon, color: AppColors.textPrimary, size: 22),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.title, style: AppTextStyles.titleMedium),
                const SizedBox(height: 2),
                Text(entry.subtitle, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
          Text(_formatRelative(entry.timestamp), style: AppTextStyles.labelSmall),
        ],
      ),
    );
  }
}
