import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/category_entity.dart';
import '../../../router/app_router.dart';
import '../providers/home_provider.dart';

/// HomeCategoriesSection — Danh mục cuộn ngang
class HomeCategoriesSection extends ConsumerWidget {
  const HomeCategoriesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return categoriesAsync.when(
      loading: () => _CategoriesShimmer(),
      error: (error, stack) => const SizedBox.shrink(),
      data: (categories) {
        if (categories.isEmpty) return const SizedBox.shrink();
        return _CategoriesList(categories: categories);
      },
    );
  }
}

class _CategoriesList extends StatelessWidget {
  final List<CategoryEntity> categories;
  const _CategoriesList({required this.categories});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
          child: Text('Danh mục', style: AppTypography.headlineSmall),
        ),
        const SizedBox(height: AppSizes.md),
        SizedBox(
          height: 90,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
            itemCount: categories.length,
            separatorBuilder: (context, index) => const SizedBox(width: AppSizes.md),
            itemBuilder: (context, index) =>
                _CategoryChip(category: categories[index]),
          ),
        ),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final CategoryEntity category;
  const _CategoryChip({required this.category});

  // Fallback icon dựa trên tên danh mục
  IconData _iconFor(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('iphone') || lower.contains('apple')) return Icons.phone_iphone;
    if (lower.contains('samsung')) return Icons.smartphone;
    if (lower.contains('xiaomi') || lower.contains('redmi')) return Icons.phone_android;
    if (lower.contains('tablet') || lower.contains('ipad')) return Icons.tablet_android;
    if (lower.contains('phụ kiện') || lower.contains('accessory')) return Icons.cable;
    if (lower.contains('tai nghe') || lower.contains('headphone')) return Icons.headphones;
    if (lower.contains('sạc') || lower.contains('charger')) return Icons.battery_charging_full;
    return Icons.devices_other;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final title = Uri.encodeComponent(category.name);
        context.push('${AppRoutes.productList}?category=${category.id}&title=$title');
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.primarySurface,
              borderRadius: BorderRadius.circular(AppSizes.radiusLG),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.12),
                width: 1,
              ),
            ),
            child: category.iconURL.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(AppSizes.radiusLG),
                    child: Image.network(
                      category.iconURL,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stack) => Icon(
                        _iconFor(category.name),
                        color: AppColors.primary,
                        size: AppSizes.iconMD,
                      ),
                    ),
                  )
                : Icon(
                    _iconFor(category.name),
                    color: AppColors.primary,
                    size: AppSizes.iconMD,
                  ),
          ),
          const SizedBox(height: AppSizes.xs),
          SizedBox(
            width: 64,
            child: Text(
              category.name,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoriesShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
          child: Shimmer.fromColors(
            baseColor: AppColors.surfaceVariant,
            highlightColor: AppColors.surface,
            child: Container(
              width: 80,
              height: 18,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(AppSizes.radiusSM),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSizes.md),
        SizedBox(
          height: 90,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
            itemCount: 5,
            separatorBuilder: (context, index) => const SizedBox(width: AppSizes.md),
            itemBuilder: (context, index) => Shimmer.fromColors(
              baseColor: AppColors.surfaceVariant,
              highlightColor: AppColors.surface,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(AppSizes.radiusLG),
                    ),
                  ),
                  const SizedBox(height: AppSizes.xs),
                  Container(
                    width: 48,
                    height: 12,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(AppSizes.radiusXS),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
