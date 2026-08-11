import '../entities/cart_entity.dart';
import '../entities/cart_item_entity.dart';

/// CartRepository — Interface cho các thao tác quản lý giỏ hàng
abstract class CartRepository {
  /// Lấy giỏ hàng 1 lần
  Future<CartEntity> getCart(String userId);

  /// Theo dõi giỏ hàng realtime từ Firestore
  Stream<CartEntity> watchCart(String userId);

  /// Thêm 1 sản phẩm vào giỏ (nếu trùng productId & color thì tăng số lượng)
  Future<void> addToCart(String userId, CartItemEntity item);

  /// Cập nhật số lượng của 1 mục sản phẩm (nếu quantity <= 0 thì xóa mục đó)
  Future<void> updateQuantity(
    String userId,
    String productId,
    String color,
    int quantity,
  );

  /// Xóa 1 mục sản phẩm khỏi giỏ hàng
  Future<void> removeFromCart(
    String userId,
    String productId,
    String color,
  );

  /// Làm trống toàn bộ giỏ hàng (sau khi đặt hàng thành công)
  Future<void> clearCart(String userId);
}
