import '../../domain/entities/banner_entity.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/remote/home_remote_datasource.dart';

/// HomeRepositoryImpl — Implementation của HomeRepository
class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource _remoteDataSource;

  HomeRepositoryImpl({HomeRemoteDataSource? remoteDataSource})
      : _remoteDataSource = remoteDataSource ?? HomeRemoteDataSource();

  @override
  Future<List<BannerEntity>> getBanners() async {
    final models = await _remoteDataSource.getBanners();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<CategoryEntity>> getCategories() async {
    final models = await _remoteDataSource.getCategories();
    return models.map((m) => m.toEntity()).toList();
  }
}
