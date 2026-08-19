import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/services/sepay_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/helpers.dart';
import '../../../domain/entities/order_entity.dart';
import '../../../router/app_router.dart';
import '../orders/providers/order_providers.dart';
import '../widgets/primary_button.dart';
import 'widgets/sepay_info_row.dart';

class SepayPaymentScreen extends ConsumerStatefulWidget {
  final String orderId;

  const SepayPaymentScreen({
    super.key,
    required this.orderId,
  });

  @override
  ConsumerState<SepayPaymentScreen> createState() => _SepayPaymentScreenState();
}

class _SepayPaymentScreenState extends ConsumerState<SepayPaymentScreen> {
  Timer? _timer;
  int _secondsRemaining = 15 * 60; // 15 phút
  bool _hasTriggeredSuccess = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        _timer?.cancel();
      }
    });
  }

  String get _formattedTime {
    final minutes = (_secondsRemaining ~/ 60).toString().padLeft(2, '0');
    final seconds = (_secondsRemaining % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final orderAsync = ref.watch(orderDetailStreamProvider(widget.orderId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
        title: Text(
          'Thanh toán SePay QR',
          style: AppTypography.headlineSmall.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.go(AppRoutes.home),
        ),
      ),
      body: orderAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (err, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.xl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline_rounded,
                    size: 64, color: AppColors.error),
                const SizedBox(height: AppSizes.md),
                Text(
                  'Không thể tải thông tin đơn hàng',
                  style: AppTypography.titleMedium,
                ),
                const SizedBox(height: AppSizes.lg),
                ElevatedButton(
                  onPressed: () => context.go(AppRoutes.home),
                  child: const Text('Về trang chủ'),
                ),
              ],
            ),
          ),
        ),
        data: (order) {
          if (order == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.receipt_long_outlined,
                      size: 64, color: AppColors.textTertiary),
                  const SizedBox(height: AppSizes.md),
                  Text('Đơn hàng không tồn tại',
                      style: AppTypography.titleMedium),
                  const SizedBox(height: AppSizes.lg),
                  ElevatedButton(
                    onPressed: () => context.go(AppRoutes.home),
                    child: const Text('Về trang chủ'),
                  ),
                ],
              ),
            );
          }

          // Kiểm tra nếu đơn hàng đã được cập nhật thành công (qua Webhook)
          final isPaid = order.paymentStatus == 'paid' ||
              order.status == 'confirmed' ||
              order.status == 'shipping' ||
              order.status == 'delivered';

          if (isPaid && !_hasTriggeredSuccess) {
            _hasTriggeredSuccess = true;
            _timer?.cancel();
          }

          if (isPaid) {
            return _buildSuccessView(order);
          }

          return _buildPaymentView(order);
        },
      ),
    );
  }

  // ─── 1. Màn hình thanh toán chính ──────────────────────────────────────────
  Widget _buildPaymentView(OrderEntity order) {
    final sepay = SepayService.instance;
    final transferContent = sepay.buildTransferContent(order.id);
    final qrUrl = sepay.buildQRUrl(
      amount: order.total,
      content: transferContent,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.screenPaddingH,
        vertical: AppSizes.md,
      ),
      child: Column(
        children: [
          // ── Timer & Total Card ──────────────────────────────
          FadeInDown(
            duration: const Duration(milliseconds: 400),
            child: Container(
              padding: const EdgeInsets.all(AppSizes.lg),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSizes.radiusXL),
                border: Border.all(color: AppColors.border),
                boxShadow: AppColors.cardShadow,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tổng thanh toán',
                            style: AppTypography.bodySmall,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            CurrencyFormatter.format(order.total),
                            style: AppTypography.headlineMedium.copyWith(
                              color: AppColors.priceColor,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.md,
                          vertical: AppSizes.sm,
                        ),
                        decoration: BoxDecoration(
                          color: _secondsRemaining < 180
                              ? AppColors.errorSurface
                              : AppColors.primarySurface,
                          borderRadius:
                              BorderRadius.circular(AppSizes.radiusFull),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.timer_outlined,
                              size: 16,
                              color: _secondsRemaining < 180
                                  ? AppColors.error
                                  : AppColors.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _formattedTime,
                              style: AppTypography.labelMedium.copyWith(
                                color: _secondsRemaining < 180
                                    ? AppColors.error
                                    : AppColors.primaryDark,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppSizes.lg),

          // ── QR Code Card ────────────────────────────────────
          FadeInUp(
            duration: const Duration(milliseconds: 400),
            child: Container(
              padding: const EdgeInsets.all(AppSizes.lg),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSizes.radiusXL),
                border: Border.all(color: AppColors.border),
                boxShadow: AppColors.cardShadow,
              ),
              child: Column(
                children: [
                  Text(
                    'Quét mã QR để thanh toán',
                    style: AppTypography.titleMedium.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Mở ứng dụng Ngân hàng hoặc Ví điện tử để quét',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSizes.lg),

                  // QR Image
                  Container(
                    width: 220,
                    height: 220,
                    padding: const EdgeInsets.all(AppSizes.sm),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppSizes.radiusLG),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.08),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppSizes.radiusMD),
                      child: CachedNetworkImage(
                        imageUrl: qrUrl,
                        fit: BoxFit.contain,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(strokeWidth: 2.5),
                        ),
                        errorWidget: (context, url, error) => QrImageView(
                          data: qrUrl,
                          version: QrVersions.auto,
                          size: 200.0,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSizes.md),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: AppSizes.sm),
                      Text(
                        'Đang chờ nhận thanh toán...',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppSizes.lg),

          // ── Bank Transfer Details Card ──────────────────────
          FadeInUp(
            delay: const Duration(milliseconds: 100),
            duration: const Duration(milliseconds: 400),
            child: Container(
              padding: const EdgeInsets.all(AppSizes.lg),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSizes.radiusXL),
                border: Border.all(color: AppColors.border),
                boxShadow: AppColors.cardShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hoặc chuyển khoản thủ công',
                    style: AppTypography.titleMedium.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSizes.md),
                  SepayInfoRow(
                    label: 'Ngân hàng thụ hưởng',
                    value: sepay.bankCode == 'VCB'
                        ? 'Vietcombank (VCB)'
                        : '${sepay.bankCode} (Ngân hàng Quân Đội)',
                    copyValue: sepay.bankCode,
                  ),
                  SepayInfoRow(
                    label: 'Số tài khoản',
                    value: sepay.accountNumber,
                    copyValue: sepay.accountNumber,
                    valueStyle: AppTypography.titleLarge.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                      letterSpacing: 1,
                    ),
                  ),
                  SepayInfoRow(
                    label: 'Chủ tài khoản',
                    value: sepay.accountName,
                    copyValue: sepay.accountName,
                  ),
                  SepayInfoRow(
                    label: 'Số tiền chính xác',
                    value: CurrencyFormatter.format(order.total),
                    copyValue: order.total.toInt().toString(),
                    valueStyle: AppTypography.titleLarge.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.priceColor,
                    ),
                  ),
                  SepayInfoRow(
                    label: 'Nội dung chuyển khoản (Bắt buộc)',
                    value: transferContent,
                    copyValue: transferContent,
                    isHighlighted: true,
                    valueStyle: AppTypography.titleLarge.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryDark,
                      letterSpacing: 1.2,
                    ),
                  ),

                  // Lưu ý quan trọng
                  Container(
                    margin: const EdgeInsets.only(top: AppSizes.sm),
                    padding: const EdgeInsets.all(AppSizes.md),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF8E1),
                      borderRadius: BorderRadius.circular(AppSizes.radiusMD),
                      border: Border.all(
                        color: const Color(0xFFFFB800).withValues(alpha: 0.5),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.info_outline_rounded,
                          color: Color(0xFFE65100),
                          size: 18,
                        ),
                        const SizedBox(width: AppSizes.sm),
                        Expanded(
                          child: Text(
                            'Lưu ý: Vui lòng nhập CHÍNH XÁC nội dung chuyển khoản để hệ thống tự động xác nhận đơn hàng sau 5 - 15 giây.',
                            style: AppTypography.caption.copyWith(
                              color: const Color(0xFFE65100),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppSizes.xl),

          // ── Action Buttons ──────────────────────────────────
          PrimaryButton(
            label: 'Kiểm tra trạng thái đơn hàng',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Hệ thống đang tự động lắng nghe thanh toán...',
                  ),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          const SizedBox(height: AppSizes.sm),
          TextButton(
            onPressed: () => context.go(AppRoutes.home),
            child: Text(
              'Thanh toán sau (Về trang chủ)',
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(height: AppSizes.xl),
        ],
      ),
    );
  }

  // ─── 2. Màn hình thanh toán thành công ─────────────────────────────────────
  Widget _buildSuccessView(OrderEntity order) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeInDown(
              duration: const Duration(milliseconds: 500),
              child: Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: AppColors.successSurface,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.success,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.success.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: AppColors.success,
                  size: 56,
                ),
              ),
            ),
            const SizedBox(height: AppSizes.xxl),
            FadeInDown(
              delay: const Duration(milliseconds: 150),
              duration: const Duration(milliseconds: 500),
              child: Text(
                'Thanh toán thành công! 🎉',
                style: AppTypography.headlineMedium.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: AppSizes.sm),
            FadeInDown(
              delay: const Duration(milliseconds: 250),
              duration: const Duration(milliseconds: 500),
              child: Text(
                'Cảm ơn bạn! Đơn hàng #${order.id.substring(0, order.id.length > 8 ? 8 : order.id.length).toUpperCase()} đã được thanh toán qua SePay và đang được chuẩn bị.',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: AppSizes.xxxl),
            FadeInUp(
              delay: const Duration(milliseconds: 350),
              duration: const Duration(milliseconds: 500),
              child: PrimaryButton(
                label: 'Xem chi tiết đơn hàng',
                onPressed: () => context.go('/orders/${order.id}'),
              ),
            ),
            const SizedBox(height: AppSizes.md),
            FadeInUp(
              delay: const Duration(milliseconds: 450),
              duration: const Duration(milliseconds: 500),
              child: OutlinedButton(
                onPressed: () => context.go(AppRoutes.home),
                style: OutlinedButton.styleFrom(
                  minimumSize:
                      const Size(double.infinity, AppSizes.buttonHeightMD),
                ),
                child: const Text('Tiếp tục mua sắm'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
