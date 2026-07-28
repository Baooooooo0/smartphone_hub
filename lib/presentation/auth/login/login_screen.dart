import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/helpers.dart';
import '../../../router/app_router.dart';
import '../auth_notifier.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/social_login_button.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/app_logo.dart';


class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(authProvider.notifier).signInWithEmail(
          email: _emailCtrl.text.trim(),
          password: _passwordCtrl.text,
        );
  }

  Future<void> _onGoogleLogin() async {
    await ref.read(authProvider.notifier).signInWithGoogle();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    // Lắng nghe kết quả đăng nhập
    ref.listen(authProvider, (previous, next) {
      if (next.isSuccess) {
        context.go(AppRoutes.home);
      } else if (next.isError && next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: AppColors.error,
          ),
        );
        ref.read(authProvider.notifier).clearError();
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.screenPaddingH + AppSizes.sm,
            vertical: AppSizes.xxl,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSizes.xxl),

                // ── Logo & Title ──────────────────────────────
                FadeInDown(
                  duration: const Duration(milliseconds: 500),
                  child: const AppLogo(),
                ),

                const SizedBox(height: AppSizes.xxxl),

                FadeInDown(
                  delay: const Duration(milliseconds: 100),
                  duration: const Duration(milliseconds: 500),
                  child: Text(
                    'Chào mừng trở lại! 👋',
                    style: AppTypography.displayMedium,
                  ),
                ),
                const SizedBox(height: AppSizes.xs),
                FadeInDown(
                  delay: const Duration(milliseconds: 200),
                  duration: const Duration(milliseconds: 500),
                  child: Text(
                    'Đăng nhập để tiếp tục mua sắm',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),

                const SizedBox(height: AppSizes.xxxl),

                // ── Form Fields ───────────────────────────────
                FadeInLeft(
                  delay: const Duration(milliseconds: 250),
                  duration: const Duration(milliseconds: 500),
                  child: AuthTextField(
                    controller: _emailCtrl,
                    label: AppStrings.email,
                    hint: 'example@gmail.com',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email_outlined,
                    validator: Validators.email,
                  ),
                ),

                const SizedBox(height: AppSizes.lg),

                FadeInLeft(
                  delay: const Duration(milliseconds: 300),
                  duration: const Duration(milliseconds: 500),
                  child: AuthTextField(
                    controller: _passwordCtrl,
                    label: AppStrings.password,
                    hint: '••••••••',
                    obscureText: _obscurePassword,
                    prefixIcon: Icons.lock_outlined,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppColors.textSecondary,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    validator: Validators.password,
                  ),
                ),

                // ── Forgot Password ───────────────────────────
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => context.push(AppRoutes.forgotPassword),
                    child: Text(
                      AppStrings.forgotPassword,
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: AppSizes.md),

                // ── Login Button ──────────────────────────────
                FadeInUp(
                  delay: const Duration(milliseconds: 350),
                  duration: const Duration(milliseconds: 500),
                  child: PrimaryButton(
                    label: AppStrings.login,
                    isLoading: authState.isLoading,
                    onPressed: authState.isLoading ? null : _onLogin,
                  ),
                ),

                const SizedBox(height: AppSizes.xxl),

                // ── Divider ───────────────────────────────────
                FadeIn(
                  delay: const Duration(milliseconds: 400),
                  child: Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.md),
                        child: Text(
                          'hoặc',
                          style: AppTypography.labelMedium,
                        ),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                ),

                const SizedBox(height: AppSizes.xxl),

                // ── Google Login ──────────────────────────────
                FadeInUp(
                  delay: const Duration(milliseconds: 450),
                  duration: const Duration(milliseconds: 500),
                  child: SocialLoginButton(
                    label: AppStrings.loginWithGoogle,
                    logoAsset: 'assets/icons/google_logo.png',
                    onPressed: authState.isLoading ? null : _onGoogleLogin,
                  ),
                ),

                const SizedBox(height: AppSizes.huge),

                // ── Register Link ─────────────────────────────
                FadeIn(
                  delay: const Duration(milliseconds: 500),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppStrings.noAccount,
                        style: AppTypography.bodyMedium,
                      ),
                      TextButton(
                        onPressed: () => context.push(AppRoutes.register),
                        child: Text(
                          AppStrings.register,
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
