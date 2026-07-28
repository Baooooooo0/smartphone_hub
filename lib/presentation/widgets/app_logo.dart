import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/app_theme.dart';

/// AppLogo — Logo SmartphoneHub dùng chung (Splash, Login, Register)
class AppLogo extends StatelessWidget {
  final double iconSize;
  final bool showTagline;

  const AppLogo({
    super.key,
    this.iconSize = 64,
    this.showTagline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: iconSize,
          height: iconSize,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(iconSize * 0.25),
            boxShadow: AppColors.primaryShadow,
          ),
          child: Icon(
            Icons.phone_android_rounded,
            color: Colors.white,
            size: iconSize * 0.55,
          ),
        ),
        const SizedBox(height: AppSizes.md),
        Text(
          'SmartphoneHub',
          style: AppTypography.headlineLarge.copyWith(
            color: AppColors.primary,
            letterSpacing: -0.5,
          ),
        ),
        if (showTagline) ...[
          const SizedBox(height: AppSizes.xs),
          Text(
            'Điện thoại chính hãng, giá tốt nhất',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}
