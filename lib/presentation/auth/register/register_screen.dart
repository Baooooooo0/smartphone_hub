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
import '../../widgets/primary_button.dart';
import '../../widgets/app_logo.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _onRegister() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(authProvider.notifier).register(
          email: _emailCtrl.text.trim(),
          password: _passwordCtrl.text,
          displayName: _nameCtrl.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.screenPaddingH + AppSizes.sm,
            vertical: AppSizes.lg,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FadeInDown(
                  duration: const Duration(milliseconds: 400),
                  child: const AppLogo(iconSize: 52),
                ),

                const SizedBox(height: AppSizes.xxl),

                FadeInDown(
                  delay: const Duration(milliseconds: 100),
                  child: Text('Tạo tài khoản mới', style: AppTypography.displayMedium),
                ),
                const SizedBox(height: AppSizes.xs),
                FadeInDown(
                  delay: const Duration(milliseconds: 150),
                  child: Text(
                    'Điền thông tin để bắt đầu mua sắm',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),

                const SizedBox(height: AppSizes.xxl),

                // ── Display Name ────────────────────────
                FadeInLeft(
                  delay: const Duration(milliseconds: 200),
                  child: AuthTextField(
                    controller: _nameCtrl,
                    label: AppStrings.displayName,
                    hint: 'Nguyễn Văn A',
                    prefixIcon: Icons.person_outline,
                    textInputAction: TextInputAction.next,
                    validator: (v) => Validators.required(v, fieldName: 'Tên hiển thị'),
                  ),
                ),

                const SizedBox(height: AppSizes.lg),

                // ── Email ───────────────────────────────
                FadeInLeft(
                  delay: const Duration(milliseconds: 250),
                  child: AuthTextField(
                    controller: _emailCtrl,
                    label: AppStrings.email,
                    hint: 'example@gmail.com',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email_outlined,
                    textInputAction: TextInputAction.next,
                    validator: Validators.email,
                  ),
                ),

                const SizedBox(height: AppSizes.lg),

                // ── Password ────────────────────────────
                FadeInLeft(
                  delay: const Duration(milliseconds: 300),
                  child: AuthTextField(
                    controller: _passwordCtrl,
                    label: AppStrings.password,
                    hint: '••••••••',
                    obscureText: _obscurePassword,
                    prefixIcon: Icons.lock_outlined,
                    textInputAction: TextInputAction.next,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                        color: AppColors.textSecondary,
                      ),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    validator: Validators.password,
                  ),
                ),

                const SizedBox(height: AppSizes.lg),

                // ── Confirm Password ────────────────────
                FadeInLeft(
                  delay: const Duration(milliseconds: 350),
                  child: AuthTextField(
                    controller: _confirmCtrl,
                    label: AppStrings.confirmPassword,
                    hint: '••••••••',
                    obscureText: _obscureConfirm,
                    prefixIcon: Icons.lock_outlined,
                    textInputAction: TextInputAction.done,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirm ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                        color: AppColors.textSecondary,
                      ),
                      onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                    ),
                    validator: (v) => Validators.confirmPassword(v, _passwordCtrl.text),
                  ),
                ),

                const SizedBox(height: AppSizes.xxl),

                // ── Register Button ─────────────────────
                FadeInUp(
                  delay: const Duration(milliseconds: 400),
                  child: PrimaryButton(
                    label: AppStrings.register,
                    isLoading: authState.isLoading,
                    onPressed: authState.isLoading ? null : _onRegister,
                  ),
                ),

                const SizedBox(height: AppSizes.xl),

                // ── Login Link ──────────────────────────
                FadeIn(
                  delay: const Duration(milliseconds: 450),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(AppStrings.haveAccount, style: AppTypography.bodyMedium),
                      TextButton(
                        onPressed: () => context.pop(),
                        child: Text(
                          AppStrings.login,
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
