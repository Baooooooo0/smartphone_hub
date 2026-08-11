import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/product_entity.dart';
import '../../../widgets/primary_button.dart';

/// ProductDetailBottomBar — Sticky Bottom Bar chứa 2 nút hành động mua hàng
class ProductDetailBottomBar extends StatelessWidget {
  final ProductEntity product;
  final String? selectedColor;
  final VoidCallback onAddToCart;
  final VoidCallback onBuyNow;

  const ProductDetailBottomBar({
    super.key,
    required this.product,
    required this.selectedColor,
    required this.onAddToCart,
    required this.onBuyNow,
  });

  @override
  Widget build(BuildContext context) {
    final isOut = !product.inStock;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.lg,
        vertical: AppSizes.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: isOut
            ? Container(
                padding: const EdgeInsets.symmetric(vertical: AppSizes.md),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(AppSizes.radiusMD),
                ),
                child: Text(
                  'HẾT HÀNG TAP THỜI',
                  style: AppTypography.buttonLarge.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              )
            : Row(
                children: [
                  // Button 1: Thêm vào giỏ
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onAddToCart,
                      icon: const Icon(Icons.add_shopping_cart_rounded, size: 20),
                      label: Text(
                        'Thêm vào giỏ',
                        style: AppTypography.buttonMedium.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, AppSizes.buttonHeightMD),
                        side: const BorderSide(color: AppColors.primary, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSizes.radiusMD),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSizes.md),

                  // Button 2: Mua ngay
                  Expanded(
                    child: PrimaryButton(
                      label: 'Mua ngay',
                      onPressed: onBuyNow,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
