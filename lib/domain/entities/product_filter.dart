/// ProductFilter — Bộ lọc sản phẩm
class ProductFilter {
  final String? categoryId;
  final String? brand;
  final double? minPrice;
  final double? maxPrice;
  final double? minRating;

  const ProductFilter({
    this.categoryId,
    this.brand,
    this.minPrice,
    this.maxPrice,
    this.minRating,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProductFilter &&
        other.categoryId == categoryId &&
        other.brand == brand &&
        other.minPrice == minPrice &&
        other.maxPrice == maxPrice &&
        other.minRating == minRating;
  }

  @override
  int get hashCode =>
      Object.hash(categoryId, brand, minPrice, maxPrice, minRating);
}

/// ProductSort — Tiêu chí sắp xếp sản phẩm
enum ProductSort {
  /// Mới nhất (createdAt DESC)
  newest,

  /// Giá thấp → cao
  priceAsc,

  /// Giá cao → thấp
  priceDesc,

  /// Đánh giá cao nhất
  rating,

  /// Bán chạy nhất
  bestSelling,
}
