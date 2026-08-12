import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/helpers.dart';
import '../../domain/usecases/auth/auth_usecases.dart';
import '../../router/app_router.dart';
import '../cart/providers/cart_provider.dart';
import '../widgets/primary_button.dart';
import 'providers/checkout_provider.dart';
import 'widgets/add_address_dialog.dart';
import 'widgets/address_selection_sheet.dart';
import 'widgets/checkout_address_card.dart';
import 'widgets/checkout_item_tile.dart';
import 'widgets/checkout_payment_selector.dart';

/// CheckoutScreen — Màn hình Đặt hàng & Thanh toán
class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  late final TextEditingController _noteController;
  bool _isItemsExpanded = true;

  @override
  void initState() {
    super.initState();
    final checkoutState = ref.read(checkoutProvider);
    _noteController = TextEditingController(text: checkoutState.note);
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _openAddressSheet() {
    final user = ref.read(authStateProvider).asData?.value;
    final checkoutState = ref.read(checkoutProvider);

    if (user == null) return;

    if (user.addresses.isEmpty) {
      // Nếu chưa có địa chỉ nào, mở ngay dialog thêm mới
      showDialog(
        context: context,
        builder: (context) => AddAddressDialog(
          onSave: (newAddress) {
            ref.read(checkoutProvider.notifier).addNewAddress(newAddress);
          },
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => AddressSelectionSheet(
          addresses: user.addresses,
          selectedAddress: checkoutState.selectedAddress,
          onSelectAddress: (addr) {
            ref.read(checkoutProvider.notifier).selectAddress(addr);
          },
          onAddNewAddress: (newAddr) {
            ref.read(checkoutProvider.notifier).addNewAddress(newAddr);
          },
        ),
      );
    }
  }

  Future<void> _handlePlaceOrder() async {
    final user = ref.read(authStateProvider).asData?.value;
    final cartState = ref.read(cartProvider);

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng đăng nhập để thực hiện đặt hàng.')),
      );
      return;
    }

    final notifier = ref.read(checkoutProvider.notifier);
    notifier.setNote(_noteController.text);

    final orderId = await notifier.placeOrder(
      cartState: cartState,
      user: user,
    );

    if (!mounted) return;

    if (orderId != null) {
      final checkoutState = ref.read(checkoutProvider);

      if (checkoutState.paymentMethod == 'cod') {
        _showSuccessDialog(orderId);
      } else if (checkoutState.paymentMethod == 'sepay') {
        context.push('${AppRoutes.sepaPayment}?orderId=$orderId');
      } else if (checkoutState.paymentMethod == 'momo') {
        context.push('${AppRoutes.momoPayment}?orderId=$orderId');
      }
    } else {
      final err = ref.read(checkoutProvider).errorMessage;
      if (err != null && err.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(err),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _showSuccessDialog(String orderId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusLG),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: AppSizes.md),
              Container(
                padding: const EdgeInsets.all(AppSizes.md),
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 48,
                ),
              ),
              const SizedBox(height: AppSizes.lg),
              Text(
                'Đặt hàng thành công! 🎉',
                style: AppTypography.titleLarge.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.sm),
              Text(
                'Cảm ơn bạn đã mua sắm tại SmartphoneHub. Mã đơn hàng của bạn là #${orderId.substring(0, 8).toUpperCase()}.',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.xl),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    context.go(AppRoutes.home);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: AppSizes.md),
                  ),
                  child: const Text(
                    'Trở về trang chủ',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);
    final checkoutState = ref.watch(checkoutProvider);
    final items = cartState.cart.items;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
        title: Text(
          'Xác nhận đơn hàng',
          style: AppTypography.headlineSmall.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: cartState.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : items.isEmpty && checkoutState.createdOrderId == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.shopping_cart_outlined,
                        size: 64,
                        color: AppColors.textTertiary,
                      ),
                      const SizedBox(height: AppSizes.md),
                      Text(
                        'Không có sản phẩm để thanh toán',
                        style: AppTypography.titleMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: AppSizes.lg),
                      ElevatedButton(
                        onPressed: () => context.go(AppRoutes.home),
                        child: const Text('Tiếp tục mua sắm'),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(AppSizes.lg),
                        children: [
                          // 1. Địa chỉ giao hàng
                          CheckoutAddressCard(
                            address: checkoutState.selectedAddress,
                            onChangeAddress: _openAddressSheet,
                          ),
                          const SizedBox(height: AppSizes.lg),

                          // 2. Danh sách sản phẩm
                          Container(
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
                            padding: const EdgeInsets.all(AppSizes.lg),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Sản phẩm trong đơn (${items.length})',
                                      style: AppTypography.titleMedium.copyWith(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const Spacer(),
                                    IconButton(
                                      icon: Icon(
                                        _isItemsExpanded
                                            ? Icons.keyboard_arrow_up
                                            : Icons.keyboard_arrow_down,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _isItemsExpanded = !_isItemsExpanded;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                if (_isItemsExpanded) ...[
                                  const Divider(color: AppColors.border),
                                  ...items.map((item) => CheckoutItemTile(item: item)),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(height: AppSizes.lg),

                          // 3. Phương thức thanh toán
                          Container(
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
                            padding: const EdgeInsets.all(AppSizes.lg),
                            child: CheckoutPaymentSelector(
                              selectedMethod: checkoutState.paymentMethod,
                              onMethodSelected: (method) {
                                ref
                                    .read(checkoutProvider.notifier)
                                    .selectPaymentMethod(method);
                              },
                            ),
                          ),
                          const SizedBox(height: AppSizes.lg),

                          // 4. Ghi chú đơn hàng
                          Container(
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
                            padding: const EdgeInsets.all(AppSizes.lg),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Ghi chú đơn hàng',
                                  style: AppTypography.titleMedium.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: AppSizes.sm),
                                TextField(
                                  controller: _noteController,
                                  maxLines: 2,
                                  decoration: const InputDecoration(
                                    hintText: 'Nhập lời nhắn cho người bán (nếu có)...',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: AppSizes.lg),

                          // 5. Tóm tắt chi phí
                          Container(
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
                            padding: const EdgeInsets.all(AppSizes.lg),
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
                                _buildSummaryRow(
                                  'Tiền hàng (${items.fold(0, (sum, i) => sum + i.quantity)} SP)',
                                  CurrencyFormatter.format(cartState.subtotal),
                                ),
                                const SizedBox(height: AppSizes.sm),
                                _buildSummaryRow(
                                  'Phí vận chuyển',
                                  cartState.shippingFee == 0
                                      ? 'Miễn phí'
                                      : CurrencyFormatter.format(cartState.shippingFee),
                                  isFreeShipping: cartState.shippingFee == 0,
                                ),
                                if (cartState.discountAmount > 0) ...[
                                  const SizedBox(height: AppSizes.sm),
                                  _buildSummaryRow(
                                    'Voucher giảm giá',
                                    '-${CurrencyFormatter.format(cartState.discountAmount)}',
                                    isDiscount: true,
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
                                      CurrencyFormatter.format(cartState.totalPrice),
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
                        ],
                      ),
                    ),

                    // Bottom Bar
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.lg,
                        vertical: AppSizes.md,
                      ),
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
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Tổng cộng:',
                                    style: AppTypography.labelSmall.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  Text(
                                    CurrencyFormatter.format(cartState.totalPrice),
                                    style: AppTypography.titleLarge.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: AppSizes.md),
                            Expanded(
                              child: PrimaryButton(
                                label: 'Đặt hàng',
                                isLoading: checkoutState.isLoading,
                                onPressed: checkoutState.isLoading ? null : _handlePlaceOrder,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    bool isFreeShipping = false,
    bool isDiscount = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: AppTypography.bodyMedium.copyWith(
            color: isFreeShipping
                ? Colors.green
                : isDiscount
                    ? AppColors.error
                    : AppColors.textPrimary,
            fontWeight: (isFreeShipping || isDiscount)
                ? FontWeight.w700
                : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
