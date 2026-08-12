import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/order_entity.dart';

/// OrderTimelineWidget — Widget hiển thị mốc tiến trình đơn hàng (Timeline)
class OrderTimelineWidget extends StatelessWidget {
  final OrderEntity order;

  const OrderTimelineWidget({
    super.key,
    required this.order,
  });

  int get _currentStepIndex {
    switch (order.status) {
      case 'pending':
        return 0;
      case 'confirmed':
        return 1;
      case 'shipping':
        return 2;
      case 'delivered':
        return 3;
      case 'cancelled':
        return -1;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCancelled = order.status == 'cancelled';

    if (isCancelled) {
      return Container(
        padding: const EdgeInsets.all(AppSizes.md),
        decoration: BoxDecoration(
          color: AppColors.errorSurface,
          borderRadius: BorderRadius.circular(AppSizes.radiusMD),
          border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.cancel_rounded, color: AppColors.error, size: 28),
            const SizedBox(width: AppSizes.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Đơn hàng đã bị hủy',
                    style: AppTypography.titleSmall.copyWith(
                      color: AppColors.error,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    order.timeline.where((e) => e.status == 'cancelled').firstOrNull?.note ??
                        'Đơn hàng đã được hủy thành công.',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    final steps = [
      {'title': 'Đặt hàng', 'icon': Icons.shopping_bag_outlined},
      {'title': 'Xác nhận', 'icon': Icons.check_circle_outline},
      {'title': 'Đang giao', 'icon': Icons.local_shipping_outlined},
      {'title': 'Đã giao', 'icon': Icons.task_alt},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(steps.length, (index) {
            final isReached = index <= _currentStepIndex;
            final isCurrent = index == _currentStepIndex;

            return Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: isCurrent
                                ? AppColors.primary
                                : isReached
                                    ? AppColors.primary.withValues(alpha: 0.15)
                                    : AppColors.surfaceVariant,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isReached ? AppColors.primary : AppColors.border,
                              width: isCurrent ? 2.0 : 1.0,
                            ),
                          ),
                          child: Icon(
                            steps[index]['icon'] as IconData,
                            size: 18,
                            color: isCurrent
                                ? Colors.white
                                : isReached
                                    ? AppColors.primary
                                    : AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: AppSizes.xs),
                        Text(
                          steps[index]['title'] as String,
                          style: AppTypography.labelSmall.copyWith(
                            color: isReached ? AppColors.textPrimary : AppColors.textSecondary,
                            fontWeight: isReached ? FontWeight.w700 : FontWeight.normal,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  if (index < steps.length - 1)
                    Expanded(
                      child: Container(
                        height: 2,
                        color: index < _currentStepIndex
                            ? AppColors.primary
                            : AppColors.border,
                      ),
                    ),
                ],
              ),
            );
          }),
        ),

        // Lịch sử timeline events (nếu có)
        if (order.timeline.isNotEmpty) ...[
          const SizedBox(height: AppSizes.md),
          const Divider(color: AppColors.border),
          const SizedBox(height: AppSizes.xs),
          ...order.timeline.reversed.map((event) {
            final formattedDate =
                DateFormat('dd/MM/yyyy HH:mm').format(event.timestamp);
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 3.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: AppSizes.sm),
                  Expanded(
                    child: Text(
                      event.note,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSizes.xs),
                  Text(
                    formattedDate,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ],
    );
  }
}
