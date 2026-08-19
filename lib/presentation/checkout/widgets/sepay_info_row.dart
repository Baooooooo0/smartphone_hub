import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_theme.dart';

class SepayInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final String? copyValue;
  final TextStyle? valueStyle;
  final bool isHighlighted;
  final String? tooltip;

  const SepayInfoRow({
    super.key,
    required this.label,
    required this.value,
    this.copyValue,
    this.valueStyle,
    this.isHighlighted = false,
    this.tooltip,
  });

  void _copyToClipboard(BuildContext context) {
    final textToCopy = copyValue ?? value;
    Clipboard.setData(ClipboardData(text: textToCopy));
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã sao chép $label: $textToCopy'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.sm + 2,
      ),
      margin: const EdgeInsets.only(bottom: AppSizes.sm),
      decoration: BoxDecoration(
        color: isHighlighted
            ? AppColors.primarySurface
            : AppColors.surfaceVariant.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppSizes.radiusMD),
        border: Border.all(
          color: isHighlighted
              ? AppColors.primaryLight.withValues(alpha: 0.5)
              : AppColors.border.withValues(alpha: 0.6),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTypography.labelSmall.copyWith(
                    color: isHighlighted
                        ? AppColors.primaryDark
                        : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: valueStyle ??
                      AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isHighlighted
                            ? AppColors.primaryDark
                            : AppColors.textPrimary,
                      ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _copyToClipboard(context),
            icon: Container(
              padding: const EdgeInsets.all(AppSizes.xs + 2),
              decoration: BoxDecoration(
                color: isHighlighted
                    ? AppColors.primary.withValues(alpha: 0.15)
                    : AppColors.surface,
                borderRadius: BorderRadius.circular(AppSizes.radiusSM),
                border: Border.all(
                  color: isHighlighted
                      ? AppColors.primary.withValues(alpha: 0.3)
                      : AppColors.border,
                ),
              ),
              child: Icon(
                Icons.copy_rounded,
                size: AppSizes.iconSM,
                color: isHighlighted ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
            tooltip: tooltip ?? 'Sao chép',
          ),
        ],
      ),
    );
  }
}
