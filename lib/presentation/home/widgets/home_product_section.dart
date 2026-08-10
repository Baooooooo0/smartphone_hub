import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/product_entity.dart';
import '../../product/widgets/product_card.dart';

/// HomeProductSection — Section sản phẩm dạng cuộn ngang (Featured / Best Sellers)
class HomeProductSection extends ConsumerWidget {
  final String title;
  final String? seeAllRoute;
  final AsyncValue<List<ProductEntity>> asyncProducts;

  const HomeProductSection({
    super.key,
    required this.title,
    required this.asyncProducts,
    this.seeAllRoute,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return asyncProducts.when(
      loading: () => _ProductSectionShimmer(title: title),
      error: (error, stack) => _ProductSectionError(title: title),
      data: (products) {
        if (products.isEmpty) return _ProductSectionEmpty(title: title);
        return _ProductSectionContent(
          title: title,
          products: products,
          seeAllRoute: seeAllRoute,
        );
      },
    );
  }
}

// ─── Content ─────────────────────────────────────────────────────────────────
class _ProductSectionContent extends StatelessWidget {
  final String title;
  final List<ProductEntity> products;
  final String? seeAllRoute;

  const _ProductSectionContent({
    required this.title,
    required this.products,
    this.seeAllRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header: title + "Xem tất cả"
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: AppTypography.headlineSmall),
              if (seeAllRoute != null)
                TextButton(
                  onPressed: () {
                    // TODO: navigate to seeAllRoute
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Xem tất cả',
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSizes.md),
        // Horizontal list
        SizedBox(
          height: 280,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
            itemCount: products.length,
            separatorBuilder: (context, index) => const SizedBox(width: AppSizes.md),
            itemBuilder: (context, index) => ProductCard(
              product: products[index],
              width: AppSizes.productCardWidth,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Shimmer ─────────────────────────────────────────────────────────────────
class _ProductSectionShimmer extends StatelessWidget {
  final String title;
  const _ProductSectionShimmer({required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
          child: Shimmer.fromColors(
            baseColor: AppColors.surfaceVariant,
            highlightColor: AppColors.surface,
            child: Container(
              width: 140,
              height: 18,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(AppSizes.radiusSM),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSizes.md),
        SizedBox(
          height: 280,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
            itemCount: 4,
            separatorBuilder: (context, index) => const SizedBox(width: AppSizes.md),
            itemBuilder: (context, index) => Shimmer.fromColors(
              baseColor: AppColors.surfaceVariant,
              highlightColor: AppColors.surface,
              child: Container(
                width: AppSizes.productCardWidth,
                height: 280,
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius:
                      BorderRadius.circular(AppSizes.productCardRadius),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Error ────────────────────────────────────────────────────────────────────
class _ProductSectionError extends StatelessWidget {
  final String title;
  const _ProductSectionError({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.headlineSmall),
          const SizedBox(height: AppSizes.sm),
          Container(
            padding: const EdgeInsets.all(AppSizes.lg),
            decoration: BoxDecoration(
              color: AppColors.errorSurface,
              borderRadius: BorderRadius.circular(AppSizes.radiusMD),
            ),
            child: Row(
              children: [
                const Icon(Icons.error_outline,
                    color: AppColors.error, size: 20),
                const SizedBox(width: AppSizes.sm),
                Text(
                  'Không thể tải dữ liệu',
                  style: AppTypography.bodySmall
                      .copyWith(color: AppColors.error),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Empty ────────────────────────────────────────────────────────────────────
class _ProductSectionEmpty extends StatelessWidget {
  final String title;
  const _ProductSectionEmpty({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.headlineSmall),
          const SizedBox(height: AppSizes.sm),
          Text(
            'Chưa có sản phẩm',
            style: AppTypography.bodySmall,
          ),
        ],
      ),
    );
  }
}
