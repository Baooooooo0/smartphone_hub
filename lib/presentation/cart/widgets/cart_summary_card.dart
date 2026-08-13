import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/helpers.dart';
import '../providers/cart_provider.dart';

/// CartSummaryCard — Thẻ hiển thị thông tin tiền hàng, phí giao hàng, voucher & tổng thanh toán
class CartSummaryCard extends StatefulWidget {
  final CartState state;
  final ValueChanged<String> onApplyVoucher;
  final VoidCallback onRemoveVoucher;

  const CartSummaryCard({
    super.key,
    required this.state,
    required this.onApplyVoucher,
    required this.onRemoveVoucher,
  });

  @override
  State<CartSummaryCard> createState() => _CartSummaryCardState();
}

class _CartSummaryCardState extends State<CartSummaryCard> {
  final TextEditingController _voucherController = TextEditingController();

  @override
  void dispose() {
    _voucherController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;

    return Container(
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMD),
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Voucher Input Section ──────────────────────────────────
          Text(
            'Mã giảm giá (Voucher)',
            style: AppTypography.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSizes.xs),
          if (state.appliedVoucherCode != null)
            Container(
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
                  const Icon(Icons.confirmation_number_outlined, color: AppColors.primary, size: 20),
                  const SizedBox(width: AppSizes.xs),
                  Text(
                    'Mã: ${state.appliedVoucherCode}',
                    style: AppTypography.labelLarge.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: widget.onRemoveVoucher,
                    borderRadius: BorderRadius.circular(AppSizes.radiusSM),
                    child: const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Icon(
                        Icons.close_rounded,
                        color: AppColors.error,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            SizedBox(
              height: 44,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _voucherController,
                      style: AppTypography.bodyMedium,
                      decoration: InputDecoration(
                        hintText: 'Nhập mã (VD: HUB50K, HUB100K, VIP10)',
                        hintStyle: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.md,
                          vertical: AppSizes.sm,
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
                    height: 44,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_voucherController.text.trim().isNotEmpty) {
                          widget.onApplyVoucher(_voucherController.text.trim());
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
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
            ),
          const SizedBox(height: AppSizes.lg),
          const Divider(),

          // ── Payment Details ────────────────────────────────────────
          _buildRow('Tạm tính tiền hàng', CurrencyFormatter.format(state.subtotal)),
          const SizedBox(height: AppSizes.xs),
          _buildRow(
            'Phí vận chuyển',
            state.shippingFee == 0 ? 'Miễn phí' : CurrencyFormatter.format(state.shippingFee),
            isHighlight: state.shippingFee == 0,
          ),
          if (state.discountAmount > 0) ...[
            const SizedBox(height: AppSizes.xs),
            _buildRow(
              'Giảm giá Voucher',
              '- ${CurrencyFormatter.format(state.discountAmount)}',
              isError: true,
            ),
          ],
          const SizedBox(height: AppSizes.md),
          const Divider(),
          const SizedBox(height: AppSizes.xs),

          // Total Price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tổng thanh toán',
                style: AppTypography.titleLarge.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                CurrencyFormatter.format(state.totalPrice),
                style: AppTypography.headlineMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool isHighlight = false, bool isError = false}) {
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
            color: isError
                ? AppColors.error
                : (isHighlight ? Colors.green : AppColors.textPrimary),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
