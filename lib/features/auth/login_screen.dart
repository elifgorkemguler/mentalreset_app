import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/auth_text_field.dart';
import '../../widgets/primary_gradient_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppGradients.softBackground),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPadding,
              vertical: AppSpacing.xl,
            ),
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.xl),
                const AppLogo(size: 84, iconSize: 42),
                const SizedBox(height: AppSpacing.lg),
                ShaderMask(
                  shaderCallback: (b) => AppGradients.primary.createShader(b),
                  child: Text(
                    'Mental Reset',
                    style: AppTextStyles.displayMedium.copyWith(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Turn mental clutter into clarity',
                  style: AppTextStyles.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xxl),
                _TabSwitcher(
                  index: _tab,
                  onChange: (i) => setState(() => _tab = i),
                ),
                const SizedBox(height: AppSpacing.xl),
                if (_tab == 1) ...[
                  const AuthTextField(
                    label: 'Name',
                    hint: 'How should we call you?',
                    icon: Icons.person_outline_rounded,
                  ),
                  const SizedBox(height: AppSpacing.base),
                ],
                const AuthTextField(
                  label: 'Email',
                  hint: 'you@example.com',
                  icon: Icons.mail_outline_rounded,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: AppSpacing.base),
                const AuthTextField(
                  label: 'Password',
                  hint: 'At least 8 characters',
                  icon: Icons.lock_outline_rounded,
                  obscure: true,
                ),
                const SizedBox(height: AppSpacing.md),
                if (_tab == 0)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        'Forgot password?',
                        style: AppTextStyles.labelLarge.copyWith(color: AppColors.primary),
                      ),
                    ),
                  ),
                const SizedBox(height: AppSpacing.lg),
                PrimaryGradientButton(
                  label: _tab == 0 ? 'Login' : 'Create account',
                  trailingIcon: Icons.arrow_forward_rounded,
                  onPressed: () => context.go(AppRoutes.onboardingIntent),
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _tab == 0 ? "New here? " : "Already with us? ",
                      style: AppTextStyles.bodyMedium,
                    ),
                    GestureDetector(
                      onTap: () => setState(() => _tab = _tab == 0 ? 1 : 0),
                      child: Text(
                        _tab == 0 ? 'Sign up' : 'Login',
                        style: AppTextStyles.labelLarge.copyWith(color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TabSwitcher extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChange;

  const _TabSwitcher({required this.index, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        children: [
          _TabButton(label: 'Login', selected: index == 0, onTap: () => onChange(0)),
          _TabButton(label: 'Sign Up', selected: index == 1, onTap: () => onChange(1)),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TabButton({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: selected ? AppGradients.primary : null,
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
          child: Text(
            label,
            style: AppTextStyles.labelLarge.copyWith(
              color: selected ? AppColors.textOnPrimary : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
