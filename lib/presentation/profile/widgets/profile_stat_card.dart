import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_theme.dart';

class ProfileStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;
  final VoidCallback? onTap;

  const ProfileStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.iconColor = AppColors.primary,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSizes.radiusMD),
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: AppSizes.md,
              horizontal: AppSizes.sm,
            ),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSizes.radiusMD),
              border: Border.all(color: AppColors.border.withValues(alpha: 0.8)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSizes.xs + 2),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: AppSizes.iconSM, color: iconColor),
                ),
                const SizedBox(height: AppSizes.xs),
                Text(
                  value,
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  title,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
