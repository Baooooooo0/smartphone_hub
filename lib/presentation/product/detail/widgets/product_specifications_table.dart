import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_theme.dart';

/// ProductSpecificationsTable — Bảng hiển thị thông số kỹ thuật chi tiết
class ProductSpecificationsTable extends StatelessWidget {
  final Map<String, String> specs;

  const ProductSpecificationsTable({
    super.key,
    required this.specs,
  });

  String _getSpecLabel(String key) {
    switch (key.toLowerCase()) {
      case 'screen':
        return 'Màn hình';
      case 'cpu':
      case 'chipset':
        return 'Vi xử lý (CPU)';
      case 'ram':
        return 'RAM';
      case 'storage':
      case 'rom':
        return 'Bộ nhớ trong';
      case 'camera':
      case 'main_camera':
        return 'Camera sau';
      case 'selfie_camera':
        return 'Camera trước';
      case 'battery':
        return 'Dung lượng pin';
      case 'os':
        return 'Hệ điều hành';
      default:
        return key.toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (specs.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.lg),
        child: Text(
          'Đang cập nhật thông số kỹ thuật...',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    final entries = specs.entries.toList();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMD),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: List.generate(entries.length, (index) {
          final entry = entries[index];
          final isEven = index % 2 == 0;
          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.md,
              vertical: AppSizes.sm + 2,
            ),
            decoration: BoxDecoration(
              color: isEven ? const Color(0xFFF8FAFC) : AppColors.surface,
              borderRadius: BorderRadius.vertical(
                top: index == 0
                    ? const Radius.circular(AppSizes.radiusMD)
                    : Radius.zero,
                bottom: index == entries.length - 1
                    ? const Radius.circular(AppSizes.radiusMD)
                    : Radius.zero,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    _getSpecLabel(entry.key),
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Text(
                    entry.value,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
