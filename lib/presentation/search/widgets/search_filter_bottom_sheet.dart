import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/product_filter.dart';
import '../../widgets/primary_button.dart';

/// SearchFilterBottomSheet — BottomSheet lọc chi tiết sản phẩm
class SearchFilterBottomSheet extends StatefulWidget {
  final ProductFilter currentFilter;
  final ValueChanged<ProductFilter> onApplyFilter;

  const SearchFilterBottomSheet({
    super.key,
    required this.currentFilter,
    required this.onApplyFilter,
  });

  @override
  State<SearchFilterBottomSheet> createState() => _SearchFilterBottomSheetState();
}

class _SearchFilterBottomSheetState extends State<SearchFilterBottomSheet> {
  String? _selectedBrand;
  double? _minPrice;
  double? _maxPrice;

  final List<String> _brands = [
    'Apple',
    'Samsung',
    'Xiaomi',
    'OPPO',
    'Vivo',
    'Realme',
    'Asus',
  ];

  @override
  void initState() {
    super.initState();
    _selectedBrand = widget.currentFilter.brand;
    _minPrice = widget.currentFilter.minPrice;
    _maxPrice = widget.currentFilter.maxPrice;
  }

  void _reset() {
    setState(() {
      _selectedBrand = null;
      _minPrice = null;
      _maxPrice = null;
    });
  }

  void _apply() {
    final filter = ProductFilter(
      brand: _selectedBrand,
      minPrice: _minPrice,
      maxPrice: _maxPrice,
      categoryId: widget.currentFilter.categoryId,
    );
    widget.onApplyFilter(filter);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Bộ lọc tìm kiếm',
                  style: AppTypography.headlineSmall.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextButton(
                  onPressed: _reset,
                  child: Text(
                    'Thiết lập lại',
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: AppSizes.sm),

            // ── Thương hiệu ──────────────────────────────────────────────
            Text(
              'Thương hiệu',
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSizes.xs),
            Wrap(
              spacing: AppSizes.xs,
              runSpacing: AppSizes.xs,
              children: _brands.map((brand) {
                final isSelected = _selectedBrand?.toLowerCase() == brand.toLowerCase();
                return ChoiceChip(
                  label: Text(brand),
                  selected: isSelected,
                  selectedColor: AppColors.primarySurface,
                  backgroundColor: AppColors.surface,
                  side: BorderSide(
                    color: isSelected ? AppColors.primary : AppColors.border,
                  ),
                  labelStyle: AppTypography.bodySmall.copyWith(
                    color: isSelected ? AppColors.primary : AppColors.textPrimary,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
                  ),
                  onSelected: (selected) {
                    setState(() {
                      _selectedBrand = selected ? brand : null;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: AppSizes.lg),

            // ── Khoảng giá ───────────────────────────────────────────────
            Text(
              'Khoảng giá',
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSizes.xs),
            Wrap(
              spacing: AppSizes.xs,
              runSpacing: AppSizes.xs,
              children: [
                _buildPriceChip('Dưới 5 triệu', null, 5000000),
                _buildPriceChip('5 - 10 triệu', 5000000, 10000000),
                _buildPriceChip('10 - 20 triệu', 10000000, 20000000),
                _buildPriceChip('Trên 20 triệu', 20000000, null),
              ],
            ),
            const SizedBox(height: AppSizes.xxl),

            // ── Apply Button ─────────────────────────────────────────────
            PrimaryButton(
              label: 'Áp dụng bộ lọc',
              onPressed: _apply,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceChip(String label, double? min, double? max) {
    final isSelected = _minPrice == min && _maxPrice == max;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: AppColors.primarySurface,
      backgroundColor: AppColors.surface,
      side: BorderSide(
        color: isSelected ? AppColors.primary : AppColors.border,
      ),
      labelStyle: AppTypography.bodySmall.copyWith(
        color: isSelected ? AppColors.primary : AppColors.textPrimary,
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
      ),
      onSelected: (selected) {
        setState(() {
          if (selected) {
            _minPrice = min;
            _maxPrice = max;
          } else {
            _minPrice = null;
            _maxPrice = null;
          }
        });
      },
    );
  }
}
