import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/entities/order_entity.dart';
import '../../../domain/usecases/auth/auth_usecases.dart';
import '../../checkout/providers/checkout_provider.dart';

part 'order_providers.g.dart';

// ─── User Orders Realtime Stream Provider ────────────────────────────────────
@riverpod
Stream<List<OrderEntity>> userOrdersStream(Ref ref) {
  final user = ref.watch(authStateProvider).asData?.value;
  if (user == null) {
    return Stream.value([]);
  }
  final orderRepo = ref.watch(orderRepositoryProvider);
  return orderRepo.watchUserOrders(user.id);
}

// ─── Single Order Detail Stream Provider ──────────────────────────────────────
@riverpod
Stream<OrderEntity?> orderDetailStream(Ref ref, String orderId) async* {
  final orderRepo = ref.watch(orderRepositoryProvider);
  // Fetch initial
  final initialOrder = await orderRepo.getOrderById(orderId);
  if (initialOrder != null) {
    yield initialOrder;
  }

  // Watch from user stream for real-time updates
  final userOrdersAsync = ref.watch(userOrdersStreamProvider);
  final orders = userOrdersAsync.asData?.value;
  if (orders != null) {
    final updatedOrder = orders.where((o) => o.id == orderId).firstOrNull;
    if (updatedOrder != null) {
      yield updatedOrder;
    }
  }
}

// ─── Selected Tab Index Provider ─────────────────────────────────────────────
@riverpod
class OrderFilterIndex extends _$OrderFilterIndex {
  @override
  int build() => 0; // 0: Tất cả, 1: Chờ xử lý, 2: Đã xác nhận, 3: Đang giao, 4: Đã giao, 5: Đã hủy

  void setIndex(int index) {
    state = index;
  }
}

// ─── Order Action Notifier ───────────────────────────────────────────────────
class OrderActionState {
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;

  const OrderActionState({
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
  });

  OrderActionState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
    bool clearMessages = false,
  }) {
    return OrderActionState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearMessages ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearMessages ? null : (successMessage ?? this.successMessage),
    );
  }
}

@riverpod
class OrderActionNotifier extends _$OrderActionNotifier {
  @override
  OrderActionState build() => const OrderActionState();

  /// Hủy đơn hàng khi status = pending
  Future<bool> cancelOrder(String orderId, {String? reason}) async {
    state = state.copyWith(isLoading: true, clearMessages: true);
    try {
      final repo = ref.read(orderRepositoryProvider);
      await repo.cancelOrder(orderId, reason: reason);
      state = state.copyWith(
        isLoading: false,
        successMessage: 'Đã hủy đơn hàng thành công.',
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Hủy đơn thất bại: ${e.toString()}',
      );
      return false;
    }
  }
}
