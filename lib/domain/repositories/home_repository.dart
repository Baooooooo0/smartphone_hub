import '../entities/banner_entity.dart';
import '../entities/category_entity.dart';

/// HomeRepository — Interface fetch dữ liệu trang chủ
abstract class HomeRepository {
  /// Lấy danh sách banner đang active, sắp xếp theo order
  Future<List<BannerEntity>> getBanners();

  /// Lấy danh sách danh mục, sắp xếp theo order
  Future<List<CategoryEntity>> getCategories();
}
