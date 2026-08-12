import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../router/app_router.dart';
import '../../widgets/primary_button.dart';

/// CartEmptyView — Giao diện hiển thị khi giỏ hàng chưa có sản phẩm
class CartEmptyView extends StatelessWidget {
  const CartEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: AppColors.primarySurface,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.remove_shopping_cart_rounded,
                size: 54,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppSizes.lg),
            Text(
              'Giỏ hàng của bạn đang trống',
              textAlign: TextAlign.center,
              style: AppTypography.headlineSmall.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSizes.xs),
            Text(
              'Hãy chọn thêm các sản phẩm điện thoại flagship tuyệt vời vào giỏ nhé!',
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSizes.xxl),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 280),
              child: PrimaryButton(
                label: 'Khám phá sản phẩm ngay',
                onPressed: () => context.go(AppRoutes.home),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
