import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/product_filter.dart';
import '../../../router/app_router.dart';
import '../product/widgets/product_card.dart';
import '../product/widgets/product_empty_state.dart';
import '../product/widgets/product_grid_shimmer.dart';
import 'providers/search_provider.dart';
import 'widgets/search_filter_bottom_sheet.dart';
import 'widgets/search_history_chips.dart';

/// SearchScreen — Màn hình tìm kiếm sản phẩm realtime với Debounce 300ms & bộ lọc
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openFilterBottomSheet(ProductFilter currentFilter) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.radiusXL)),
      ),
      builder: (context) {
        return SearchFilterBottomSheet(
          currentFilter: currentFilter,
          onApplyFilter: (newFilter) {
            ref.read(searchProvider.notifier).applyFilter(newFilter);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchProvider);
    final historyItems = ref.watch(searchHistoryProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
        title: TextField(
          controller: _searchController,
          autofocus: true,
          style: AppTypography.bodyLarge,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: 'Tìm kiếm iPhone, Samsung, Xiaomi...',
            hintStyle: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            contentPadding: EdgeInsets.zero,
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear_rounded, color: AppColors.textSecondary),
                    onPressed: () {
                      _searchController.clear();
                      ref.read(searchProvider.notifier).onQueryChanged('');
                      setState(() {});
                    },
                  )
                : null,
          ),
          onChanged: (text) {
            setState(() {});
            ref.read(searchProvider.notifier).onQueryChanged(text);
          },
        ),
      ),
      body: Column(
        children: [
          // ── Search State View ─────────────────────────────────────────
          if (searchState.query.isEmpty) ...[
            // Lịch sử & gợi ý
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSizes.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SearchHistoryChips(
                      historyItems: historyItems,
                      onSelectQuery: (selectedQuery) {
                        _searchController.text = selectedQuery;
                        ref.read(searchProvider.notifier).onQueryChanged(selectedQuery);
                        setState(() {});
                      },
                      onRemoveQuery: (query) {
                        ref.read(searchHistoryProvider.notifier).removeQuery(query);
                      },
                      onClearAll: () {
                        ref.read(searchHistoryProvider.notifier).clearHistory();
                      },
                    ),
                    const SizedBox(height: AppSizes.xl),

                    // Popular Brands / Suggestions
                    Text(
                      'Thương hiệu phổ biến',
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSizes.sm),
                    Wrap(
                      spacing: AppSizes.xs,
                      runSpacing: AppSizes.xs,
                      children: ['iPhone', 'Samsung Galaxy', 'Xiaomi Redmi', 'OPPO Reno'].map((brand) {
                        return ActionChip(
                          label: Text(brand),
                          backgroundColor: AppColors.surface,
                          side: const BorderSide(color: AppColors.border),
                          onPressed: () {
                            _searchController.text = brand;
                            ref.read(searchProvider.notifier).onQueryChanged(brand);
                            setState(() {});
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ] else ...[
            // Result Header Bar (Count & Filter button)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.md,
                vertical: AppSizes.xs,
              ),
              color: AppColors.surface,
              child: Row(
                children: [
                  Text(
                    'Kết quả: ${searchState.results.length} sản phẩm',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.filter_list_rounded, color: AppColors.primary),
                    onPressed: () => _openFilterBottomSheet(searchState.filter),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Search Results Grid / Shimmer / Empty State
            Expanded(
              child: searchState.isLoading
                  ? const ProductGridShimmer(itemCount: 6)
                  : searchState.results.isEmpty
                      ? const ProductEmptyState(
                          title: 'Không tìm thấy kết quả',
                          message: 'Thử tìm kiếm với từ khóa khác hoặc điều chỉnh bộ lọc.',
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.all(AppSizes.md),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.65,
                            crossAxisSpacing: AppSizes.md,
                            mainAxisSpacing: AppSizes.md,
                          ),
                          itemCount: searchState.results.length,
                          itemBuilder: (context, index) {
                            final product = searchState.results[index];
                            return ProductCard(
                              product: product,
                              onTap: () {
                                context.push(
                                  '${AppRoutes.productList}/${product.id}',
                                );
                              },
                            );
                          },
                        ),
            ),
          ],
        ],
      ),
    );
  }
}
