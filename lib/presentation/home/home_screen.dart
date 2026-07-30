import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/seed_data.dart';
import '../../router/app_router.dart';
import 'providers/home_provider.dart';
import 'widgets/home_banner_carousel.dart';
import 'widgets/home_categories_section.dart';
import 'widgets/home_product_section.dart';

/// HomeScreen — Màn hình trang chủ của SmartphoneHub
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () async {
          // Refresh tất cả providers
          ref.invalidate(bannersProvider);
          ref.invalidate(categoriesProvider);
          ref.invalidate(featuredProductsProvider);
          ref.invalidate(bestSellersProvider);
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // ── AppBar ─────────────────────────────────────────────
            _HomeAppBar(),
            // ── Body ───────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSizes.lg),

                  // Banner Carousel
                  FadeInDown(
                    duration: const Duration(milliseconds: 400),
                    child: const HomeBannerCarousel(),
                  ),
                  const SizedBox(height: AppSizes.xxl),

                  // Categories
                  FadeInUp(
                    duration: const Duration(milliseconds: 450),
                    delay: const Duration(milliseconds: 100),
                    child: const HomeCategoriesSection(),
                  ),
                  const SizedBox(height: AppSizes.xxl),

                  // Featured Products
                  FadeInUp(
                    duration: const Duration(milliseconds: 450),
                    delay: const Duration(milliseconds: 200),
                    child: HomeProductSection(
                      title: '🔥 Sản phẩm nổi bật',
                      asyncProducts: ref.watch(featuredProductsProvider),
                      seeAllRoute: AppRoutes.productList,
                    ),
                  ),
                  const SizedBox(height: AppSizes.xxl),

                  // Best Sellers
                  FadeInUp(
                    duration: const Duration(milliseconds: 450),
                    delay: const Duration(milliseconds: 300),
                    child: HomeProductSection(
                      title: '🏆 Bán chạy nhất',
                      asyncProducts: ref.watch(bestSellersProvider),
                      seeAllRoute: AppRoutes.productList,
                    ),
                  ),

                  // Bottom padding (above nav bar)
                  const SizedBox(height: AppSizes.xxxl),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── AppBar ───────────────────────────────────────────────────────────────────
class _HomeAppBar extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverAppBar(
      floating: true,
      snap: true,
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 1,
      title: Row(
        children: [
          // Logo
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(AppSizes.radiusSM),
            ),
            child: const Icon(Icons.phone_android, color: Colors.white, size: 18),
          ),
          const SizedBox(width: AppSizes.sm),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Smartphone',
                  style: AppTypography.headlineSmall.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text: 'Hub',
                  style: AppTypography.headlineSmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        // Seed Data icon
        IconButton(
          icon: const Icon(
            Icons.cloud_upload_outlined,
            color: AppColors.primary,
          ),
          tooltip: 'Nạp dữ liệu mẫu (Seed Data)',
          onPressed: () async {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('⏳ Đang nạp 20+ sản phẩm mẫu vào Firestore...'),
                duration: Duration(seconds: 3),
              ),
            );
            try {
              await SeedDataRunner.runSeed();
              ref.invalidate(bannersProvider);
              ref.invalidate(categoriesProvider);
              ref.invalidate(featuredProductsProvider);
              ref.invalidate(bestSellersProvider);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('🎉 Nạp dữ liệu thành công! Hãy kéo xuống để làm mới.'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Lỗi nạp dữ liệu: $e'),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            }
          },
        ),
        // Search icon
        IconButton(
          icon: const Icon(Icons.search_outlined, color: AppColors.textPrimary),
          onPressed: () => context.go(AppRoutes.search),
        ),
        // Notification icon
        IconButton(
          icon: const Icon(
            Icons.notifications_outlined,
            color: AppColors.textPrimary,
          ),
          onPressed: () => context.push(AppRoutes.notifications),
        ),
        const SizedBox(width: AppSizes.xs),
      ],
    );
  }
}
