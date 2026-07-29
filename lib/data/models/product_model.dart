import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/product_entity.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

/// ProductModel — DTO cho Firestore /products/{productId}
@freezed
abstract class ProductModel with _$ProductModel {
  const factory ProductModel({
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
  }) = _ProductModel;

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  const ProductModel._();

  factory ProductModel.fromFirestore(Map<String, dynamic> data, String id) {
    return ProductModel(
      id: id,
      name: data['name'] as String? ?? '',
      brand: data['brand'] as String? ?? '',
      category: data['category'] as String? ?? '',
      description: data['description'] as String? ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0,
      discountPrice: (data['discountPrice'] as num?)?.toDouble() ?? 0,
      images: (data['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      specs: (data['specs'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, v.toString()),
          ) ??
          {},
      colors: (data['colors'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      stock: (data['stock'] as num?)?.toInt() ?? 0,
      sold: (data['sold'] as num?)?.toInt() ?? 0,
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (data['reviewCount'] as num?)?.toInt() ?? 0,
      tags: (data['tags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      isActive: data['isActive'] as bool? ?? true,
      isFeatured: data['isFeatured'] as bool? ?? false,
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as dynamic).toDate() as DateTime
          : null,
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as dynamic).toDate() as DateTime
          : null,
    );
  }

  Map<String, dynamic> toFirestore() => {
        'name': name,
        'brand': brand,
        'category': category,
        'description': description,
        'price': price,
        'discountPrice': discountPrice,
        'images': images,
        'specs': specs,
        'colors': colors,
        'stock': stock,
        'sold': sold,
        'rating': rating,
        'reviewCount': reviewCount,
        'tags': tags,
        'isActive': isActive,
        'isFeatured': isFeatured,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };

  ProductEntity toEntity() => ProductEntity(
        id: id,
        name: name,
        brand: brand,
        category: category,
        description: description,
        price: price,
        discountPrice: discountPrice,
        images: images,
        specs: specs,
        colors: colors,
        stock: stock,
        sold: sold,
        rating: rating,
        reviewCount: reviewCount,
        tags: tags,
        isActive: isActive,
        isFeatured: isFeatured,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
