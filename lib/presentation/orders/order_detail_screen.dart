import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/helpers.dart';
import '../../router/app_router.dart';
import '../widgets/primary_button.dart';
import 'providers/order_providers.dart';
import 'widgets/cancel_order_dialog.dart';
import 'widgets/order_auto_cancel_timer.dart';
import 'widgets/order_timeline_widget.dart';

/// OrderDetailScreen — Màn hình chi tiết đơn hàng
class OrderDetailScreen extends ConsumerWidget {
  final String orderId;

  const OrderDetailScreen({
    super.key,
    required this.orderId,
  });

  void _copyOrderId(BuildContext context) {
    Clipboard.setData(ClipboardData(text: orderId));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('📋 Đã sao chép mã đơn hàng!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showCancelDialog(BuildContext context, WidgetRef ref) {
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderAsync = ref.watch(orderDetailStreamProvider(orderId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
        title: Text(
          'Chi tiết đơn hàng',
          style: AppTypography.headlineSmall.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy_rounded, size: 20),
            tooltip: 'Sao chép mã đơn hàng',
            onPressed: () => _copyOrderId(context),
          ),
        ],
      ),
      body: orderAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (error, stack) => Center(
          child: Text('Lỗi nạp chi tiết đơn hàng: $error'),
        ),
        data: (order) {
          if (order == null) {
            return const Center(
              child: Text('Không tìm thấy thông tin đơn hàng này.'),
            );
          }

          final formattedDate = order.createdAt != null
              ? DateFormat('dd/MM/yyyy HH:mm').format(order.createdAt!)
              : '';

          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(AppSizes.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Banner đếm ngược tự hủy 15 phút nếu đơn đang chờ xác nhận
                    if (order.isPending && order.createdAt != null)
                      OrderAutoCancelTimer(
                        orderId: order.id,
                        createdAt: order.createdAt,
                        isBanner: true,
                      ),

                    // 1. Mã đơn hàng & Ngày khởi tạo Card
                    Container(
                      padding: const EdgeInsets.all(AppSizes.lg),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppSizes.radiusLG),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Mã đơn hàng:',
                                style: AppTypography.labelSmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '#${order.id.length > 8 ? order.id.substring(0, 8).toUpperCase() : order.id}',
                                style: AppTypography.titleMedium.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Text(
                            formattedDate,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSizes.lg),

                    // 2. Mốc tiến trình đơn hàng (Timeline)
                    Container(
                      padding: const EdgeInsets.all(AppSizes.lg),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppSizes.radiusLG),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Trạng thái đơn hàng',
                            style: AppTypography.titleMedium.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: AppSizes.md),
                          OrderTimelineWidget(order: order),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSizes.lg),

                    // 3. Địa chỉ giao hàng
                    Container(
                      padding: const EdgeInsets.all(AppSizes.lg),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppSizes.radiusLG),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.location_on_rounded,
                                  color: AppColors.primary, size: 20),
                              const SizedBox(width: AppSizes.xs),
                              Text(
                                'Địa chỉ nhận hàng',
                                style: AppTypography.titleMedium.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: AppSizes.lg, color: AppColors.border),
                          Row(
                            children: [
                              Text(
                                order.shippingAddress.recipientName,
                                style: AppTypography.titleSmall.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: AppSizes.xs),
                              Text(
                                '(${order.shippingAddress.phone})',
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${order.shippingAddress.street}, ${order.shippingAddress.ward}, ${order.shippingAddress.district}, ${order.shippingAddress.province}',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSizes.lg),

                    // 4. Danh sách sản phẩm trong đơn
                    Container(
                      padding: const EdgeInsets.all(AppSizes.lg),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppSizes.radiusLG),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sản phẩm đã mua (${order.items.length})',
                            style: AppTypography.titleMedium.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Divider(height: AppSizes.lg, color: AppColors.border),
                          ...order.items.map((item) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: AppSizes.xs),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(AppSizes.radiusSM),
                                    child: Container(
                                      width: 54,
                                      height: 54,
                                      color: AppColors.background,
                                      child: CachedNetworkImage(
                                        imageUrl: item.productImage,
                                        fit: BoxFit.contain,
                                        placeholder: (context, url) =>
                                            Container(color: Colors.grey.shade100),
                                        errorWidget: (context, url, error) =>
                                            const Icon(
                                          Icons.phone_android_rounded,
                                          color: AppColors.textTertiary,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: AppSizes.md),
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
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 6, vertical: 1),
                                              decoration: BoxDecoration(
                                                color: AppColors.background,
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                border: Border.all(
                                                    color: AppColors.border),
                                              ),
                                              child: Text(
                                                item.color,
                                                style: AppTypography.labelSmall
                                                    .copyWith(
                                                  color: AppColors.textSecondary,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: AppSizes.xs),
                                            Text(
                                              'x${item.quantity}',
                                              style: AppTypography.labelSmall
                                                  .copyWith(
                                                color: AppColors.textSecondary,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: AppSizes.xs),
                                  Text(
                                    CurrencyFormatter.format(item.totalPrice),
                                    style: AppTypography.titleSmall.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSizes.lg),

                    // 5. Phương thức & Trạng thái thanh toán
                    Container(
                      padding: const EdgeInsets.all(AppSizes.lg),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppSizes.radiusLG),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Thông tin thanh toán',
                            style: AppTypography.titleMedium.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Divider(height: AppSizes.lg, color: AppColors.border),
                          _buildDetailRow(
                            'Phương thức',
                            _getPaymentMethodTitle(order.paymentMethod),
                          ),
                          const SizedBox(height: AppSizes.sm),
                          _buildDetailRow(
                            'Trạng thái thanh toán',
                            order.isPaid ? 'Đã thanh toán ✓' : 'Chưa thanh toán',
                            isHighlight: order.isPaid,
                            highlightColor:
                                order.isPaid ? Colors.green : AppColors.warning,
                          ),
                          if (order.paymentRef.isNotEmpty) ...[
                            const SizedBox(height: AppSizes.sm),
                            _buildDetailRow('Mã giao dịch', order.paymentRef),
                          ],
                          if (order.note.isNotEmpty) ...[
                            const SizedBox(height: AppSizes.sm),
                            _buildDetailRow('Ghi chú đơn hàng', order.note),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSizes.lg),

                    // 6. Tóm tắt chi phí đơn hàng
                    Container(
                      padding: const EdgeInsets.all(AppSizes.lg),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppSizes.radiusLG),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Chi tiết chi phí',
                            style: AppTypography.titleMedium.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Divider(height: AppSizes.lg, color: AppColors.border),
                          _buildDetailRow(
                            'Tiền hàng',
                            CurrencyFormatter.format(order.subtotal),
                          ),
                          const SizedBox(height: AppSizes.sm),
                          _buildDetailRow(
                            'Phí vận chuyển',
                            order.shippingFee == 0
                                ? 'Miễn phí'
                                : CurrencyFormatter.format(order.shippingFee),
                          ),
                          if (order.discount > 0) ...[
                            const SizedBox(height: AppSizes.sm),
                            _buildDetailRow(
                              'Giảm giá voucher',
                              '-${CurrencyFormatter.format(order.discount)}',
                              isHighlight: true,
                              highlightColor: AppColors.error,
                            ),
                          ],
                          const Divider(height: AppSizes.lg, color: AppColors.border),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Tổng thanh toán',
                                style: AppTypography.titleMedium.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                CurrencyFormatter.format(order.total),
                                style: AppTypography.headlineSmall.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Spacing cho Bottom Action Bar nếu có
                    const SizedBox(height: 100),
                  ],
                ),
              ),

              // Sticky Bottom Action Bar
              if (order.isPending || (!order.isPaid && order.paymentMethod != 'cod'))
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(AppSizes.md),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 16,
                          offset: const Offset(0, -4),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      child: Row(
                        children: [
                          if (order.isPending)
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => _showCancelDialog(context, ref),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.error,
                                  side: const BorderSide(color: AppColors.error),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: AppSizes.md),
                                ),
                                child: const Text('Hủy đơn hàng'),
                              ),
                            ),
                          if (order.isPending &&
                              !order.isPaid &&
                              order.paymentMethod != 'cod')
                            const SizedBox(width: AppSizes.md),
                          if (!order.isPaid && order.paymentMethod != 'cod')
                            Expanded(
                              child: PrimaryButton(
                                label: 'Thanh toán ngay',
                                onPressed: () {
                                  if (order.paymentMethod == 'sepay') {
                                    context.push('${AppRoutes.sepaPayment}?orderId=${order.id}');
                                  } else if (order.paymentMethod == 'momo') {
                                    context.push('${AppRoutes.momoPayment}?orderId=${order.id}');
                                  }
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  String _getPaymentMethodTitle(String method) {
    switch (method) {
      case 'cod':
        return 'Thanh toán khi nhận hàng (COD)';
      case 'sepay':
        return 'Chuyển khoản QR SePay';
      case 'momo':
        return 'Ví điện tử MoMo';
      default:
        return method;
    }
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    bool isHighlight = false,
    Color? highlightColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: AppTypography.bodySmall.copyWith(
            color: isHighlight
                ? (highlightColor ?? AppColors.primary)
                : AppColors.textPrimary,
            fontWeight: isHighlight ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
