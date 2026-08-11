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
import 'widgets/cart_summary_card.dart';

/// CartScreen — Màn hình Giỏ hàng hoàn chỉnh
class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  void _showClearConfirmDialog(BuildContext context, WidgetRef ref) {
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
  Widget build(BuildContext context, WidgetRef ref) {
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
              onPressed: () => _showClearConfirmDialog(context, ref),
            ),
        ],
      ),
      body: cartState.cart.isEmpty
          ? const CartEmptyView()
          : Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSizes.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Danh sách sản phẩm trong giỏ
                      Text(
                        'Sản phẩm đã chọn (${items.length})',
                        style: AppTypography.titleMedium.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: AppSizes.sm),
                      ...items.map((item) {
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
                      }),
                      const SizedBox(height: AppSizes.lg),

                      // Tóm tắt đơn hàng & Voucher
                      CartSummaryCard(
                        state: cartState,
                        onApplyVoucher: (code) {
                          final success = ref.read(cartProvider.notifier).applyVoucher(code);
                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('🎉 Áp dụng mã "$code" thành công!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('❌ Mã giảm giá không hợp lệ hoặc đã hết hạn'),
                                backgroundColor: AppColors.error,
                              ),
                            );
                          }
                        },
                        onRemoveVoucher: () {
                          ref.read(cartProvider.notifier).removeVoucher();
                        },
                      ),

                      // Bottom Spacing cho Sticky Bar
                      const SizedBox(height: 100),
                    ],
                  ),
                ),

                // Sticky Bottom Bar nút Thanh toán
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
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
                              label: 'Thanh toán (${cartState.cart.totalQuantity})',
                              onPressed: () {
                                context.push(AppRoutes.checkout);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
