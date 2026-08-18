import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_theme.dart';

class ProfileMenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? iconBgColor;
  final bool isDestructive;
  final bool showDivider;

  const ProfileMenuTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.iconColor,
    this.iconBgColor,
    this.isDestructive = false,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveIconColor = isDestructive
        ? AppColors.error
        : (iconColor ?? AppColors.primary);
    final effectiveIconBgColor = isDestructive
        ? AppColors.errorSurface
        : (iconBgColor ?? AppColors.primarySurface);

    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppSizes.radiusMD),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.md,
                vertical: AppSizes.md,
              ),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: effectiveIconBgColor,
                      borderRadius: BorderRadius.circular(AppSizes.radiusSM + 2),
                    ),
                    child: Icon(
                      icon,
                      color: effectiveIconColor,
                      size: AppSizes.iconMD,
                    ),
                  ),
                  const SizedBox(width: AppSizes.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: AppTypography.titleSmall.copyWith(
                            color: isDestructive
                                ? AppColors.error
                                : AppColors.textPrimary,
                            fontWeight: isDestructive
                                ? FontWeight.w600
                                : FontWeight.w500,
                          ),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            subtitle!,
                            style: AppTypography.caption.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (trailing != null)
                    trailing!
                  else if (!isDestructive)
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.textTertiary,
                      size: AppSizes.iconMD,
                    ),
                ],
              ),
            ),
          ),
        ),
        if (showDivider)
          const Divider(
            height: 1,
            indent: 64,
            endIndent: AppSizes.md,
            color: AppColors.divider,
          ),
      ],
    );
  }
}
