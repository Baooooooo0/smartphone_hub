import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/helpers.dart';
import '../../../router/app_router.dart';
import '../widgets/primary_button.dart';
import 'providers/cart_provider.dart';
import 'widgets/cart_empty_view.dart';
import 'widgets/cart_item_tile.dart';

/// CartScreen — Màn hình Giỏ hàng hoàn chỉnh
class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  final TextEditingController _voucherController = TextEditingController();

  @override
  void dispose() {
    _voucherController.dispose();
    super.dispose();
  }

  void _showClearConfirmDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: const Text('Bạn có chắc chắn muốn xóa toàn bộ sản phẩm trong giỏ hàng không?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(cartProvider.notifier).clearCart();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
              child: const Text('Xóa tất cả', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);
    final items = cartState.cart.items;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
        title: Text(
          'Giỏ hàng (${cartState.cart.totalQuantity})',
          style: AppTypography.headlineSmall.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          if (items.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_rounded, color: AppColors.error),
              tooltip: 'Xóa giỏ hàng',
              onPressed: _showClearConfirmDialog,
            ),
        ],
      ),
      body: cartState.cart.isEmpty
          ? const CartEmptyView()
          : ListView.builder(
              padding: const EdgeInsets.all(AppSizes.lg),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return CartItemTile(
                  item: item,
                  onIncrement: () {
                    ref.read(cartProvider.notifier).incrementQuantity(item);
                  },
                  onDecrement: () {
                    ref.read(cartProvider.notifier).decrementQuantity(item);
                  },
                  onRemove: () {
                    ref
                        .read(cartProvider.notifier)
                        .removeItem(item.productId, item.color);
                  },
                );
              },
            ),
      bottomNavigationBar: cartState.cart.isEmpty
          ? null
          : _buildBottomCheckoutBar(cartState),
    );
  }

  // ── Bottom Bar dính chân trang ────────────────────────────
  Widget _buildBottomCheckoutBar(CartState cartState) {
    return Container(
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
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.lg,
            vertical: AppSizes.md,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. Voucher Input
              if (cartState.appliedVoucherCode != null)
                _buildAppliedVoucher(cartState.appliedVoucherCode!)
              else
                _buildVoucherInput(),
              const SizedBox(height: AppSizes.sm),

              // 2. Tóm tắt chi phí
              _buildCostSummarySection(cartState),
              const Divider(height: AppSizes.lg),

              // 3. Tổng cộng & Nút thanh toán
              _buildCheckoutActionRow(cartState),
            ],
          ),
        ),
      ),
    );
  }

  // ── Tóm tắt chi phí (Tạm tính, Phí ship, Giảm giá voucher) ──
  Widget _buildCostSummarySection(CartState cartState) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildSummaryRow(
          'Tạm tính (${cartState.cart.totalQuantity} SP)',
          CurrencyFormatter.format(cartState.subtotal),
        ),
        const SizedBox(height: 4),
        _buildSummaryRow(
          'Phí vận chuyển',
          cartState.shippingFee == 0
              ? 'Miễn phí'
              : CurrencyFormatter.format(cartState.shippingFee),
          valueColor: cartState.shippingFee == 0 ? Colors.green : null,
        ),
        if (cartState.discountAmount > 0) ...[
          const SizedBox(height: 4),
          _buildSummaryRow(
            'Giảm giá voucher',
            '-${CurrencyFormatter.format(cartState.discountAmount)}',
            valueColor: AppColors.error,
          ),
        ],
      ],
    );
  }

  // ── Tổng cộng & Nút thanh toán ─────────────────────────────
  Widget _buildCheckoutActionRow(CartState cartState) {
    return Row(
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
            label: 'Thanh toán (${cartState.cart.totalQuantity})',
            onPressed: () {
              context.push(AppRoutes.checkout);
            },
          ),
        ),
      ],
    );
  }

  // ── Voucher đã áp dụng ──────────────────────────────────────────
  Widget _buildAppliedVoucher(String code) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: BorderRadius.circular(AppSizes.radiusSM),
        border: Border.all(color: AppColors.primary),
      ),
      child: Row(
        children: [
          const Icon(Icons.confirmation_number_outlined,
              color: AppColors.primary, size: 18),
          const SizedBox(width: AppSizes.xs),
          Expanded(
            child: Text(
              'Mã: $code',
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => ref.read(cartProvider.notifier).removeVoucher(),
            child: const Icon(Icons.close_rounded, color: AppColors.error, size: 18),
          ),
        ],
      ),
    );
  }

  // ── Ô nhập voucher ──────────────────────────────────────────────
  Widget _buildVoucherInput() {
    return SizedBox(
      height: 40,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _voucherController,
              decoration: InputDecoration(
                hintText: 'Nhập mã giảm giá',
                hintStyle: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.md,
                  vertical: 0,
                ),
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusSM),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusSM),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSizes.sm),
          SizedBox(
            height: 40,
            child: ElevatedButton(
              onPressed: () {
                final code = _voucherController.text.trim();
                if (code.isNotEmpty) {
                  final success = ref.read(cartProvider.notifier).applyVoucher(code);
                  if (success) {
                    _voucherController.clear();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('🎉 Áp dụng mã "$code" thành công!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('❌ Mã giảm giá không hợp lệ'),
                        backgroundColor: AppColors.error,
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusSM),
                ),
                elevation: 0,
              ),
              child: const Text('Áp dụng'),
            ),
          ),
        ],
      ),
    );
  }

  // ── Hàng tóm tắt chi phí ───────────────────────────────────────
  Widget _buildSummaryRow(String label, String value, {Color? valueColor}) {
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
          style: AppTypography.titleSmall.copyWith(
            color: valueColor ?? AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
