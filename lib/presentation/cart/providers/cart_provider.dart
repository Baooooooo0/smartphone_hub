import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/repositories/cart_repository_impl.dart';
import '../../../domain/entities/cart_entity.dart';
import '../../../domain/entities/cart_item_entity.dart';
import '../../../domain/entities/product_entity.dart';
import '../../../domain/repositories/cart_repository.dart';
import '../../../domain/usecases/auth/auth_usecases.dart';

part 'cart_provider.g.dart';

// ─── Repository Provider ──────────────────────────────────────────────────────
@Riverpod(keepAlive: true)
CartRepository cartRepository(Ref ref) {
  return CartRepositoryImpl();
}

// ─── StreamProvider Giỏ hàng Realtime ───────────────────────────────────────
@Riverpod(keepAlive: true)
Stream<CartEntity> cartStream(Ref ref) {
  final user = ref.watch(authStateProvider).asData?.value;
  final userId = user?.id ?? 'guest_user';
  return ref.watch(cartRepositoryProvider).watchCart(userId);
}

// ─── Cart State ──────────────────────────────────────────────────────────────
class CartState {
  final CartEntity cart;
  final String? appliedVoucherCode;
  final double discountAmount;
  final bool isLoading;
  final String? errorMessage;

  const CartState({
    this.cart = const CartEntity(userId: '', items: []),
    this.appliedVoucherCode,
    this.discountAmount = 0.0,
    this.isLoading = false,
    this.errorMessage,
  });

  /// Tổng tiền sản phẩm
  double get subtotal => cart.subtotalPrice;

  /// Phí vận chuyển (Miễn phí nếu đơn > 5 triệu)
  double get shippingFee => (subtotal > 5000000 || subtotal == 0) ? 0.0 : 30000.0;

  /// Tổng thanh toán cuối cùng
  double get totalPrice {
    final total = subtotal + shippingFee - discountAmount;
    return total > 0 ? total : 0.0;
  }

  CartState copyWith({
    CartEntity? cart,
    String? appliedVoucherCode,
    double? discountAmount,
    bool? isLoading,
    String? errorMessage,
    bool clearVoucher = false,
    bool clearError = false,
  }) {
    return CartState(
      cart: cart ?? this.cart,
      appliedVoucherCode:
          clearVoucher ? null : (appliedVoucherCode ?? this.appliedVoucherCode),
      discountAmount:
          clearVoucher ? 0.0 : (discountAmount ?? this.discountAmount),
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

// ─── Cart Notifier ───────────────────────────────────────────────────────────
@Riverpod(keepAlive: true)
class CartNotifier extends _$CartNotifier {
  @override
  CartState build() {
    // Lắng nghe stream giỏ hàng từ Firestore
    final asyncCart = ref.watch(cartStreamProvider);
    final cartEntity = asyncCart.asData?.value ?? const CartEntity(userId: '', items: []);
    return CartState(
      cart: cartEntity,
      isLoading: asyncCart.isLoading,
    );
  }

  String get _currentUserId {
    final user = ref.read(authStateProvider).asData?.value;
    return user?.id ?? 'guest_user';
  }

  /// Thêm sản phẩm vào giỏ
  Future<void> addToCart(
    ProductEntity product,
    String color, {
    int quantity = 1,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final repo = ref.read(cartRepositoryProvider);
      final item = CartItemEntity(
        productId: product.id,
        productName: product.name,
        productImage: product.mainImage,
        color: color.isNotEmpty ? color : (product.colors.isNotEmpty ? product.colors.first : 'Mặc định'),
        price: product.displayPrice,
        originalPrice: product.price,
        quantity: quantity,
      );
      await repo.addToCart(_currentUserId, item);
      if (ref.mounted) {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      if (ref.mounted) {
        state = state.copyWith(isLoading: false, errorMessage: e.toString());
      }
    }
  }

  /// Cập nhật số lượng
  Future<void> updateQuantity(
    String productId,
    String color,
    int quantity,
  ) async {
    try {
      final repo = ref.read(cartRepositoryProvider);
      await repo.updateQuantity(_currentUserId, productId, color, quantity);
    } catch (e) {
      if (ref.mounted) {
        state = state.copyWith(errorMessage: e.toString());
      }
    }
  }

  /// Tăng số lượng 1
  Future<void> incrementQuantity(CartItemEntity item) async {
    await updateQuantity(item.productId, item.color, item.quantity + 1);
  }

  /// Giảm số lượng 1 (xóa nếu số lượng = 1)
  Future<void> decrementQuantity(CartItemEntity item) async {
    if (item.quantity <= 1) {
      await removeItem(item.productId, item.color);
    } else {
      await updateQuantity(item.productId, item.color, item.quantity - 1);
    }
  }

  /// Xóa 1 mục sản phẩm khỏi giỏ
  Future<void> removeItem(String productId, String color) async {
    try {
      final repo = ref.read(cartRepositoryProvider);
      await repo.removeFromCart(_currentUserId, productId, color);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  /// Làm trống giỏ hàng
  Future<void> clearCart() async {
    try {
      final repo = ref.read(cartRepositoryProvider);
      await repo.clearCart(_currentUserId);
      state = state.copyWith(clearVoucher: true);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  /// Áp dụng mã giảm giá / voucher mẫu
  bool applyVoucher(String code) {
    final cleanCode = code.trim().toUpperCase();
    if (cleanCode == 'HUB50K') {
      state = state.copyWith(
        appliedVoucherCode: 'HUB50K',
        discountAmount: 50000.0,
      );
      return true;
    } else if (cleanCode == 'HUB100K') {
      state = state.copyWith(
        appliedVoucherCode: 'HUB100K',
        discountAmount: 100000.0,
      );
      return true;
    } else if (cleanCode == 'VIP10') {
      final discount = state.subtotal * 0.1;
      state = state.copyWith(
        appliedVoucherCode: 'VIP10',
        discountAmount: discount,
      );
      return true;
    }
    return false;
  }

  /// Xóa voucher
  void removeVoucher() {
    state = state.copyWith(clearVoucher: true);
  }
}
