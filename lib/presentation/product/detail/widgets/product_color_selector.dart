import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_theme.dart';

/// ProductColorSelector — Component chọn màu sắc sản phẩm
class ProductColorSelector extends StatelessWidget {
  final List<String> colors;
  final String? selectedColor;
  final ValueChanged<String> onColorSelected;

  const ProductColorSelector({
    super.key,
    required this.colors,
    required this.selectedColor,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (colors.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Màu sắc: ',
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              selectedColor ?? colors.first,
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.xs),
        Wrap(
          spacing: AppSizes.sm,
          runSpacing: AppSizes.xs,
          children: colors.map((colorName) {
            final isSelected = (selectedColor ?? colors.first) == colorName;
            return ChoiceChip(
              label: Text(colorName),
              selected: isSelected,
              selectedColor: AppColors.primarySurface,
              backgroundColor: AppColors.surface,
              side: BorderSide(
                color: isSelected ? AppColors.primary : AppColors.border,
                width: isSelected ? 1.5 : 1,
              ),
              labelStyle: AppTypography.bodySmall.copyWith(
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
              ),
              onSelected: (selected) {
                if (selected) onColorSelected(colorName);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
