// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(homeRepository)
final homeRepositoryProvider = HomeRepositoryProvider._();

final class HomeRepositoryProvider
    extends $FunctionalProvider<HomeRepository, HomeRepository, HomeRepository>
    with $Provider<HomeRepository> {
  HomeRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeRepositoryHash();

  @$internal
  @override
  $ProviderElement<HomeRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  HomeRepository create(Ref ref) {
    return homeRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HomeRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HomeRepository>(value),
    );
  }
}

String _$homeRepositoryHash() => r'5105d29e9893b114b170b4c71c1baf2c802d8d46';

@ProviderFor(productRepository)
final productRepositoryProvider = ProductRepositoryProvider._();

final class ProductRepositoryProvider
    extends
        $FunctionalProvider<
          ProductRepository,
          ProductRepository,
          ProductRepository
        >
    with $Provider<ProductRepository> {
  ProductRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'productRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$productRepositoryHash();

  @$internal
  @override
  $ProviderElement<ProductRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProductRepository create(Ref ref) {
    return productRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProductRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProductRepository>(value),
    );
  }
}

String _$productRepositoryHash() => r'31b704ed91e89e99489570a75d007ddad68dd5ec';

/// Banners cho carousel trang chủ

@ProviderFor(banners)
final bannersProvider = BannersProvider._();

/// Banners cho carousel trang chủ

final class BannersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<BannerEntity>>,
          List<BannerEntity>,
          FutureOr<List<BannerEntity>>
        >
    with
        $FutureModifier<List<BannerEntity>>,
        $FutureProvider<List<BannerEntity>> {
  /// Banners cho carousel trang chủ
  BannersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bannersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bannersHash();

  @$internal
  @override
  $FutureProviderElement<List<BannerEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<BannerEntity>> create(Ref ref) {
    return banners(ref);
  }
}

String _$bannersHash() => r'83b58630a6b2a87d7d004977973e245bfdfa8ecb';

/// Danh mục sản phẩm

@ProviderFor(categories)
final categoriesProvider = CategoriesProvider._();

/// Danh mục sản phẩm

final class CategoriesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CategoryEntity>>,
          List<CategoryEntity>,
          FutureOr<List<CategoryEntity>>
        >
    with
        $FutureModifier<List<CategoryEntity>>,
        $FutureProvider<List<CategoryEntity>> {
  /// Danh mục sản phẩm
  CategoriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoriesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoriesHash();

  @$internal
  @override
  $FutureProviderElement<List<CategoryEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<CategoryEntity>> create(Ref ref) {
    return categories(ref);
  }
}

String _$categoriesHash() => r'b52e1548b610231ef161dbc293c42771276ab1f7';

/// Sản phẩm nổi bật

@ProviderFor(featuredProducts)
final featuredProductsProvider = FeaturedProductsProvider._();

/// Sản phẩm nổi bật

final class FeaturedProductsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ProductEntity>>,
          List<ProductEntity>,
          FutureOr<List<ProductEntity>>
        >
    with
        $FutureModifier<List<ProductEntity>>,
        $FutureProvider<List<ProductEntity>> {
  /// Sản phẩm nổi bật
  FeaturedProductsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'featuredProductsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$featuredProductsHash();

  @$internal
  @override
  $FutureProviderElement<List<ProductEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ProductEntity>> create(Ref ref) {
    return featuredProducts(ref);
  }
}

String _$featuredProductsHash() => r'c9c8f53292bfd7f05038d8ca902a990fedf7e756';

/// Sản phẩm bán chạy

@ProviderFor(bestSellers)
final bestSellersProvider = BestSellersProvider._();

/// Sản phẩm bán chạy

final class BestSellersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ProductEntity>>,
          List<ProductEntity>,
          FutureOr<List<ProductEntity>>
        >
    with
        $FutureModifier<List<ProductEntity>>,
        $FutureProvider<List<ProductEntity>> {
  /// Sản phẩm bán chạy
  BestSellersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bestSellersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bestSellersHash();

  @$internal
  @override
  $FutureProviderElement<List<ProductEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ProductEntity>> create(Ref ref) {
    return bestSellers(ref);
  }
}

String _$bestSellersHash() => r'9eb63f37a5676d3722c8d600f2002b2d22c890ee';
