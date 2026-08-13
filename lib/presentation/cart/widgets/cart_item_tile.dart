import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/helpers.dart';
import '../../../domain/entities/cart_item_entity.dart';

/// CartItemTile — Thẻ hiển thị 1 sản phẩm trong giỏ hàng với nút tăng/giảm số lượng
class CartItemTile extends StatelessWidget {
  final CartItemEntity item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  const CartItemTile({
    super.key,
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.md),
      padding: const EdgeInsets.all(AppSizes.sm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMD),
        boxShadow: AppColors.cardShadow,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Image ─────────────────────────────────────────────────
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.radiusSM),
            child: Container(
              width: 80,
              height: 80,
              color: const Color(0xFFF8FAFC),
              child: item.productImage.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: item.productImage,
                      fit: BoxFit.contain,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primary,
                        ),
                      ),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.phone_android_rounded,
                        color: AppColors.textSecondary,
                      ),
                    )
                  : const Icon(
                      Icons.phone_android_rounded,
                      color: AppColors.textSecondary,
                    ),
            ),
          ),
          const SizedBox(width: AppSizes.sm),

          // ── Info Content ──────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name & Delete button
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.productName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.titleSmall.copyWith(
                          fontWeight: FontWeight.w700,
                          height: 1.25,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: onRemove,
                      borderRadius: BorderRadius.circular(AppSizes.radiusSM),
                      child: const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.delete_outline_rounded,
                          color: AppColors.error,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),

                // Color Tag
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.xs,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(AppSizes.radiusXS),
                  ),
                  child: Text(
                    'Màu: ${item.color}',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 10,
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.xs),

                // Price & Quantity Buttons Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Price Display
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            CurrencyFormatter.format(item.price),
                            style: AppTypography.titleMedium.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (item.hasDiscount)
                            Text(
                              CurrencyFormatter.format(item.originalPrice),
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.textSecondary,
                                decoration: TextDecoration.lineThrough,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSizes.xs),

                    // Quantity Stepper (- 1 +)
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.border),
                        borderRadius: BorderRadius.circular(AppSizes.radiusSM),
                      ),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: onDecrement,
                            borderRadius: const BorderRadius.horizontal(
                              left: Radius.circular(AppSizes.radiusSM),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Icon(Icons.remove_rounded, size: 16),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: AppSizes.xs),
                            child: Text(
                              '${item.quantity}',
                              style: AppTypography.bodySmall.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: onIncrement,
                            borderRadius: const BorderRadius.horizontal(
                              right: Radius.circular(AppSizes.radiusSM),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Icon(Icons.add_rounded, size: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
