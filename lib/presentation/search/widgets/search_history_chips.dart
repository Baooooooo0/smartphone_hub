import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_theme.dart';

/// SearchHistoryChips — Hiển thị danh sách các từ khóa vừa tìm gần đây
class SearchHistoryChips extends StatelessWidget {
  final List<String> historyItems;
  final ValueChanged<String> onSelectQuery;
  final ValueChanged<String> onRemoveQuery;
  final VoidCallback onClearAll;

  const SearchHistoryChips({
    super.key,
    required this.historyItems,
    required this.onSelectQuery,
    required this.onRemoveQuery,
    required this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    if (historyItems.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.history_rounded, size: 18, color: AppColors.textSecondary),
                const SizedBox(width: AppSizes.xs),
                Text(
                  'Lịch sử tìm kiếm',
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: onClearAll,
              child: Text(
                'Xóa tất cả',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.error,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.xs),
        Wrap(
          spacing: AppSizes.xs,
          runSpacing: AppSizes.xs,
          children: historyItems.map((item) {
            return InputChip(
              label: Text(
                item,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              backgroundColor: AppColors.surface,
              side: const BorderSide(color: AppColors.border),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusSM),
              ),
              deleteIcon: const Icon(Icons.close_rounded, size: 14, color: AppColors.textSecondary),
              onDeleted: () => onRemoveQuery(item),
              onPressed: () => onSelectQuery(item),
            );
          }).toList(),
        ),
      ],
    );
  }
}
