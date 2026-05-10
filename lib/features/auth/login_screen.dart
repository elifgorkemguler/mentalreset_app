import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show AuthException;

import '../../core/router/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/auth_text_field.dart';
import '../../widgets/primary_gradient_button.dart';
import 'data/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  int _tab = 0;
  bool _busy = false;
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _onSubmit() async {
    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text;
    final name = _nameCtrl.text.trim();

    if (email.isEmpty) {
      _showError('Enter your email.');
      return;
    }
    if (password.length < 6) {
      _showError('Password must be at least 6 characters.');
      return;
    }
    if (_tab == 1 && name.isEmpty) {
      _showError('Tell us what to call you.');
      return;
    }

    setState(() => _busy = true);
    try {
      if (_tab == 1) {
        final result = await AuthService.instance
            .signUp(email: email, password: password, name: name);
        if (!mounted) return;
        if (result.needsEmailConfirmation) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Check $email to confirm, then sign in.'),
          ));
          setState(() {
            _tab = 0;
            _passwordCtrl.clear();
          });
        } else {
          context.go(AppRoutes.onboardingWelcome);
        }
      } else {
        await AuthService.instance.signIn(email: email, password: password);
        if (!mounted) return;
        context.go(AppRoutes.home);
      }
    } on AuthException catch (e) {
      if (!mounted) return;
      _showError(e.message);
    } catch (e) {
      if (!mounted) return;
      _showError('Something went wrong: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

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
            child: AutofillGroup(
              child: Column(
                children: [
                  const SizedBox(height: AppSpacing.xl),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const AppLogo(size: 64, iconSize: 32),
                      const SizedBox(width: AppSpacing.md),
                      Text(
                        'MindFlow',
                        style: AppTextStyles.displayMedium.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
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
                    AuthTextField(
                      label: 'Name',
                      hint: 'How should we call you?',
                      icon: Icons.person_outline_rounded,
                      controller: _nameCtrl,
                      autofillHints: const [AutofillHints.givenName, AutofillHints.name],
                    ),
                    const SizedBox(height: AppSpacing.base),
                  ],
                  AuthTextField(
                    label: 'Email',
                    hint: 'you@example.com',
                    icon: Icons.mail_outline_rounded,
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailCtrl,
                    autocorrect: false,
                    enableSuggestions: false,
                    autofillHints: const [AutofillHints.email],
                  ),
                  const SizedBox(height: AppSpacing.base),
                  AuthTextField(
                    label: 'Password',
                    hint: 'At least 8 characters',
                    icon: Icons.lock_outline_rounded,
                    obscure: true,
                    controller: _passwordCtrl,
                    autofillHints: _tab == 1
                        ? const [AutofillHints.newPassword]
                        : const [AutofillHints.password],
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
                    loading: _busy,
                    onPressed: _busy ? null : _onSubmit,
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
