import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/product_entity.dart';

/// ProductCard — Widget hiển thị thông tin tóm tắt sản phẩm
/// Dùng chung cho Home (featured/best sellers), Search, Product List
class ProductCard extends StatelessWidget {
  final ProductEntity product;
  final double? width;

  const ProductCard({
    super.key,
    required this.product,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/products/${product.id}'),
      child: Container(
        width: width ?? AppSizes.productCardWidth,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.productCardRadius),
          boxShadow: AppColors.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Ảnh sản phẩm ─────────────────────────────────
            _ProductImage(product: product),
            // ── Thông tin sản phẩm ────────────────────────────
            Padding(
              padding: const EdgeInsets.all(AppSizes.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Brand
                  Text(
                    product.brand,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.primary,
                      letterSpacing: 0.3,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  // Tên sản phẩm
                  Text(
                    product.name,
                    style: AppTypography.titleSmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSizes.xs),
                  // Rating
                  _RatingRow(rating: product.rating, reviewCount: product.reviewCount),
                  const SizedBox(height: AppSizes.xs),
                  // Giá
                  _PriceRow(product: product),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Ảnh sản phẩm với discount badge ─────────────────────────────────────────
class _ProductImage extends StatelessWidget {
  final ProductEntity product;
  const _ProductImage({required this.product});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppSizes.productCardRadius),
          ),
          child: product.mainImage.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: product.mainImage,
                  width: double.infinity,
                  height: AppSizes.productCardImageHeight,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => _ImagePlaceholder(),
                  errorWidget: (context, url, error) => _ImagePlaceholder(),
                )
              : _ImagePlaceholder(),
        ),
        // Discount badge
        if (product.hasDiscount)
          Positioned(
            top: AppSizes.sm,
            left: AppSizes.sm,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.sm,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: AppColors.discountBadge,
                borderRadius: BorderRadius.circular(AppSizes.radiusSM),
              ),
              child: Text(
                '-${product.discountPercent}%',
                style: AppTypography.labelSmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: AppSizes.productCardImageHeight,
      color: AppColors.surfaceVariant,
      child: const Icon(
        Icons.phone_android_outlined,
        size: 40,
        color: AppColors.textTertiary,
      ),
    );
  }
}

// ─── Rating row ───────────────────────────────────────────────────────────────
class _RatingRow extends StatelessWidget {
  final double rating;
  final int reviewCount;
  const _RatingRow({required this.rating, required this.reviewCount});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.star_rounded, size: 13, color: AppColors.starColor),
        const SizedBox(width: 2),
        Text(
          rating.toStringAsFixed(1),
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        if (reviewCount > 0) ...[
          const SizedBox(width: 2),
          Text(
            '($reviewCount)',
            style: AppTypography.labelSmall,
          ),
        ],
      ],
    );
  }
}

// ─── Price row ────────────────────────────────────────────────────────────────
class _PriceRow extends StatelessWidget {
  final ProductEntity product;
  const _PriceRow({required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _formatPrice(product.displayPrice),
          style: AppTypography.priceMedium,
        ),
        if (product.hasDiscount)
          Text(
            _formatPrice(product.price),
            style: AppTypography.priceOriginal,
          ),
      ],
    );
  }

  String _formatPrice(double price) {
    // Format: 12.990.000₫
    final formatted = price.toInt().toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        );
    return '$formatted₫';
  }
}
