import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart_item_entity.freezed.dart';

/// CartItemEntity — Business domain representation cho 1 mục sản phẩm trong giỏ hàng
@freezed
abstract class CartItemEntity with _$CartItemEntity {
  const factory CartItemEntity({
    required String productId,
    required String productName,
    required String productImage,
    required String color,
    required double price,
    @Default(0.0) double originalPrice,
    @Default(1) int quantity,
  }) = _CartItemEntity;

  const CartItemEntity._();

  /// Tổng tiền cho mục này (giá x số lượng)
  double get totalPrice => price * quantity;

  /// Đã giảm giá hay chưa
  bool get hasDiscount => originalPrice > price && price > 0;
}
