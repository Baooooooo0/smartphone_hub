import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/user_model.dart';
import '../../../data/repositories/order_repository_impl.dart';
import '../../../domain/entities/order_entity.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/repositories/order_repository.dart';
import '../../../domain/usecases/auth/auth_usecases.dart';
import '../../cart/providers/cart_provider.dart';

part 'checkout_provider.g.dart';

// ─── Order Repository Provider ────────────────────────────────────────────────
@riverpod
OrderRepository orderRepository(Ref ref) {
  return OrderRepositoryImpl();
}

// ─── Checkout State ──────────────────────────────────────────────────────────
class CheckoutState {
  final Address? selectedAddress;
  final String paymentMethod; // 'cod', 'sepay', 'momo'
  final String note;
  final bool isLoading;
  final String? errorMessage;
  final String? createdOrderId;

  const CheckoutState({
    this.selectedAddress,
    this.paymentMethod = 'cod',
    this.note = '',
    this.isLoading = false,
    this.errorMessage,
    this.createdOrderId,
  });

  CheckoutState copyWith({
    Address? selectedAddress,
    String? paymentMethod,
    String? note,
    bool? isLoading,
    String? errorMessage,
    String? createdOrderId,
    bool clearError = false,
    bool clearCreatedOrderId = false,
  }) {
    return CheckoutState(
      selectedAddress: selectedAddress ?? this.selectedAddress,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      note: note ?? this.note,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      createdOrderId: clearCreatedOrderId
          ? null
          : (createdOrderId ?? this.createdOrderId),
    );
  }
}

// ─── Checkout Notifier ───────────────────────────────────────────────────────
@riverpod
class CheckoutNotifier extends _$CheckoutNotifier {
  @override
  CheckoutState build() {
    final user = ref.watch(authStateProvider).asData?.value;
    // Mặc định chọn địa chỉ default của user nếu có
    final defaultAddr = user?.defaultAddress ?? user?.addresses.firstOrNull;
    return CheckoutState(selectedAddress: defaultAddr);
  }

  void selectAddress(Address address) {
    state = state.copyWith(selectedAddress: address, clearError: true);
  }

  void selectPaymentMethod(String method) {
    state = state.copyWith(paymentMethod: method, clearError: true);
  }

  void setNote(String note) {
    state = state.copyWith(note: note);
  }

  /// Thêm địa chỉ mới vào profile user trên Firestore & tự động chọn
  Future<void> addNewAddress(Address newAddress) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = ref.read(authStateProvider).asData?.value;
      if (user != null) {
        final existing = List<Address>.from(user.addresses);
        // Nếu chọn làm default hoặc là địa chỉ duy nhất
        final isDefault = newAddress.isDefault || existing.isEmpty;

        List<Address> updatedAddresses = existing.map((a) {
          return isDefault ? a.copyWith(isDefault: false) : a;
        }).toList();

        final finalAddress = newAddress.copyWith(isDefault: isDefault);
        updatedAddresses.add(finalAddress);

        final addressModels = updatedAddresses
            .map((a) => AddressModel.fromEntity(a).toJson())
            .toList();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.id)
            .update({'addresses': addressModels});

        state = state.copyWith(
          selectedAddress: finalAddress,
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Không thể thêm địa chỉ: ${e.toString()}',
      );
    }
  }

  /// Thực hiện đặt hàng
  Future<String?> placeOrder({
    required CartState cartState,
    required UserEntity user,
  }) async {
    if (state.selectedAddress == null) {
      state = state.copyWith(
        errorMessage: 'Vui lòng chọn địa chỉ giao hàng trước khi đặt hàng.',
      );
      return null;
    }

    if (cartState.cart.items.isEmpty) {
      state = state.copyWith(
        errorMessage: 'Giỏ hàng của bạn đang trống.',
      );
      return null;
    }

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final orderItems = cartState.cart.items
          .map((item) => OrderItemEntity(
                productId: item.productId,
                productName: item.productName,
                productImage: item.productImage,
                color: item.color,
                price: item.price,
                quantity: item.quantity,
              ))
          .toList();

      final order = OrderEntity(
        id: '',
        userId: user.id,
        items: orderItems,
        subtotal: cartState.subtotal,
        discount: cartState.discountAmount,
        shippingFee: cartState.shippingFee,
        total: cartState.totalPrice,
        status: 'pending',
        paymentMethod: state.paymentMethod,
        paymentStatus: 'unpaid',
        shippingAddress: state.selectedAddress!,
        voucherCode: cartState.appliedVoucherCode,
        note: state.note.trim(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final repo = ref.read(orderRepositoryProvider);
      final orderId = await repo.createOrder(order);

      // Xóa giỏ hàng sau khi đặt thành công
      await ref.read(cartProvider.notifier).clearCart();

      state = state.copyWith(
        isLoading: false,
        createdOrderId: orderId,
      );

      return orderId;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Đặt hàng thất bại: ${e.toString()}',
      );
      return null;
    }
  }

  void resetCheckout() {
    state = const CheckoutState();
  }
}
