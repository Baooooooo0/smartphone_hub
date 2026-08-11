import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/cart_item_model.dart';
import '../../models/cart_model.dart';

/// CartRemoteDataSource — Tương tác trực tiếp với Firestore /carts/{userId}
class CartRemoteDataSource {
  final FirebaseFirestore _firestore;

  CartRemoteDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _cartsRef =>
      _firestore.collection('carts');

  /// Lấy giỏ hàng 1 lần
  Future<CartModel> getCart(String userId) async {
    final doc = await _cartsRef.doc(userId).get();
    if (!doc.exists || doc.data() == null) {
      return CartModel(userId: userId, items: []);
    }
    return CartModel.fromFirestore(doc.data()!, userId);
  }

  /// Theo dõi giỏ hàng realtime
  Stream<CartModel> watchCart(String userId) {
    return _cartsRef.doc(userId).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) {
        return CartModel(userId: userId, items: []);
      }
      return CartModel.fromFirestore(doc.data()!, userId);
    });
  }

  /// Cập nhật toàn bộ giỏ hàng
  Future<void> saveCart(CartModel cart) async {
    await _cartsRef.doc(cart.userId).set(
          cart.toFirestore(),
          SetOptions(merge: true),
        );
  }

  /// Thêm 1 sản phẩm vào giỏ
  Future<void> addToCart(String userId, CartItemModel newItem) async {
    final currentCart = await getCart(userId);
    final items = List<CartItemModel>.from(currentCart.items);

    final existingIndex = items.indexWhere(
      (item) => item.productId == newItem.productId && item.color == newItem.color,
    );

    if (existingIndex >= 0) {
      final existingItem = items[existingIndex];
      items[existingIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + newItem.quantity,
      );
    } else {
      items.add(newItem);
    }

    final updatedCart = CartModel(
      userId: userId,
      items: items,
      updatedAt: DateTime.now(),
    );

    await saveCart(updatedCart);
  }

  /// Cập nhật số lượng
  Future<void> updateQuantity(
    String userId,
    String productId,
    String color,
    int quantity,
  ) async {
    final currentCart = await getCart(userId);
    final items = List<CartItemModel>.from(currentCart.items);

    if (quantity <= 0) {
      items.removeWhere(
        (item) => item.productId == productId && item.color == color,
      );
    } else {
      final index = items.indexWhere(
        (item) => item.productId == productId && item.color == color,
      );
      if (index >= 0) {
        items[index] = items[index].copyWith(quantity: quantity);
      }
    }

    final updatedCart = CartModel(
      userId: userId,
      items: items,
      updatedAt: DateTime.now(),
    );

    await saveCart(updatedCart);
  }

  /// Xóa 1 mục khỏi giỏ hàng
  Future<void> removeFromCart(
    String userId,
    String productId,
    String color,
  ) async {
    await updateQuantity(userId, productId, color, 0);
  }

  /// Xóa toàn bộ giỏ hàng
  Future<void> clearCart(String userId) async {
    final updatedCart = CartModel(
      userId: userId,
      items: [],
      updatedAt: DateTime.now(),
    );
    await saveCart(updatedCart);
  }
}
