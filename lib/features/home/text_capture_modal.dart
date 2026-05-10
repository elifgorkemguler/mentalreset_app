import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/repositories/supabase_thought_repository.dart';
import '../../data/service_locator.dart';
import '../../data/thought_feed.dart';
import '../../widgets/primary_gradient_button.dart';

class TextCaptureModal extends StatefulWidget {
  const TextCaptureModal({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.35),
      builder: (_) => const TextCaptureModal(),
    );
  }

  @override
  State<TextCaptureModal> createState() => _TextCaptureModalState();
}

class _TextCaptureModalState extends State<TextCaptureModal> {
  final _ctrl = TextEditingController();
  final _focus = FocusNode();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _ctrl.addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focus.requestFocus();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _focus.dispose();
    super.dispose();
  }

  bool get _canSave =>
      _ctrl.text.trim().isNotEmpty && !_saving;

  Future<void> _save() async {
    final text = _ctrl.text.trim();
    if (text.isEmpty) return;
    setState(() => _saving = true);

    // Capture before any async gap — the modal context becomes invalid
    // once we Navigator.pop, but the parent messenger keeps working.
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    try {
      await ServiceLocator.thoughts.addThought(content: text);
      ThoughtFeed.notifyChanged();
      navigator.pop();
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text('Thought saved to Release.',
              style: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.textOnPrimary)),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
        ));
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

  @override
  Widget build(BuildContext context) {
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
              Text('Write your thought', style: AppTextStyles.headlineMedium),
              const SizedBox(height: 6),
              Text(
                'Anything weighing on you. We will sort it out together.',
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.lg),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceMuted,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(color: AppColors.border, width: 1),
                ),
                padding: const EdgeInsets.all(AppSpacing.base),
                child: TextField(
                  controller: _ctrl,
                  focusNode: _focus,
                  maxLines: 6,
                  minLines: 4,
                  style: AppTextStyles.bodyLarge,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isCollapsed: true,
                    hintText: 'Start typing...',
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
                      label: 'Save',
                      loading: _saving,
                      onPressed: _canSave ? _save : null,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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
