import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_entity.freezed.dart';

/// ProductEntity — Business entity, không phụ thuộc Firebase
@freezed
abstract class ProductEntity with _$ProductEntity {
  const factory ProductEntity({
    required String id,
    required String name,
    required String brand,
    required String category,
    @Default('') String description,
    required double price,
    @Default(0) double discountPrice,
    @Default([]) List<String> images,
    @Default({}) Map<String, String> specs,
    @Default([]) List<String> colors,
    @Default(0) int stock,
    @Default(0) int sold,
    @Default(0.0) double rating,
    @Default(0) int reviewCount,
    @Default([]) List<String> tags,
    @Default(true) bool isActive,
    @Default(false) bool isFeatured,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ProductEntity;

  const ProductEntity._();

  /// Giá hiển thị: discountPrice nếu có, ngược lại là price
  double get displayPrice => discountPrice > 0 ? discountPrice : price;

  /// Phần trăm giảm giá
  int get discountPercent {
    if (discountPrice <= 0 || price <= 0) return 0;
    return ((1 - discountPrice / price) * 100).round();
  }

  /// Còn hàng
  bool get inStock => stock > 0;

  /// Ảnh chính
  String get mainImage => images.isNotEmpty ? images.first : '';

  /// Có giảm giá không
  bool get hasDiscount => discountPrice > 0 && discountPrice < price;
}
