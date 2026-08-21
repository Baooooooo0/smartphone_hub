import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/helpers.dart';
import '../../../domain/entities/order_entity.dart';

/// OrderCard — Widget hiển thị thông tin vắn tắt đơn hàng trong danh sách
/// Được chia nhỏ thành 3 phần: Header, Item Preview, và Footer.
class OrderCard extends StatelessWidget {
  final OrderEntity order;
  final VoidCallback? onCancelOrder;

  const OrderCard({
    super.key,
    required this.order,
    this.onCancelOrder,
  });

  Color get _statusColor {
    switch (order.status) {
      case 'pending':
        return AppColors.statusPending;
      case 'confirmed':
        return AppColors.statusConfirmed;
      case 'shipping':
        return AppColors.statusShipping;
      case 'delivered':
        return AppColors.statusDelivered;
      case 'cancelled':
        return AppColors.statusCancelled;
      default:
        return AppColors.textSecondary;
    }
  }

  String get _statusText {
    switch (order.status) {
      case 'pending':
        return 'Chờ xác nhận';
      case 'confirmed':
        return 'Đã xác nhận';
      case 'shipping':
        return 'Đang giao hàng';
      case 'delivered':
        return 'Giao thành công';
      case 'cancelled':
        return 'Đã hủy';
      default:
        return order.status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final firstItem = order.items.firstOrNull;
    final extraItemsCount = order.items.length - 1;

    final formattedDate = order.createdAt != null
        ? DateFormat('dd/MM/yyyy HH:mm').format(order.createdAt!)
        : '';

    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.md),
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusLG),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Header ─────────────────────────────────────────────────────
          _OrderCardHeader(
            orderId: order.id,
            formattedDate: formattedDate,
            statusColor: _statusColor,
            statusText: _statusText,
          ),

          const Divider(
            height: AppSizes.lg,
            color: AppColors.border,
          ),

          // ─── Body: Sản phẩm xem trước ────────────────────────────────────
          if (firstItem != null) ...[
            _OrderCardPreviewItem(
              orderId: order.id,
              item: firstItem,
              extraItemsCount: extraItemsCount,
            ),
            const Divider(
              height: AppSizes.lg,
              color: AppColors.border,
            ),
          ],

          // ─── Footer ──────────────────────────────────────────────────────
          _OrderCardFooter(
            order: order,
            onCancelOrder: onCancelOrder,
          ),
        ],
      ),
    );
  }
}

// ─── Sub-widget 1: Header ───────────────────────────────────────────────────

class _OrderCardHeader extends StatelessWidget {
  final String orderId;
  final String formattedDate;
  final Color statusColor;
  final String statusText;

  const _OrderCardHeader({
    required this.orderId,
    required this.formattedDate,
    required this.statusColor,
    required this.statusText,
  });

  @override
  Widget build(BuildContext context) {
    final displayId = orderId.length > 8
        ? orderId.substring(0, 8).toUpperCase()
        : orderId;

    return Row(
      children: [
        Text(
          '#$displayId',
          style: AppTypography.titleSmall.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),

        if (formattedDate.isNotEmpty) ...[
          const SizedBox(width: AppSizes.xs),
          Text(
            formattedDate,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
        ],

        const Spacer(),

        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.xs + 2,
            vertical: 3,
          ),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppSizes.radiusXS),
          ),
          child: Text(
            statusText,
            style: AppTypography.labelSmall.copyWith(
              color: statusColor,
              fontWeight: FontWeight.w700,
              fontSize: 11,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Sub-widget 2: Item Preview ─────────────────────────────────────────────

class _OrderCardPreviewItem extends StatelessWidget {
  final String orderId;
  final OrderItemEntity item;
  final int extraItemsCount;

  const _OrderCardPreviewItem({
    required this.orderId,
    required this.item,
    required this.extraItemsCount,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/orders/$orderId'),
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          // Product image
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.radiusSM),
            child: Container(
              width: 60,
              height: 60,
              color: AppColors.background,
              child: item.productImage.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: item.productImage,
                      fit: BoxFit.contain,
                      width: 60,
                      height: 60,
                      placeholder: (context, url) => Container(
                        color: Colors.grey.shade100,
                      ),
                      errorWidget: (context, url, error) {
                        return const Icon(
                          Icons.phone_android_rounded,
                          color: AppColors.textTertiary,
                        );
                      },
                    )
                  : const Icon(
                      Icons.phone_android_rounded,
                      color: AppColors.textTertiary,
                    ),
            ),
          ),

          const SizedBox(width: AppSizes.md),

          // Product information
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.titleSmall.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 2),

                Row(
                  children: [
                    if (item.color.isNotEmpty) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: AppColors.border,
                          ),
                        ),
                        child: Text(
                          item.color,
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 10,
                          ),
                        ),
                      ),

                      const SizedBox(width: AppSizes.xs),
                    ],

                    Text(
                      'x${item.quantity}',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),

                if (extraItemsCount > 0) ...[
                  const SizedBox(height: 4),

                  Text(
                    '+ $extraItemsCount sản phẩm khác',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(width: AppSizes.xs),

          // Item price
          Text(
            CurrencyFormatter.format(item.totalPrice),
            style: AppTypography.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Sub-widget 3: Footer ───────────────────────────────────────────────────

class _OrderCardFooter extends StatelessWidget {
  final OrderEntity order;
  final VoidCallback? onCancelOrder;

  const _OrderCardFooter({
    required this.order,
    this.onCancelOrder,
  });

  @override
  Widget build(BuildContext context) {
    final totalQuantity = order.items.fold(
      0,
      (sum, item) => sum + item.quantity,
    );

    return Row(
      children: [
        // ─── Total ─────────────────────────────────────────────────────────
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tổng thanh toán ($totalQuantity SP):',
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              CurrencyFormatter.format(order.total),
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),

        const Spacer(),

        // ─── Actions ──────────────────────────────────────────────────────
        if (order.isPending && onCancelOrder != null) ...[
          OutlinedButton(
            onPressed: onCancelOrder,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.error,
              side: const BorderSide(
                color: AppColors.error,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.md,
                vertical: AppSizes.xs,
              ),
              minimumSize: const Size(0, 32),
              visualDensity: VisualDensity.compact,
            ),
            child: const Text('Hủy đơn'),
          ),
          const SizedBox(width: AppSizes.xs),
        ],

        ElevatedButton(
          onPressed: () {
            context.push('/orders/${order.id}');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.md,
              vertical: AppSizes.xs,
            ),
            minimumSize: const Size(0, 32),
            visualDensity: VisualDensity.compact,
          ),
          child: const Text(
            'Chi tiết',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}