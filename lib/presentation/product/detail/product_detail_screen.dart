import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../domain/usecases/products/product_usecases.dart';
import '../../../../router/app_router.dart';
import 'widgets/product_color_selector.dart';
import 'widgets/product_detail_bottom_bar.dart';
import 'widgets/product_image_gallery.dart';
import 'widgets/product_specifications_table.dart';

/// ProductDetailScreen — Màn hình Chi tiết sản phẩm
class ProductDetailScreen extends ConsumerStatefulWidget {
  final String productId;

  const ProductDetailScreen({
    super.key,
    required this.productId,
  });

  @override
  ConsumerState<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _selectedColor;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asyncProduct = ref.watch(getProductByIdProvider(productId: widget.productId));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: asyncProduct.when(
        loading: () => const Scaffold(
          body: Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          ),
        ),
        error: (error, stack) => Scaffold(
          appBar: AppBar(leading: const BackButton()),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline_rounded, size: 60, color: AppColors.error),
                const SizedBox(height: AppSizes.md),
                Text('Lỗi tải sản phẩm: $error', textAlign: TextAlign.center),
                const SizedBox(height: AppSizes.md),
                ElevatedButton(
                  onPressed: () => ref.invalidate(getProductByIdProvider(productId: widget.productId)),
                  child: const Text('Thử lại'),
                ),
              ],
            ),
          ),
        ),
        data: (product) {
          if (product == null) {
            return Scaffold(
              appBar: AppBar(leading: const BackButton()),
              body: const Center(
                child: Text('Không tìm thấy sản phẩm này'),
              ),
            );
          }

          final selectedColor = _selectedColor ??
              (product.colors.isNotEmpty ? product.colors.first : null);

          return Stack(
            children: [
              CustomScrollView(
                slivers: [
                  // ── SliverAppBar ──────────────────────────────────────────
                  SliverAppBar(
                    pinned: true,
                    expandedHeight: 340,
                    backgroundColor: AppColors.surface,
                    elevation: 0,
                    leading: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.black.withValues(alpha: 0.3),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
                          onPressed: () => context.pop(),
                        ),
                      ),
                    ),
                    actions: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.black.withValues(alpha: 0.3),
                          child: IconButton(
                            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 18),
                            onPressed: () => context.push(AppRoutes.cart),
                          ),
                        ),
                      ),
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                      background: ProductImageGallery(product: product),
                    ),
                  ),

                  // ── Product Info & Section ────────────────────────────────
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Card Info Header
                        Container(
                          padding: const EdgeInsets.all(AppSizes.lg),
                          color: AppColors.surface,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Brand & Tag
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppSizes.sm,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primarySurface,
                                      borderRadius: BorderRadius.circular(AppSizes.radiusXS),
                                    ),
                                    child: Text(
                                      product.brand.toUpperCase(),
                                      style: AppTypography.labelSmall.copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    'Mã SP: ${product.id.substring(0, product.id.length > 8 ? 8 : product.id.length)}',
                                    style: AppTypography.labelSmall.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSizes.xs),

                              // Name
                              Text(
                                product.name,
                                style: AppTypography.headlineMedium.copyWith(
                                  fontWeight: FontWeight.w700,
                                  height: 1.25,
                                ),
                              ),
                              const SizedBox(height: AppSizes.sm),

                              // Rating & Sold Summary
                              Row(
                                children: [
                                  const Icon(Icons.star_rounded, size: 18, color: Color(0xFFFFB800)),
                                  const SizedBox(width: 4),
                                  Text(
                                    product.rating > 0 ? product.rating.toStringAsFixed(1) : 'Chưa có đánh giá',
                                    style: AppTypography.titleSmall.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  if (product.reviewCount > 0) ...[
                                    const SizedBox(width: 4),
                                    Text(
                                      '(${product.reviewCount} đánh giá)',
                                      style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                                    ),
                                  ],
                                  const SizedBox(width: AppSizes.md),
                                  Container(width: 1, height: 14, color: AppColors.border),
                                  const SizedBox(width: AppSizes.md),
                                  Text(
                                    'Đã bán ${product.sold}',
                                    style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSizes.md),

                              // Price Box
                              Container(
                                padding: const EdgeInsets.all(AppSizes.md),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8FAFC),
                                  borderRadius: BorderRadius.circular(AppSizes.radiusMD),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Text(
                                      CurrencyFormatter.format(product.displayPrice),
                                      style: AppTypography.headlineLarge.copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(width: AppSizes.md),
                                    if (product.hasDiscount) ...[
                                      Text(
                                        CurrencyFormatter.format(product.price),
                                        style: AppTypography.bodyMedium.copyWith(
                                          color: AppColors.textSecondary,
                                          decoration: TextDecoration.lineThrough,
                                        ),
                                      ),
                                      const SizedBox(width: AppSizes.sm),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: AppColors.errorSurface,
                                          borderRadius: BorderRadius.circular(AppSizes.radiusXS),
                                        ),
                                        child: Text(
                                          '-${product.discountPercent}%',
                                          style: AppTypography.labelSmall.copyWith(
                                            color: AppColors.error,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSizes.sm),

                        // Color Selector
                        if (product.colors.isNotEmpty) ...[
                          Container(
                            padding: const EdgeInsets.all(AppSizes.lg),
                            color: AppColors.surface,
                            child: ProductColorSelector(
                              colors: product.colors,
                              selectedColor: selectedColor,
                              onColorSelected: (color) {
                                setState(() => _selectedColor = color);
                              },
                            ),
                          ),
                          const SizedBox(height: AppSizes.sm),
                        ],

                        // Tab Header Section
                        Container(
                          color: AppColors.surface,
                          child: Column(
                            children: [
                              TabBar(
                                controller: _tabController,
                                labelColor: AppColors.primary,
                                unselectedLabelColor: AppColors.textSecondary,
                                indicatorColor: AppColors.primary,
                                indicatorWeight: 3,
                                labelStyle: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w700),
                                tabs: const [
                                  Tab(text: 'Mô tả'),
                                  Tab(text: 'Thông số'),
                                  Tab(text: 'Đánh giá'),
                                ],
                              ),
                              SizedBox(
                                height: 350,
                                child: TabBarView(
                                  controller: _tabController,
                                  children: [
                                    // Tab 1: Description
                                    SingleChildScrollView(
                                      padding: const EdgeInsets.all(AppSizes.lg),
                                      child: Text(
                                        product.description.isNotEmpty
                                            ? product.description
                                            : 'Thông tin sản phẩm đang được cập nhật thêm...',
                                        style: AppTypography.bodyLarge.copyWith(height: 1.6),
                                      ),
                                    ),

                                    // Tab 2: Specifications
                                    SingleChildScrollView(
                                      padding: const EdgeInsets.all(AppSizes.lg),
                                      child: ProductSpecificationsTable(specs: product.specs),
                                    ),

                                    // Tab 3: Reviews Summary Placeholder
                                    SingleChildScrollView(
                                      padding: const EdgeInsets.all(AppSizes.lg),
                                      child: Column(
                                        children: [
                                          const Icon(Icons.rate_review_outlined, size: 48, color: AppColors.primary),
                                          const SizedBox(height: AppSizes.sm),
                                          Text(
                                            'Đánh giá & Nhận xét',
                                            style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                                          ),
                                          const SizedBox(height: AppSizes.xs),
                                          Text(
                                            '${product.reviewCount} lượt đánh giá tích cực từ khách hàng đã mua.',
                                            style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Bottom Spacing for Sticky Bar
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ],
              ),

              // ── Sticky Bottom Bar ──────────────────────────────────────────
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: ProductDetailBottomBar(
                  product: product,
                  selectedColor: selectedColor,
                  onAddToCart: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('🛒 Đã thêm "${product.name}" (Màu: ${selectedColor ?? "Mặc định"}) vào giỏ hàng!'),
                        backgroundColor: Colors.green,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  onBuyNow: () {
                    context.push(AppRoutes.checkout);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
