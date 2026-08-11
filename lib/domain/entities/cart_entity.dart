import 'package:freezed_annotation/freezed_annotation.dart';
import 'cart_item_entity.dart';

part 'cart_entity.freezed.dart';

/// CartEntity — Business domain đại diện cho toàn bộ giỏ hàng người dùng
@freezed
abstract class CartEntity with _$CartEntity {
  const factory CartEntity({
    required String userId,
    @Default([]) List<CartItemEntity> items,
    DateTime? updatedAt,
  }) = _CartEntity;

  const CartEntity._();

  /// Tổng số lượng tất cả sản phẩm trong giỏ
  int get totalQuantity => items.fold(0, (sum, item) => sum + item.quantity);

  /// Tổng tiền trước giảm giá hoặc chưa voucher
  double get subtotalPrice => items.fold(0.0, (sum, item) => sum + item.totalPrice);

  /// Giỏ hàng trống hay không
  bool get isEmpty => items.isEmpty;

  /// Giỏ hàng có sản phẩm hay không
  bool get isNotEmpty => items.isNotEmpty;
}
