import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../domain/entities/product_entity.dart';
import '../../../domain/entities/product_filter.dart';
import '../../../domain/repositories/product_repository.dart';
import '../../../data/repositories/product_repository_impl.dart';

part 'product_usecases.g.dart';

/// ProductPage — Wrapper cho kết quả phân trang sản phẩm
class ProductPage {
  final List<ProductEntity> products;

  /// Document cursor dùng để fetch trang tiếp theo (null nếu là trang cuối)
  final DocumentSnapshot? lastDocument;

  /// Còn trang tiếp theo không
  final bool hasMore;

  const ProductPage({
    required this.products,
    required this.lastDocument,
    required this.hasMore,
  });
}

// ─── Provider cho ProductRepository ──────────────────────────────────────────
@riverpod
ProductRepository productRepository(Ref ref) {
  return ProductRepositoryImpl();
}

// ─── UseCase: getFeaturedProducts ─────────────────────────────────────────────
@riverpod
Future<List<ProductEntity>> getFeaturedProducts(
  Ref ref, {
  int limit = 10,
}) async {
  final repo = ref.watch(productRepositoryProvider);
  return repo.getFeaturedProducts(limit: limit);
}

// ─── UseCase: getBestSellers ──────────────────────────────────────────────────
@riverpod
Future<List<ProductEntity>> getBestSellers(
  Ref ref, {
  int limit = 10,
}) async {
  final repo = ref.watch(productRepositoryProvider);
  return repo.getBestSellers(limit: limit);
}

// ─── UseCase: getProductsByCategory ──────────────────────────────────────────
@riverpod
Future<List<ProductEntity>> getProductsByCategory(
  Ref ref, {
  required String categoryId,
  int limit = 20,
}) async {
  final repo = ref.watch(productRepositoryProvider);
  return repo.getProductsByCategory(categoryId, limit: limit);
}

// ─── UseCase: getProductById ──────────────────────────────────────────────────
@riverpod
Future<ProductEntity?> getProductById(
  Ref ref, {
  required String productId,
}) async {
  final repo = ref.watch(productRepositoryProvider);
  return repo.getProductById(productId);
}

// ─── UseCase: getProducts (paginated) ────────────────────────────────────────
/// Trả về trang đầu tiên. Các trang tiếp theo dùng ProductListNotifier.
@riverpod
Future<ProductPage> getProducts(
  Ref ref, {
  ProductFilter filter = const ProductFilter(),
  ProductSort sort = ProductSort.newest,
  int pageSize = 20,
  DocumentSnapshot? startAfter,
}) async {
  final repo = ref.watch(productRepositoryProvider);
  final (items, lastDoc) = await repo.getProducts(
    filter: filter,
    sort: sort,
    pageSize: pageSize,
    startAfter: startAfter,
  );
  return ProductPage(
    products: items,
    lastDocument: lastDoc,
    hasMore: items.length == pageSize,
  );
}

// ─── Notifier: ProductListNotifier (pagination + filter + sort) ───────────────
/// State cho màn hình Product List với load-more.
class ProductListState {
  final List<ProductEntity> products;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final String? errorMessage;
  final ProductFilter filter;
  final ProductSort sort;
  final DocumentSnapshot? lastDocument;

  const ProductListState({
    this.products = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.errorMessage,
    this.filter = const ProductFilter(),
    this.sort = ProductSort.newest,
    this.lastDocument,
  });

  ProductListState copyWith({
    List<ProductEntity>? products,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    String? errorMessage,
    ProductFilter? filter,
    ProductSort? sort,
    DocumentSnapshot? lastDocument,
    bool clearError = false,
    bool clearLastDoc = false,
  }) {
    return ProductListState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      filter: filter ?? this.filter,
      sort: sort ?? this.sort,
      lastDocument: clearLastDoc ? null : (lastDocument ?? this.lastDocument),
    );
  }
}

@riverpod
class ProductListNotifier extends _$ProductListNotifier {
  static const _pageSize = 20;

  @override
  ProductListState build() {
    return const ProductListState();
  }

  /// Tải trang đầu tiên (hoặc reset khi thay filter/sort)
  Future<void> load({
    ProductFilter filter = const ProductFilter(),
    ProductSort sort = ProductSort.newest,
  }) async {
    state = ProductListState(
      isLoading: true,
      filter: filter,
      sort: sort,
    );

    try {
      final repo = ref.read(productRepositoryProvider);
      final (items, lastDoc) = await repo.getProducts(
        filter: filter,
        sort: sort,
        pageSize: _pageSize,
      );
      state = state.copyWith(
        products: items,
        isLoading: false,
        hasMore: items.length == _pageSize,
        lastDocument: lastDoc,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Tải thêm trang tiếp theo (load more khi scroll đến cuối)
  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore || state.lastDocument == null) {
      return;
    }

    state = state.copyWith(isLoadingMore: true);

    try {
      final repo = ref.read(productRepositoryProvider);
      final (items, lastDoc) = await repo.getProducts(
        filter: state.filter,
        sort: state.sort,
        pageSize: _pageSize,
        startAfter: state.lastDocument,
      );
      state = state.copyWith(
        products: [...state.products, ...items],
        isLoadingMore: false,
        hasMore: items.length == _pageSize,
        lastDocument: lastDoc,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingMore: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Áp dụng filter mới và tải lại từ đầu
  Future<void> applyFilter(ProductFilter filter) =>
      load(filter: filter, sort: state.sort);

  /// Thay đổi sort và tải lại từ đầu
  Future<void> applySort(ProductSort sort) =>
      load(filter: state.filter, sort: sort);

  /// Xóa filter, quay về mặc định
  Future<void> clearFilter() => load();
}
