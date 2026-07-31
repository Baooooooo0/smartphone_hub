// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_usecases.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

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

String _$productRepositoryHash() => r'73d91eaf132d51f49c932f42c800e2c30cfeefbe';

@ProviderFor(getFeaturedProducts)
final getFeaturedProductsProvider = GetFeaturedProductsFamily._();

final class GetFeaturedProductsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ProductEntity>>,
          List<ProductEntity>,
          FutureOr<List<ProductEntity>>
        >
    with
        $FutureModifier<List<ProductEntity>>,
        $FutureProvider<List<ProductEntity>> {
  GetFeaturedProductsProvider._({
    required GetFeaturedProductsFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'getFeaturedProductsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getFeaturedProductsHash();

  @override
  String toString() {
    return r'getFeaturedProductsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<ProductEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ProductEntity>> create(Ref ref) {
    final argument = this.argument as int;
    return getFeaturedProducts(ref, limit: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GetFeaturedProductsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getFeaturedProductsHash() =>
    r'b3aa31871addd2d9e5c5fd8b55041947fc5b9acb';

final class GetFeaturedProductsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<ProductEntity>>, int> {
  GetFeaturedProductsFamily._()
    : super(
        retry: null,
        name: r'getFeaturedProductsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GetFeaturedProductsProvider call({int limit = 10}) =>
      GetFeaturedProductsProvider._(argument: limit, from: this);

  @override
  String toString() => r'getFeaturedProductsProvider';
}

@ProviderFor(getBestSellers)
final getBestSellersProvider = GetBestSellersFamily._();

final class GetBestSellersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ProductEntity>>,
          List<ProductEntity>,
          FutureOr<List<ProductEntity>>
        >
    with
        $FutureModifier<List<ProductEntity>>,
        $FutureProvider<List<ProductEntity>> {
  GetBestSellersProvider._({
    required GetBestSellersFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'getBestSellersProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getBestSellersHash();

  @override
  String toString() {
    return r'getBestSellersProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<ProductEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ProductEntity>> create(Ref ref) {
    final argument = this.argument as int;
    return getBestSellers(ref, limit: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GetBestSellersProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getBestSellersHash() => r'335431a6b263cd07c471b85d93af3a278324901e';

final class GetBestSellersFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<ProductEntity>>, int> {
  GetBestSellersFamily._()
    : super(
        retry: null,
        name: r'getBestSellersProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GetBestSellersProvider call({int limit = 10}) =>
      GetBestSellersProvider._(argument: limit, from: this);

  @override
  String toString() => r'getBestSellersProvider';
}

@ProviderFor(getProductsByCategory)
final getProductsByCategoryProvider = GetProductsByCategoryFamily._();

final class GetProductsByCategoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ProductEntity>>,
          List<ProductEntity>,
          FutureOr<List<ProductEntity>>
        >
    with
        $FutureModifier<List<ProductEntity>>,
        $FutureProvider<List<ProductEntity>> {
  GetProductsByCategoryProvider._({
    required GetProductsByCategoryFamily super.from,
    required ({String categoryId, int limit}) super.argument,
  }) : super(
         retry: null,
         name: r'getProductsByCategoryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getProductsByCategoryHash();

  @override
  String toString() {
    return r'getProductsByCategoryProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<ProductEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ProductEntity>> create(Ref ref) {
    final argument = this.argument as ({String categoryId, int limit});
    return getProductsByCategory(
      ref,
      categoryId: argument.categoryId,
      limit: argument.limit,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GetProductsByCategoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getProductsByCategoryHash() =>
    r'00e78219151b30f3fb2d453e25a0594473222c35';

final class GetProductsByCategoryFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<ProductEntity>>,
          ({String categoryId, int limit})
        > {
  GetProductsByCategoryFamily._()
    : super(
        retry: null,
        name: r'getProductsByCategoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GetProductsByCategoryProvider call({
    required String categoryId,
    int limit = 20,
  }) => GetProductsByCategoryProvider._(
    argument: (categoryId: categoryId, limit: limit),
    from: this,
  );

  @override
  String toString() => r'getProductsByCategoryProvider';
}

@ProviderFor(getProductById)
final getProductByIdProvider = GetProductByIdFamily._();

final class GetProductByIdProvider
    extends
        $FunctionalProvider<
          AsyncValue<ProductEntity?>,
          ProductEntity?,
          FutureOr<ProductEntity?>
        >
    with $FutureModifier<ProductEntity?>, $FutureProvider<ProductEntity?> {
  GetProductByIdProvider._({
    required GetProductByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'getProductByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getProductByIdHash();

  @override
  String toString() {
    return r'getProductByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<ProductEntity?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ProductEntity?> create(Ref ref) {
    final argument = this.argument as String;
    return getProductById(ref, productId: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GetProductByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getProductByIdHash() => r'7f2e5bf7d7560bc2f4cfc1ed55bec84dd489b1bf';

final class GetProductByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ProductEntity?>, String> {
  GetProductByIdFamily._()
    : super(
        retry: null,
        name: r'getProductByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GetProductByIdProvider call({required String productId}) =>
      GetProductByIdProvider._(argument: productId, from: this);

  @override
  String toString() => r'getProductByIdProvider';
}

/// Trả về trang đầu tiên. Các trang tiếp theo dùng ProductListNotifier.

@ProviderFor(getProducts)
final getProductsProvider = GetProductsFamily._();

/// Trả về trang đầu tiên. Các trang tiếp theo dùng ProductListNotifier.

final class GetProductsProvider
    extends
        $FunctionalProvider<
          AsyncValue<ProductPage>,
          ProductPage,
          FutureOr<ProductPage>
        >
    with $FutureModifier<ProductPage>, $FutureProvider<ProductPage> {
  /// Trả về trang đầu tiên. Các trang tiếp theo dùng ProductListNotifier.
  GetProductsProvider._({
    required GetProductsFamily super.from,
    required ({
      ProductFilter filter,
      ProductSort sort,
      int pageSize,
      DocumentSnapshot<Object?>? startAfter,
    })
    super.argument,
  }) : super(
         retry: null,
         name: r'getProductsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getProductsHash();

  @override
  String toString() {
    return r'getProductsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<ProductPage> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ProductPage> create(Ref ref) {
    final argument =
        this.argument
            as ({
              ProductFilter filter,
              ProductSort sort,
              int pageSize,
              DocumentSnapshot<Object?>? startAfter,
            });
    return getProducts(
      ref,
      filter: argument.filter,
      sort: argument.sort,
      pageSize: argument.pageSize,
      startAfter: argument.startAfter,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GetProductsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getProductsHash() => r'd582b7edfdc75dd0d53c426be4e1ebec10723f60';

/// Trả về trang đầu tiên. Các trang tiếp theo dùng ProductListNotifier.

final class GetProductsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<ProductPage>,
          ({
            ProductFilter filter,
            ProductSort sort,
            int pageSize,
            DocumentSnapshot<Object?>? startAfter,
          })
        > {
  GetProductsFamily._()
    : super(
        retry: null,
        name: r'getProductsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Trả về trang đầu tiên. Các trang tiếp theo dùng ProductListNotifier.

  GetProductsProvider call({
    ProductFilter filter = const ProductFilter(),
    ProductSort sort = ProductSort.newest,
    int pageSize = 20,
    DocumentSnapshot<Object?>? startAfter,
  }) => GetProductsProvider._(
    argument: (
      filter: filter,
      sort: sort,
      pageSize: pageSize,
      startAfter: startAfter,
    ),
    from: this,
  );

  @override
  String toString() => r'getProductsProvider';
}

@ProviderFor(ProductListNotifier)
final productListProvider = ProductListNotifierProvider._();

final class ProductListNotifierProvider
    extends $NotifierProvider<ProductListNotifier, ProductListState> {
  ProductListNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'productListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$productListNotifierHash();

  @$internal
  @override
  ProductListNotifier create() => ProductListNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProductListState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProductListState>(value),
    );
  }
}

String _$productListNotifierHash() =>
    r'2aa57ea7ae90db7809013a8b51896a6fdbc66130';

abstract class _$ProductListNotifier extends $Notifier<ProductListState> {
  ProductListState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ProductListState, ProductListState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ProductListState, ProductListState>,
              ProductListState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
