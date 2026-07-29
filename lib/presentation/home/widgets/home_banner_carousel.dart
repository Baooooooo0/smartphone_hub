import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../domain/entities/banner_entity.dart';
import '../providers/home_provider.dart';

/// HomeBannerCarousel — Banner carousel với smooth page indicator
class HomeBannerCarousel extends ConsumerStatefulWidget {
  const HomeBannerCarousel({super.key});

  @override
  ConsumerState<HomeBannerCarousel> createState() => _HomeBannerCarouselState();
}

class _HomeBannerCarouselState extends ConsumerState<HomeBannerCarousel> {
  int _currentIndex = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    final bannersAsync = ref.watch(bannersProvider);

    return bannersAsync.when(
      loading: () => _BannerShimmer(),
      error: (error, stack) => _BannerPlaceholder(),
      data: (banners) {
        if (banners.isEmpty) return _BannerPlaceholder();
        return Column(
          children: [
            CarouselSlider.builder(
              carouselController: _controller,
              itemCount: banners.length,
              options: CarouselOptions(
                height: AppSizes.bannerHeight,
                viewportFraction: 1.0,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 4),
                autoPlayAnimationDuration: const Duration(milliseconds: 600),
                autoPlayCurve: Curves.fastOutSlowIn,
                onPageChanged: (index, _) =>
                    setState(() => _currentIndex = index),
              ),
              itemBuilder: (context, index, realIndex) =>
                  _BannerItem(banner: banners[index]),
            ),
            const SizedBox(height: AppSizes.sm),
            AnimatedSmoothIndicator(
              activeIndex: _currentIndex,
              count: banners.length,
              effect: ExpandingDotsEffect(
                dotHeight: 6,
                dotWidth: 6,
                activeDotColor: AppColors.primary,
                dotColor: AppColors.primary.withValues(alpha: 0.25),
                expansionFactor: 3,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _BannerItem extends StatelessWidget {
  final BannerEntity banner;
  const _BannerItem({required this.banner});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.radiusLG),
        child: banner.imageURL.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: banner.imageURL,
                width: double.infinity,
                height: AppSizes.bannerHeight,
                fit: BoxFit.cover,
                placeholder: (context, url) => _BannerShimmer(),
                errorWidget: (context, url, error) => _BannerPlaceholder(),
              )
            : _BannerPlaceholder(),
      ),
    );
  }
}

class _BannerShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
      child: Shimmer.fromColors(
        baseColor: AppColors.surfaceVariant,
        highlightColor: AppColors.surface,
        child: Container(
          height: AppSizes.bannerHeight,
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(AppSizes.radiusLG),
          ),
        ),
      ),
    );
  }
}

class _BannerPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
      child: Container(
        height: AppSizes.bannerHeight,
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(AppSizes.radiusLG),
        ),
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.phone_android, size: 48, color: Colors.white70),
              SizedBox(height: 8),
              Text(
                'SmartphoneHub',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Điện thoại chính hãng – Giá tốt nhất',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
