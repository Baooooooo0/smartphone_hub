import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_theme.dart';

class PaymentOption {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final String? badgeText;

  const PaymentOption({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    this.badgeText,
  });
}

/// CheckoutPaymentSelector — Widget lựa chọn phương thức thanh toán
class CheckoutPaymentSelector extends StatelessWidget {
  final String selectedMethod;
  final ValueChanged<String> onMethodSelected;

  static const List<PaymentOption> options = [
    PaymentOption(
      id: 'cod',
      title: 'Thanh toán khi nhận hàng (COD)',
      subtitle: 'Thanh toán bằng tiền mặt khi shipper giao tới',
      icon: Icons.payments_rounded,
      iconColor: Colors.green,
      badgeText: 'Khuyên dùng',
    ),
    PaymentOption(
      id: 'sepay',
      title: 'Chuyển khoản QR ngân hàng (SePay)',
      subtitle: 'Quét mã VietQR thanh toán tự động qua App Ngân hàng',
      icon: Icons.qr_code_2_rounded,
      iconColor: AppColors.primary,
      badgeText: 'Tự động',
    ),
    PaymentOption(
      id: 'momo',
      title: 'Ví điện tử MoMo',
      subtitle: 'Thanh toán nhanh chóng qua App MoMo',
      icon: Icons.account_balance_wallet_rounded,
      iconColor: Color(0xFFA50064), // MoMo pink color
      badgeText: 'Ưu đãi',
    ),
  ];

  const CheckoutPaymentSelector({
    super.key,
    required this.selectedMethod,
    required this.onMethodSelected,
  });

  @override
  Widget build(BuildContext context) {
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
      padding: const EdgeInsets.all(AppSizes.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSizes.xs + 2),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSizes.sm),
                ),
                child: const Icon(
                  Icons.payment_rounded,
                  color: AppColors.primary,
                  size: AppSizes.iconMD,
                ),
              ),
              const SizedBox(width: AppSizes.sm),
              Text(
                'Phương thức thanh toán',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const Divider(height: AppSizes.lg, color: AppColors.border),
          ...options.map((opt) {
            final isSelected = selectedMethod == opt.id;
            return GestureDetector(
              onTap: () => onMethodSelected(opt.id),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: AppSizes.sm),
                padding: const EdgeInsets.all(AppSizes.md),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withValues(alpha: 0.04)
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSizes.radiusMD),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                    width: isSelected ? 1.5 : 1.0,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                      color: isSelected ? AppColors.primary : AppColors.textSecondary,
                    ),
                    Container(
                      padding: const EdgeInsets.all(AppSizes.xs),
                      decoration: BoxDecoration(
                        color: opt.iconColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppSizes.sm),
                      ),
                      child: Icon(opt.icon, color: opt.iconColor, size: 24),
                    ),
                    const SizedBox(width: AppSizes.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  opt.title,
                                  style: AppTypography.titleSmall.copyWith(
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w600,
                                  ),
                                ),
                              ),
                              if (opt.badgeText != null) ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: opt.iconColor.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    opt.badgeText!,
                                    style: AppTypography.labelSmall.copyWith(
                                      color: opt.iconColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            opt.subtitle,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
