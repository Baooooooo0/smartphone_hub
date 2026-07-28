import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_theme.dart';

/// SocialLoginButton — Nút đăng nhập bằng mạng xã hội (Google, Facebook...)
class SocialLoginButton extends StatelessWidget {
  final String label;
  final String logoAsset;
  final VoidCallback? onPressed;

  const SocialLoginButton({
    super.key,
    required this.label,
    required this.logoAsset,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, AppSizes.buttonHeightMD),
        side: const BorderSide(color: AppColors.border, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMD),
        ),
        backgroundColor: AppColors.surface,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            logoAsset,
            width: 22,
            height: 22,
            errorBuilder: (_, _, _) => const Icon(
              Icons.g_mobiledata,
              size: 24,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: AppSizes.md),
          Text(
            label,
            style: AppTypography.buttonMedium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
