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
      margin: const EdgeInsets.only(bottom: AppSizes.md),
      padding: const EdgeInsets.all(AppSizes.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Header: Mã đơn + Ngày tạo + Badge Trạng thái ──────────────────
          Row(
            children: [
              Text(
                '#${order.id.length > 8 ? order.id.substring(0, 8).toUpperCase() : order.id}',
                style: AppTypography.titleSmall.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: AppSizes.xs),
              Text(
                formattedDate,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.xs + 2,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: _statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSizes.radiusXS),
                ),
                child: Text(
                  _statusText,
                  style: AppTypography.labelSmall.copyWith(
                    color: _statusColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: AppSizes.lg, color: AppColors.border),

          // ─── Body: Sản phẩm xem trước ─────────────────────────────────────
          if (firstItem != null)
            GestureDetector(
              onTap: () => context.push('/orders/${order.id}'),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppSizes.radiusSM),
                    child: Container(
                      width: 60,
                      height: 60,
                      color: AppColors.background,
                      child: firstItem.productImage.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: firstItem.productImage,
                              fit: BoxFit.contain,
                              width: 60,
                              height: 60,
                              placeholder: (context, url) =>
                                  Container(color: Colors.grey.shade100),
                              errorWidget: (context, url, error) => const Icon(
                                Icons.phone_android_rounded,
                                color: AppColors.textTertiary,
                              ),
                            )
                          : const Icon(
                              Icons.phone_android_rounded,
                              color: AppColors.textTertiary,
                            ),
                    ),
                  ),
                  const SizedBox(width: AppSizes.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          firstItem.productName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.titleSmall.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 1),
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Text(
                                firstItem.color,
                                style: AppTypography.labelSmall.copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSizes.xs),
                            Text(
                              'x${firstItem.quantity}',
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
                  Text(
                    CurrencyFormatter.format(firstItem.totalPrice),
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          const Divider(height: AppSizes.lg, color: AppColors.border),

          // ─── Footer: Tổng thanh toán + Actions ────────────────────────────
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tổng thanh toán (${order.items.fold(0, (sum, i) => sum + i.quantity)} SP):',
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
              if (order.isPending && onCancelOrder != null)
                OutlinedButton(
                  onPressed: onCancelOrder,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.md,
                      vertical: AppSizes.xs,
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                  child: const Text('Hủy đơn'),
                ),
              if (order.isPending && onCancelOrder != null)
                const SizedBox(width: AppSizes.xs),
              ElevatedButton(
                onPressed: () => context.push('/orders/${order.id}'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.md,
                    vertical: AppSizes.xs,
                  ),
                  visualDensity: VisualDensity.compact,
                ),
                child: const Text('Chi tiết', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
