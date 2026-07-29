import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/repositories/home_repository_impl.dart';
import '../../../data/repositories/product_repository_impl.dart';
import '../../../domain/entities/banner_entity.dart';
import '../../../domain/entities/category_entity.dart';
import '../../../domain/entities/product_entity.dart';
import '../../../domain/repositories/home_repository.dart';
import '../../../domain/repositories/product_repository.dart';

part 'home_provider.g.dart';

// ─── Repository Providers ─────────────────────────────────────────────────────

@riverpod
HomeRepository homeRepository(Ref ref) => HomeRepositoryImpl();

@riverpod
ProductRepository productRepository(Ref ref) => ProductRepositoryImpl();

// ─── Data Providers ───────────────────────────────────────────────────────────

/// Banners cho carousel trang chủ
@riverpod
Future<List<BannerEntity>> banners(Ref ref) async {
  return ref.watch(homeRepositoryProvider).getBanners();
}

/// Danh mục sản phẩm
@riverpod
Future<List<CategoryEntity>> categories(Ref ref) async {
  return ref.watch(homeRepositoryProvider).getCategories();
}

/// Sản phẩm nổi bật
@riverpod
Future<List<ProductEntity>> featuredProducts(Ref ref) async {
  return ref.watch(productRepositoryProvider).getFeaturedProducts(limit: 10);
}

/// Sản phẩm bán chạy
@riverpod
Future<List<ProductEntity>> bestSellers(Ref ref) async {
  return ref.watch(productRepositoryProvider).getBestSellers(limit: 10);
}
