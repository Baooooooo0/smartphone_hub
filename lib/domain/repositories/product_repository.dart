import 'package:cloud_firestore/cloud_firestore.dart';
import '../entities/product_entity.dart';
import '../entities/product_filter.dart';

/// ProductRepository — Interface thao tác sản phẩm
abstract class ProductRepository {
  /// Sản phẩm nổi bật (isFeatured = true), limit mặc định 10
  Future<List<ProductEntity>> getFeaturedProducts({int limit = 10});

  /// Sản phẩm bán chạy (sort by sold DESC), limit mặc định 10
  Future<List<ProductEntity>> getBestSellers({int limit = 10});

  /// Sản phẩm theo danh mục
  Future<List<ProductEntity>> getProductsByCategory(
    String categoryId, {
    int limit = 20,
  });

  /// Danh sách sản phẩm với filter, sort và cursor pagination (startAfter)
  /// Trả về (items, lastDocument) — lastDocument dùng cho trang tiếp theo
  Future<(List<ProductEntity>, DocumentSnapshot?)> getProducts({
    ProductFilter filter,
    ProductSort sort,
    int pageSize,
    DocumentSnapshot? startAfter,
  });

  /// Chi tiết sản phẩm
  Future<ProductEntity?> getProductById(String productId);

  /// Lấy nhiều sản phẩm theo danh sách ID (cho Recently Viewed)
  Future<List<ProductEntity>> getProductsByIds(List<String> ids);
}
