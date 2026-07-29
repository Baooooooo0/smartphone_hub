import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/product_model.dart';

/// ProductRemoteDataSource — Fetch sản phẩm từ Firestore
class ProductRemoteDataSource {
  final FirebaseFirestore _firestore;

  ProductRemoteDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Sản phẩm nổi bật (isFeatured = true, isActive = true)
  Future<List<ProductModel>> getFeaturedProducts({int limit = 10}) async {
    final snapshot = await _firestore
        .collection('products')
        .where('isActive', isEqualTo: true)
        .where('isFeatured', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .get();

    return snapshot.docs
        .map((doc) => ProductModel.fromFirestore(doc.data(), doc.id))
        .toList();
  }

  /// Sản phẩm bán chạy nhất (sort by sold DESC)
  Future<List<ProductModel>> getBestSellers({int limit = 10}) async {
    final snapshot = await _firestore
        .collection('products')
        .where('isActive', isEqualTo: true)
        .orderBy('sold', descending: true)
        .limit(limit)
        .get();

    return snapshot.docs
        .map((doc) => ProductModel.fromFirestore(doc.data(), doc.id))
        .toList();
  }

  /// Sản phẩm theo danh mục
  Future<List<ProductModel>> getProductsByCategory(
    String categoryId, {
    int limit = 20,
  }) async {
    final snapshot = await _firestore
        .collection('products')
        .where('isActive', isEqualTo: true)
        .where('category', isEqualTo: categoryId)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .get();

    return snapshot.docs
        .map((doc) => ProductModel.fromFirestore(doc.data(), doc.id))
        .toList();
  }

  /// Chi tiết 1 sản phẩm
  Future<ProductModel?> getProductById(String productId) async {
    final doc = await _firestore.collection('products').doc(productId).get();
    if (!doc.exists || doc.data() == null) return null;
    return ProductModel.fromFirestore(doc.data()!, doc.id);
  }

  /// Nhiều sản phẩm theo danh sách ID (cho Recently Viewed, max 10)
  Future<List<ProductModel>> getProductsByIds(List<String> ids) async {
    if (ids.isEmpty) return [];
    // Firestore whereIn max 30 items
    final chunks = <List<String>>[];
    for (var i = 0; i < ids.length; i += 30) {
      chunks.add(ids.sublist(i, i + 30 > ids.length ? ids.length : i + 30));
    }
    final results = <ProductModel>[];
    for (final chunk in chunks) {
      final snapshot = await _firestore
          .collection('products')
          .where(FieldPath.documentId, whereIn: chunk)
          .get();
      results.addAll(
        snapshot.docs.map((doc) => ProductModel.fromFirestore(doc.data(), doc.id)),
      );
    }
    return results;
  }
}
