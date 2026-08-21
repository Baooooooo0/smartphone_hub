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

// ═══════════════════════════════════════════════════════════════════════════════
// ⚠️ QUAN TRỌNG — QUY TẮC RENDER AN TOÀN:
//
// 1. KHÔNG dùng: TabBar, TabBarView, ListView, GridView, RefreshIndicator
// 2. LUÔN dùng: SingleChildScrollView + Column
// 3. Widget tree bên trong Expanded KHÔNG ĐƯỢC thay đổi kiểu widget
//    (không dùng .when() trả về widget khác nhau → gây RenderTransform crash)
// 4. Chỉ thay đổi children bên trong Column, giữ nguyên cấu trúc bao ngoài
//
// Chi tiết: xem AGENT.md mục 15 "Known Bugs & Workarounds"
// ═══════════════════════════════════════════════════════════════════════════════

/// Các bộ lọc trạng thái đơn hàng
const _orderFilters = [
  ('Tất cả', 'all'),
  ('Chờ xác nhận', 'pending'),
  ('Đã xác nhận', 'confirmed'),
  ('Đang giao', 'shipping'),
  ('Đã giao', 'delivered'),
  ('Đã hủy', 'cancelled'),
];

/// Màn hình danh sách đơn hàng.
///
/// Widget tree LUÔN ổn định:
/// ```
/// Scaffold
///  └─ Column
///       ├─ _FilterChipsBar
///       ├─ Divider
///       └─ Expanded
///            └─ SingleChildScrollView   ← LUÔN có, KHÔNG BAO GIỜ swap
///                 └─ Column             ← children thay đổi, widget không đổi
/// ```
class OrderListScreen extends ConsumerWidget {
  const OrderListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      body: const Column(
        children: [
          _FilterChipsBar(),
          Divider(height: 1, color: AppColors.border),
          Expanded(child: _StableOrderContent()),
        ],
      ),
    );
  }
}

// ─── Filter Chips Bar ─────────────────────────────────────────────────────────
class _FilterChipsBar extends ConsumerWidget {
  const _FilterChipsBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(orderFilterIndexProvider);

    return Container(
      color: AppColors.surface,
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.md,
          vertical: AppSizes.sm,
        ),
        child: Row(
          children: [
            for (int i = 0; i < _orderFilters.length; i++)
              Padding(
                padding: const EdgeInsets.only(right: AppSizes.xs),
                child: ChoiceChip(
                  label: Text(_orderFilters[i].$1),
                  selected: i == selectedIndex,
                  onSelected: (_) {
                    ref.read(orderFilterIndexProvider.notifier).setIndex(i);
                  },
                  selectedColor: AppColors.primary,
                  backgroundColor: AppColors.background,
                  labelStyle: TextStyle(
                    color: i == selectedIndex
                        ? Colors.white
                        : AppColors.textSecondary,
                    fontWeight: i == selectedIndex
                        ? FontWeight.w700
                        : FontWeight.normal,
                    fontSize: 13,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                    side: BorderSide(
                      color: i == selectedIndex
                          ? AppColors.primary
                          : AppColors.border,
                    ),
                  ),
                  showCheckmark: false,
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.sm),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─── Stable Order Content ─────────────────────────────────────────────────────
/// Widget này LUÔN render cùng 1 SingleChildScrollView + Column.
/// Chỉ children bên trong Column thay đổi, widget bao ngoài KHÔNG ĐỔI.
/// Đây là cách duy nhất tránh RenderTransform hasSize crash.
class _StableOrderContent extends ConsumerWidget {
  const _StableOrderContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(userOrdersStreamProvider);
    final selectedIndex = ref.watch(orderFilterIndexProvider);
    final safeIdx = selectedIndex.clamp(0, _orderFilters.length - 1);
    final filterKey = _orderFilters[safeIdx].$2;
    final filterTitle = _orderFilters[safeIdx].$1;

    // Tạo danh sách children cho Column — KHÔNG swap widget type
    final List<Widget> children = _buildColumnChildren(
      ordersAsync: ordersAsync,
      filterKey: filterKey,
      filterTitle: filterTitle,
      context: context,
      ref: ref,
    );

    // ⚠️ Widget tree LUÔN là: SingleChildScrollView → Column
    // Chỉ Column.children thay đổi — widget bao ngoài giữ nguyên
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.lg),
      child: Column(
        children: children,
      ),
    );
  }

  List<Widget> _buildColumnChildren({
    required AsyncValue<List<OrderEntity>> ordersAsync,
    required String filterKey,
    required String filterTitle,
    required BuildContext context,
    required WidgetRef ref,
  }) {
    // ── Loading state ──
    if (ordersAsync.isLoading && !ordersAsync.hasValue) {
      return List.generate(
        4,
        (i) => Shimmer.fromColors(
          baseColor: AppColors.surfaceVariant,
          highlightColor: AppColors.surface,
          child: Container(
            height: 160,
            margin: const EdgeInsets.only(bottom: AppSizes.md),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(AppSizes.radiusLG),
            ),
          ),
        ),
      );
    }

    // ── Error state ──
    if (ordersAsync.hasError && !ordersAsync.hasValue) {
      return [
        const SizedBox(height: 100),
        const Icon(Icons.error_outline, size: 48, color: AppColors.error),
        const SizedBox(height: AppSizes.md),
        Text('Lỗi nạp danh sách đơn hàng',
            style: AppTypography.titleMedium),
        const SizedBox(height: AppSizes.xs),
        Text(
          ordersAsync.error.toString(),
          style: AppTypography.bodySmall
              .copyWith(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
      ];
    }

    // ── Data state ──
    final allOrders = ordersAsync.value ?? [];
    final orders = filterKey == 'all'
        ? allOrders
        : allOrders.where((o) => o.status == filterKey).toList();

    if (orders.isEmpty) {
      return [
        const SizedBox(height: 80),
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
          style:
              AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: AppSizes.xs),
        Text(
          'Bạn chưa có đơn hàng nào ở mục "$filterTitle".',
          style: AppTypography.bodyMedium
              .copyWith(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
      ];
    }

    // ── Danh sách đơn hàng ──
    return [
      for (final order in orders)
        _OrderCardWrapper(key: ValueKey(order.id), order: order),
    ];
  }
}

// ─── OrderCard Wrapper ────────────────────────────────────────────────────────
class _OrderCardWrapper extends ConsumerWidget {
  final OrderEntity order;
  const _OrderCardWrapper({super.key, required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OrderCard(
      order: order,
      onCancelOrder: () => _showCancelDialog(context, ref, order.id),
    );
  }

  void _showCancelDialog(BuildContext context, WidgetRef ref, String orderId) {
    showDialog(
      context: context,
      builder: (ctx) => CancelOrderDialog(
        onConfirm: (reason) async {
          final success = await ref
              .read(orderActionProvider.notifier)
              .cancelOrder(orderId, reason: reason);

          if (ctx.mounted) {
            ScaffoldMessenger.of(ctx).showSnackBar(
              SnackBar(
                content: Text(
                  success
                      ? '🎉 Đã hủy đơn hàng thành công!'
                      : ref.read(orderActionProvider).errorMessage ??
                          'Không thể hủy đơn hàng.',
                ),
                backgroundColor: success ? Colors.green : AppColors.error,
              ),
            );
          }
        },
      ),
    );
  }
}
