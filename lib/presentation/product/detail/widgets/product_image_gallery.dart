import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../domain/entities/product_entity.dart';

/// ProductImageGallery — Slider album ảnh sản phẩm với chỉ báo trang smooth
class ProductImageGallery extends StatefulWidget {
  final ProductEntity product;

  const ProductImageGallery({
    super.key,
    required this.product,
  });

  @override
  State<ProductImageGallery> createState() => _ProductImageGalleryState();
}

class _ProductImageGalleryState extends State<ProductImageGallery> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.product.images.isNotEmpty
        ? widget.product.images
        : [widget.product.mainImage];

    return SizedBox(
      height: 320,
      child: Stack(
        children: [
          // ── Image PageView ─────────────────────────────────────────
          PageView.builder(
            controller: _pageController,
            itemCount: images.length,
            itemBuilder: (context, index) {
              final imageUrl = images[index];
              return Container(
                color: const Color(0xFFF8FAFC),
                child: imageUrl.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.contain,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.primary,
                          ),
                        ),
                        errorWidget: (context, url, error) => const Icon(
                          Icons.phone_android_rounded,
                          size: 80,
                          color: AppColors.textSecondary,
                        ),
                      )
                    : const Icon(
                        Icons.phone_android_rounded,
                        size: 80,
                        color: AppColors.textSecondary,
                      ),
              );
            },
          ),

          // ── Badges (Top Left) ──────────────────────────────────────
          if (widget.product.hasDiscount)
            Positioned(
              top: AppSizes.md,
              left: AppSizes.md,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.sm,
                  vertical: AppSizes.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius: BorderRadius.circular(AppSizes.radiusSM),
                ),
                child: Text(
                  '-${widget.product.discountPercent}% OFF',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ),

          // ── Page Indicator (Bottom Center) ────────────────────────
          if (images.length > 1)
            Positioned(
              bottom: AppSizes.md,
              left: 0,
              right: 0,
              child: Center(
                child: SmoothPageIndicator(
                  controller: _pageController,
                  count: images.length,
                  effect: const ExpandingDotsEffect(
                    dotWidth: 8,
                    dotHeight: 8,
                    activeDotColor: AppColors.primary,
                    dotColor: AppColors.border,
                    expansionFactor: 3,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
