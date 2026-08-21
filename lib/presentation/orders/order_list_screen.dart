import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/order_entity.dart';
import 'providers/order_providers.dart';
import 'widgets/cancel_order_dialog.dart';
import 'widgets/order_card.dart';

/// OrderListScreen — Màn hình danh sách đơn hàng
/// Dùng ChoiceChip filter thay vì TabBar/TabBarView để tránh hoàn toàn
/// các lỗi layout reentrancy và RenderSliverList paint null của Flutter framework.
class OrderListScreen extends ConsumerWidget {
  const OrderListScreen({super.key});

  static const List<Map<String, String>> _filters = [
    {'title': 'Tất cả', 'key': 'all'},
    {'title': 'Chờ xác nhận', 'key': 'pending'},
    {'title': 'Đã xác nhận', 'key': 'confirmed'},
    {'title': 'Đang giao', 'key': 'shipping'},
    {'title': 'Đã giao', 'key': 'delivered'},
    {'title': 'Đã hủy', 'key': 'cancelled'},
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(orderFilterIndexProvider);
    final safeIndex = selectedIndex.clamp(0, _filters.length - 1);
    final currentFilter = _filters[safeIndex];
    final userOrdersAsync = ref.watch(userOrdersStreamProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
        title: Text(
          'Đơn hàng của tôi',
          style: AppTypography.headlineSmall.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Column(
        children: [
          // ─── Filter Chips ────────────────────────────────────────────
          Container(
            color: AppColors.surface,
            width: double.infinity,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.md,
                vertical: AppSizes.sm,
              ),
              child: Row(
                children: List.generate(_filters.length, (index) {
                  final filter = _filters[index];
                  final isSelected = index == safeIndex;
                  return Padding(
                    padding: const EdgeInsets.only(right: AppSizes.xs),
                    child: ChoiceChip(
                      label: Text(filter['title']!),
                      selected: isSelected,
                      onSelected: (_) {
                        ref
                            .read(orderFilterIndexProvider.notifier)
                            .setIndex(index);
                      },
                      selectedColor: AppColors.primary,
                      backgroundColor: AppColors.background,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textSecondary,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.normal,
                        fontSize: 13,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppSizes.radiusFull),
                        side: BorderSide(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.border,
                        ),
                      ),
                      showCheckmark: false,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.sm,
                        vertical: 0,
                      ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    ),
                  );
                }),
              ),
            ),
          ),

          // ─── Divider ────────────────────────────────────────────────
          const Divider(height: 1, color: AppColors.border),

          // ─── Content ────────────────────────────────────────────────
          Expanded(
            child: userOrdersAsync.when(
              loading: () => const _OrderListShimmer(),
              error: (error, stack) => _OrderErrorView(error: error),
              data: (orders) {
                final filterKey = currentFilter['key']!;
                final filteredOrders = filterKey == 'all'
                    ? orders
                    : orders.where((o) => o.status == filterKey).toList();

                if (filteredOrders.isEmpty) {
                  return _OrderEmptyView(
                      filterTitle: currentFilter['title']!);
                }

                return _OrderListContent(
                  orders: filteredOrders,
                  onRefresh: () async {
                    ref.invalidate(userOrdersStreamProvider);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Danh sách đơn hàng
class _OrderListContent extends ConsumerWidget {
  final List<OrderEntity> orders;
  final Future<void> Function() onRefresh;

  const _OrderListContent({
    required this.orders,
    required this.onRefresh,
  });

  void _showCancelDialog(BuildContext context, WidgetRef ref, String orderId) {
    showDialog(
      context: context,
      builder: (ctx) => CancelOrderDialog(
        onConfirm: (reason) async {
          final success = await ref
              .read(orderActionProvider.notifier)
              .cancelOrder(orderId, reason: reason);

          if (ctx.mounted) {
            if (success) {
              ScaffoldMessenger.of(ctx).showSnackBar(
                const SnackBar(
                  content: Text('🎉 Đã hủy đơn hàng thành công!'),
                  backgroundColor: Colors.green,
                ),
              );
            } else {
              final err = ref.read(orderActionProvider).errorMessage;
              ScaffoldMessenger.of(ctx).showSnackBar(
                SnackBar(
                  content: Text(err ?? 'Không thể hủy đơn hàng.'),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: onRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          children: orders.map((order) {
            return OrderCard(
              key: ValueKey(order.id),
              order: order,
              onCancelOrder: () =>
                  _showCancelDialog(context, ref, order.id),
            );
          }).toList(),
        ),
      ),
    );
  }
}

// ─── Error View ───────────────────────────────────────────────────────────────
class _OrderErrorView extends StatelessWidget {
  final Object error;
  const _OrderErrorView({required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: AppSizes.md),
            Text(
              'Lỗi nạp danh sách đơn hàng',
              style: AppTypography.titleMedium,
            ),
            const SizedBox(height: AppSizes.xs),
            Text(
              error.toString(),
              style: AppTypography.bodySmall
                  .copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Empty View ───────────────────────────────────────────────────────────────
class _OrderEmptyView extends StatelessWidget {
  final String filterTitle;
  const _OrderEmptyView({required this.filterTitle});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSizes.lg),
              decoration: const BoxDecoration(
                color: AppColors.primarySurface,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.receipt_long_outlined,
                size: 56,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppSizes.lg),
            Text(
              'Chưa có đơn hàng nào',
              style: AppTypography.titleLarge.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSizes.xs),
            Text(
              'Bạn chưa có đơn hàng nào ở mục "$filterTitle".',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Shimmer Loading ──────────────────────────────────────────────────────────
class _OrderListShimmer extends StatelessWidget {
  const _OrderListShimmer();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.lg),
      child: Column(
        children: List.generate(4, (index) {
          return Shimmer.fromColors(
            baseColor: AppColors.surfaceVariant,
            highlightColor: AppColors.surface,
            child: Container(
              height: 180,
              margin: const EdgeInsets.only(bottom: AppSizes.md),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(AppSizes.radiusLG),
              ),
            ),
          );
        }),
      ),
    );
  }
}
