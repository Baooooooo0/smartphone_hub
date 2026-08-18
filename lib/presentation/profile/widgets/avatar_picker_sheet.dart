import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_theme.dart';

class AvatarPickerSheet extends StatelessWidget {
  final ValueChanged<ImageSource> onSourceSelected;

  const AvatarPickerSheet({
    super.key,
    required this.onSourceSelected,
  });

  static Future<ImageSource?> show(BuildContext context) {
    return showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => AvatarPickerSheet(
        onSourceSelected: (source) => Navigator.pop(context, source),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.lg,
        vertical: AppSizes.xl,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusXXL),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(AppSizes.radiusFull),
              ),
            ),
            const SizedBox(height: AppSizes.lg),
            Text(
              'Cập nhật ảnh đại diện',
              style: AppTypography.headlineSmall.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSizes.xs),
            Text(
              'Chọn nguồn ảnh của bạn',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSizes.xl),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildOption(
                  context,
                  icon: Icons.photo_camera_rounded,
                  label: 'Máy ảnh',
                  color: AppColors.primary,
                  onTap: () => onSourceSelected(ImageSource.camera),
                ),
                _buildOption(
                  context,
                  icon: Icons.photo_library_rounded,
                  label: 'Thư viện ảnh',
                  color: const Color(0xFF7B61FF),
                  onTap: () => onSourceSelected(ImageSource.gallery),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusLG),
      child: Container(
        width: 130,
        padding: const EdgeInsets.symmetric(
          vertical: AppSizes.lg,
          horizontal: AppSizes.md,
        ),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppSizes.radiusLG),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSizes.md),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: AppSizes.iconLG),
            ),
            const SizedBox(height: AppSizes.sm),
            Text(
              label,
              style: AppTypography.labelLarge.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
