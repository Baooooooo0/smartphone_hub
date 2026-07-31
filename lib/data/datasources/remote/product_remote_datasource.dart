import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../domain/entities/product_filter.dart';
import '../../models/product_model.dart';

/// ProductRemoteDataSource — Fetch sản phẩm từ Firestore
class ProductRemoteDataSource {
  final FirebaseFirestore _firestore;

  ProductRemoteDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // ─── Sản phẩm nổi bật ──────────────────────────────────────────────────────
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

  // ─── Sản phẩm bán chạy ─────────────────────────────────────────────────────
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

  // ─── Sản phẩm theo danh mục ────────────────────────────────────────────────
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

  // ─── Danh sách sản phẩm với filter + sort + pagination ─────────────────────
  /// Trả về (items, lastDocument) để dùng cho startAfter cursor pagination.
  Future<(List<ProductModel>, DocumentSnapshot?)> getProducts({
    ProductFilter filter = const ProductFilter(),
    ProductSort sort = ProductSort.newest,
    int pageSize = 20,
    DocumentSnapshot? startAfter,
  }) async {
    Query<Map<String, dynamic>> query = _firestore
        .collection('products')
        .where('isActive', isEqualTo: true);

    // Áp dụng filter
    if (filter.categoryId != null && filter.categoryId!.isNotEmpty) {
      query = query.where('category', isEqualTo: filter.categoryId);
    }
    if (filter.brand != null && filter.brand!.isNotEmpty) {
      query = query.where('brand', isEqualTo: filter.brand);
    }
    // Lưu ý: minPrice / maxPrice filter cần composite index
    // Chỉ áp dụng khi cùng 1 field; mix nhiều range filter cần thực hiện client-side
    if (filter.minPrice != null) {
      query = query.where('discountPrice', isGreaterThanOrEqualTo: filter.minPrice);
    }
    if (filter.maxPrice != null) {
      query = query.where('discountPrice', isLessThanOrEqualTo: filter.maxPrice);
    }

    // Áp dụng sort
    switch (sort) {
      case ProductSort.newest:
        query = query.orderBy('createdAt', descending: true);
      case ProductSort.priceAsc:
        query = query.orderBy('discountPrice').orderBy('price');
      case ProductSort.priceDesc:
        query = query.orderBy('discountPrice', descending: true).orderBy('price', descending: true);
      case ProductSort.rating:
        query = query.orderBy('rating', descending: true);
      case ProductSort.bestSelling:
        query = query.orderBy('sold', descending: true);
    }

    // Áp dụng cursor pagination (startAfter)
    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }

    query = query.limit(pageSize);

    final snapshot = await query.get();
    final docs = snapshot.docs;
    final items = docs.map((doc) => ProductModel.fromFirestore(doc.data(), doc.id)).toList();
    final lastDoc = docs.isNotEmpty ? docs.last : null;

    return (items, lastDoc);
  }

  // ─── Chi tiết 1 sản phẩm ───────────────────────────────────────────────────
  Future<ProductModel?> getProductById(String productId) async {
    final doc = await _firestore.collection('products').doc(productId).get();
    if (!doc.exists || doc.data() == null) return null;
    return ProductModel.fromFirestore(doc.data()!, doc.id);
  }

  // ─── Nhiều sản phẩm theo ID (Recently Viewed, max 30 mỗi chunk) ────────────
  Future<List<ProductModel>> getProductsByIds(List<String> ids) async {
    if (ids.isEmpty) return [];
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
