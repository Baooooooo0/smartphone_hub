import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/cart_item_entity.dart';

part 'cart_item_model.freezed.dart';
part 'cart_item_model.g.dart';

/// CartItemModel — DTO cho Map phần tử trong list items ở /carts/{userId}
@freezed
abstract class CartItemModel with _$CartItemModel {
  const factory CartItemModel({
    required String productId,
    required String productName,
    required String productImage,
    required String color,
    required double price,
    @Default(0.0) double originalPrice,
    @Default(1) int quantity,
  }) = _CartItemModel;

  factory CartItemModel.fromJson(Map<String, dynamic> json) =>
      _$CartItemModelFromJson(json);

  const CartItemModel._();

  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      productId: map['productId'] as String? ?? '',
      productName: map['productName'] as String? ?? '',
      productImage: map['productImage'] as String? ?? '',
      color: map['color'] as String? ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      originalPrice: (map['originalPrice'] as num?)?.toDouble() ?? 0.0,
      quantity: (map['quantity'] as num?)?.toInt() ?? 1,
    );
  }

  Map<String, dynamic> toMap() => {
        'productId': productId,
        'productName': productName,
        'productImage': productImage,
        'color': color,
        'price': price,
        'originalPrice': originalPrice,
        'quantity': quantity,
      };

  CartItemEntity toEntity() => CartItemEntity(
        productId: productId,
        productName: productName,
        productImage: productImage,
        color: color,
        price: price,
        originalPrice: originalPrice,
        quantity: quantity,
      );

  factory CartItemModel.fromEntity(CartItemEntity entity) => CartItemModel(
        productId: entity.productId,
        productName: entity.productName,
        productImage: entity.productImage,
        color: entity.color,
        price: entity.price,
        originalPrice: entity.originalPrice,
        quantity: entity.quantity,
      );
}
