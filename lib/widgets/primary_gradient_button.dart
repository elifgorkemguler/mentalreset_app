import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_gradients.dart';
import '../core/theme/app_radius.dart' show AppRadius;
import '../core/theme/app_shadows.dart';
import '../core/theme/app_text_styles.dart';

class PrimaryGradientButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final bool fullWidth;
  final bool loading;

  const PrimaryGradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.leadingIcon,
    this.trailingIcon,
    this.fullWidth = true,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !loading;
    final button = Opacity(
      opacity: enabled ? 1 : 0.6,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          gradient: AppGradients.primary,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          boxShadow: enabled ? AppShadows.button : const [],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            onTap: enabled
                ? () {
                    HapticFeedback.selectionClick();
                    onPressed!();
                  }
                : null,
            child: Center(
              child: loading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        valueColor: AlwaysStoppedAnimation(AppColors.textOnPrimary),
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (leadingIcon != null) ...[
                          Icon(leadingIcon, color: AppColors.textOnPrimary, size: 20),
                          const SizedBox(width: 8),
                        ],
                        Text(label, style: AppTextStyles.buttonLarge),
                        if (trailingIcon != null) ...[
                          const SizedBox(width: 8),
                          Icon(trailingIcon, color: AppColors.textOnPrimary, size: 20),
                        ],
                      ],
                    ),
            ),
          ),
        ),
      ),
    );

    return fullWidth ? SizedBox(width: double.infinity, child: button) : button;
  }
}
