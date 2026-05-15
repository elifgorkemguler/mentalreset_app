import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_radius.dart' show AppRadius;
import '../core/theme/app_text_styles.dart';

class AuthTextField extends StatefulWidget {
  final String label;
  final String hint;
  final IconData icon;
  final bool obscure;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final Iterable<String>? autofillHints;
  final bool? autocorrect;
  final bool? enableSuggestions;

  const AuthTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    this.obscure = false,
    this.keyboardType = TextInputType.text,
    this.controller,
    this.autofillHints,
    this.autocorrect,
    this.enableSuggestions,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  late bool _hidden = widget.obscure;

  @override
  void didUpdateWidget(AuthTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If this State object is reused for a different field (e.g. Flutter
    // reconciling the Login/Sign-Up forms), re-sync the obscure flag so a
    // visible field never inherits a password field's hidden state.
    if (oldWidget.obscure != widget.obscure) {
      _hidden = widget.obscure;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: AppTextStyles.labelLarge),
        const SizedBox(height: 8),
        TextField(
          controller: widget.controller,
          obscureText: _hidden,
          keyboardType: widget.keyboardType,
          autocorrect: widget.autocorrect ?? !widget.obscure,
          enableSuggestions: widget.enableSuggestions ?? !widget.obscure,
          autofillHints: widget.autofillHints,
          style: AppTextStyles.bodyLarge,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted),
            prefixIcon: Icon(widget.icon, color: AppColors.textSecondary, size: 20),
            suffixIcon: widget.obscure
                ? IconButton(
                    icon: Icon(
                      _hidden ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                    onPressed: () => setState(() => _hidden = !_hidden),
                  )
                : null,
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
