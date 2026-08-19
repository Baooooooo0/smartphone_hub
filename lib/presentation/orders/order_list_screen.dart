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
/// Sử dụng TabBar + body switch thay vì TabBarView để tránh
/// lỗi RenderViewport paint null (Flutter known issue).
class OrderListScreen extends ConsumerStatefulWidget {
  const OrderListScreen({super.key});

  @override
  ConsumerState<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends ConsumerState<OrderListScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  static const List<Map<String, String>> _tabs = [
    {'title': 'Tất cả', 'key': 'all'},
    {'title': 'Chờ xác nhận', 'key': 'pending'},
    {'title': 'Đã xác nhận', 'key': 'confirmed'},
    {'title': 'Đang giao', 'key': 'shipping'},
    {'title': 'Đã giao', 'key': 'delivered'},
    {'title': 'Đã hủy', 'key': 'cancelled'},
  ];

  @override
  void initState() {
    super.initState();
    final initialIndex = ref.read(orderFilterIndexProvider);
    final safeIndex =
        (initialIndex >= 0 && initialIndex < _tabs.length) ? initialIndex : 0;

    _tabController = TabController(
      length: _tabs.length,
      vsync: this,
      initialIndex: safeIndex,
    );

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        ref
            .read(orderFilterIndexProvider.notifier)
            .setIndex(_tabController.index);
        setState(() {}); // rebuild body khi tab thay đổi
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showCancelDialog(BuildContext context, String orderId) {
    showDialog(
      context: context,
      builder: (context) => CancelOrderDialog(
        onConfirm: (reason) async {
          final success = await ref
              .read(orderActionProvider.notifier)
              .cancelOrder(orderId, reason: reason);

          if (context.mounted) {
            if (success) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('🎉 Đã hủy đơn hàng thành công!'),
                  backgroundColor: Colors.green,
                ),
              );
            } else {
              final err = ref.read(orderActionProvider).errorMessage;
              ScaffoldMessenger.of(context).showSnackBar(
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

  List<OrderEntity> _filterOrders(List<OrderEntity> orders, String filterKey) {
    if (filterKey == 'all') return orders;
    return orders.where((o) => o.status == filterKey).toList();
  }

  @override
  Widget build(BuildContext context) {
    final userOrdersAsync = ref.watch(userOrdersStreamProvider);
    final currentTab = _tabs[_tabController.index];

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
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          labelStyle: AppTypography.titleSmall.copyWith(
            fontWeight: FontWeight.w700,
          ),
          unselectedLabelStyle: AppTypography.titleSmall.copyWith(
            fontWeight: FontWeight.normal,
          ),
          tabs: _tabs.map((t) => Tab(text: t['title'])).toList(),
        ),
      ),
      // Body: switch nội dung trực tiếp thay vì TabBarView
      body: userOrdersAsync.when(
        loading: () => const _OrderListShimmer(),
        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.xxl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline,
                    size: 48, color: AppColors.error),
                const SizedBox(height: AppSizes.md),
                Text(
                  'Lỗi nạp danh sách đơn hàng',
                  style: AppTypography.titleMedium,
                ),
                const SizedBox(height: AppSizes.xs),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
                  child: Text(
                    error.toString(),
                    style: AppTypography.bodySmall
                        .copyWith(color: AppColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
        data: (orders) {
          final filteredOrders =
              _filterOrders(orders, currentTab['key']!);

          if (filteredOrders.isEmpty) {
            return _OrderEmptyView(filterTitle: currentTab['title']!);
          }

          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async {
              ref.invalidate(userOrdersStreamProvider);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(AppSizes.lg),
              child: Column(
                children: filteredOrders.map((order) {
                  return OrderCard(
                    key: ValueKey(order.id),
                    order: order,
                    onCancelOrder: () =>
                        _showCancelDialog(context, order.id),
                  );
                }).toList(),
              ),
            ),
          );
        },
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
