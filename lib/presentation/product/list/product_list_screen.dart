import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/product_filter.dart';
import '../../../domain/usecases/products/product_usecases.dart';
import '../../../router/app_router.dart';
import '../widgets/product_card.dart';
import '../widgets/product_empty_state.dart';
import '../widgets/product_grid_shimmer.dart';

/// ProductListScreen — Màn hình danh sách sản phẩm dạng Grid 2 cột + Infinite Scroll
class ProductListScreen extends ConsumerStatefulWidget {
  final String? categoryId;
  final String? title;

  const ProductListScreen({
    super.key,
    this.categoryId,
    this.title,
  });

  @override
  ConsumerState<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends ConsumerState<ProductListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    // Tải dữ liệu ban đầu
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final initialFilter = ProductFilter(categoryId: widget.categoryId);
      ref.read(productListProvider.notifier).load(filter: initialFilter);
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(productListProvider.notifier).loadMore();
    }
  }

  void _showSortBottomSheet() {
    final currentSort = ref.read(productListProvider).sort;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.radiusXL)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSizes.md),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.lg,
                    vertical: AppSizes.xs,
                  ),
                  child: Text(
                    'Sắp xếp theo',
                    style: AppTypography.headlineSmall.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Divider(),
                _buildSortOption('Mới nhất', ProductSort.newest, currentSort),
                _buildSortOption('Giá: Thấp đến Cao', ProductSort.priceAsc, currentSort),
                _buildSortOption('Giá: Cao đến Thấp', ProductSort.priceDesc, currentSort),
                _buildSortOption('Bán chạy nhất', ProductSort.bestSelling, currentSort),
                _buildSortOption('Đánh giá cao nhất', ProductSort.rating, currentSort),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSortOption(String label, ProductSort sort, ProductSort currentSort) {
    final isSelected = sort == currentSort;
    return ListTile(
      title: Text(
        label,
        style: AppTypography.bodyLarge.copyWith(
          color: isSelected ? AppColors.primary : AppColors.textPrimary,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check_rounded, color: AppColors.primary)
          : null,
      onTap: () {
        ref.read(productListProvider.notifier).applySort(sort);
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
        title: Text(
          widget.title ?? 'Danh sách sản phẩm',
          style: AppTypography.headlineSmall.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () => context.push(AppRoutes.search),
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () => context.push(AppRoutes.cart),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Filter & Sort Bar ──────────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.md,
              vertical: AppSizes.sm,
            ),
            color: AppColors.surface,
            child: Row(
              children: [
                // Sort Button
                InkWell(
                  onTap: _showSortBottomSheet,
                  borderRadius: BorderRadius.circular(AppSizes.radiusSM),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.md,
                      vertical: AppSizes.xs,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(AppSizes.radiusSM),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.sort_rounded, size: 18, color: AppColors.primary),
                        const SizedBox(width: AppSizes.xs),
                        Text(
                          'Sắp xếp',
                          style: AppTypography.labelLarge.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),

                // Counter
                Text(
                  '${state.products.length} sản phẩm',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // ── Main List / Grid Content ──────────────────────────────────
          Expanded(
            child: RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () async {
                await ref
                    .read(productListProvider.notifier)
                    .load(filter: state.filter, sort: state.sort);
              },
              child: state.isLoading
                  ? const ProductGridShimmer(itemCount: 8)
                  : state.products.isEmpty
                      ? ProductEmptyState(
                          buttonText: 'Làm mới',
                          onButtonPressed: () {
                            ref
                                .read(productListProvider.notifier)
                                .load(filter: state.filter, sort: state.sort);
                          },
                        )
                      : CustomScrollView(
                          controller: _scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          slivers: [
                            SliverPadding(
                              padding: const EdgeInsets.all(AppSizes.md),
                              sliver: SliverGrid(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.65,
                                  crossAxisSpacing: AppSizes.md,
                                  mainAxisSpacing: AppSizes.md,
                                ),
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    final product = state.products[index];
                                    return ProductCard(
                                      product: product,
                                      onTap: () {
                                        context.push(
                                          '${AppRoutes.productList}/${product.id}',
                                        );
                                      },
                                    );
                                  },
                                  childCount: state.products.length,
                                ),
                              ),
                            ),

                            // Loading indicator at bottom when loading more
                            if (state.isLoadingMore)
                              const SliverToBoxAdapter(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: AppSizes.md),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ),

                            const SliverToBoxAdapter(
                              child: SizedBox(height: AppSizes.xl),
                            ),
                          ],
                        ),
            ),
          ),
        ],
      ),
    );
  }
}
