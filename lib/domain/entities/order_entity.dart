import 'package:freezed_annotation/freezed_annotation.dart';
import 'user_entity.dart';

part 'order_entity.freezed.dart';

/// OrderItemEntity — Sản phẩm trong đơn hàng
@freezed
abstract class OrderItemEntity with _$OrderItemEntity {
  const factory OrderItemEntity({
    required String productId,
    required String productName,
    required String productImage,
    required String color,
    required double price,
    required int quantity,
  }) = _OrderItemEntity;

  const OrderItemEntity._();

  double get totalPrice => price * quantity;
}

/// OrderEventEntity — Sự kiện mốc thời gian của đơn hàng
@freezed
abstract class OrderEventEntity with _$OrderEventEntity {
  const factory OrderEventEntity({
    required String status,
    required String note,
    required DateTime timestamp,
  }) = _OrderEventEntity;
}

/// OrderEntity — Business Entity đại diện cho đơn hàng
@freezed
abstract class OrderEntity with _$OrderEntity {
  const factory OrderEntity({
    required String id,
    required String userId,
    required List<OrderItemEntity> items,
    required double subtotal,
    @Default(0.0) double discount,
    @Default(0.0) double shippingFee,
    required double total,
    @Default('pending') String status, // pending, confirmed, shipping, delivered, cancelled
    @Default('cod') String paymentMethod, // sepay, momo, cod
    @Default('unpaid') String paymentStatus, // unpaid, paid, refunded
    @Default('') String paymentRef,
    required Address shippingAddress,
    String? voucherId,
    String? voucherCode,
    @Default('') String note,
    DateTime? createdAt,
    DateTime? updatedAt,
    @Default([]) List<OrderEventEntity> timeline,
  }) = _OrderEntity;

  const OrderEntity._();

  bool get isPending => status == 'pending';
  bool get isConfirmed => status == 'confirmed';
  bool get isShipping => status == 'shipping';
  bool get isDelivered => status == 'delivered';
  bool get isCancelled => status == 'cancelled';

  bool get isPaid => paymentStatus == 'paid';
}
