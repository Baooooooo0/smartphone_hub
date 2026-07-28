import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/helpers.dart';
import '../auth_notifier.dart';
import '../widgets/auth_text_field.dart';
import '../../widgets/primary_button.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  bool _emailSent = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSend() async {
    if (!_formKey.currentState!.validate()) return;
    await ref
        .read(authProvider.notifier)
        .sendPasswordReset(_emailCtrl.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    ref.listen(authProvider, (previous, next) {
      if (next.isSuccess && !_emailSent) {
        setState(() => _emailSent = true);
        ref.read(authProvider.notifier).clearError();
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
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.screenPaddingH + AppSizes.sm,
            vertical: AppSizes.xl,
          ),
          child: _emailSent ? _buildSuccessView() : _buildFormView(authState),
        ),
      ),
    );
  }

  Widget _buildFormView(AuthState authState) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FadeInDown(
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(AppSizes.radiusXL),
              ),
              child: const Icon(Icons.lock_reset_rounded,
                  color: AppColors.primary, size: 36),
            ),
          ),
          const SizedBox(height: AppSizes.xxl),
          FadeInDown(
            delay: const Duration(milliseconds: 100),
            child: Text('Quên mật khẩu?', style: AppTypography.displayMedium),
          ),
          const SizedBox(height: AppSizes.sm),
          FadeInDown(
            delay: const Duration(milliseconds: 150),
            child: Text(
              'Nhập email của bạn. Chúng tôi sẽ gửi link đặt lại mật khẩu.',
              style: AppTypography.bodyMedium
                  .copyWith(color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(height: AppSizes.xxxl),
          FadeInLeft(
            delay: const Duration(milliseconds: 200),
            child: AuthTextField(
              controller: _emailCtrl,
              label: 'Email',
              hint: 'example@gmail.com',
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icons.email_outlined,
              validator: Validators.email,
            ),
          ),
          const SizedBox(height: AppSizes.xxl),
          FadeInUp(
            delay: const Duration(milliseconds: 250),
            child: PrimaryButton(
              label: 'Gửi link đặt lại',
              isLoading: authState.isLoading,
              onPressed: authState.isLoading ? null : _onSend,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessView() {
    return BounceInDown(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.successSurface,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.mark_email_read_outlined,
                color: AppColors.success, size: 50),
          ),
          const SizedBox(height: AppSizes.xxl),
          Text('Email đã gửi!', style: AppTypography.headlineLarge),
          const SizedBox(height: AppSizes.md),
          Text(
            'Kiểm tra hộp thư ${_emailCtrl.text} và làm theo hướng dẫn.',
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium
                .copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSizes.xxxl),
          PrimaryButton(
            label: 'Quay lại đăng nhập',
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
