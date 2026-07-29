import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/remote/product_remote_datasource.dart';

/// ProductRepositoryImpl — Implementation của ProductRepository
class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource _remoteDataSource;

  ProductRepositoryImpl({ProductRemoteDataSource? remoteDataSource})
      : _remoteDataSource = remoteDataSource ?? ProductRemoteDataSource();

  @override
  Future<List<ProductEntity>> getFeaturedProducts({int limit = 10}) async {
    final models = await _remoteDataSource.getFeaturedProducts(limit: limit);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<ProductEntity>> getBestSellers({int limit = 10}) async {
    final models = await _remoteDataSource.getBestSellers(limit: limit);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<ProductEntity>> getProductsByCategory(
    String categoryId, {
    int limit = 20,
  }) async {
    final models = await _remoteDataSource.getProductsByCategory(
      categoryId,
      limit: limit,
    );
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<ProductEntity?> getProductById(String productId) async {
    final model = await _remoteDataSource.getProductById(productId);
    return model?.toEntity();
  }

  @override
  Future<List<ProductEntity>> getProductsByIds(List<String> ids) async {
    final models = await _remoteDataSource.getProductsByIds(ids);
    return models.map((m) => m.toEntity()).toList();
  }
}
