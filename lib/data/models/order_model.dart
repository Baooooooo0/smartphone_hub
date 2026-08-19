import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/order_entity.dart';
import 'user_model.dart';

part 'order_model.freezed.dart';
part 'order_model.g.dart';

/// OrderItemModel — DTO cho sản phẩm trong đơn hàng
@freezed
abstract class OrderItemModel with _$OrderItemModel {
  const factory OrderItemModel({
    required String productId,
    required String productName,
    required String productImage,
    required String color,
    required double price,
    required int quantity,
  }) = _OrderItemModel;

  factory OrderItemModel.fromJson(Map<String, dynamic> json) =>
      _$OrderItemModelFromJson(json);

  factory OrderItemModel.fromFirestore(Map<String, dynamic> json) =>
      OrderItemModel(
        productId: json['productId'] as String? ?? '',
        productName: json['productName'] as String? ?? '',
        productImage: json['productImage'] as String? ?? '',
        color: json['color'] as String? ?? '',
        price: (json['price'] as num?)?.toDouble() ?? 0.0,
        quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      );

  const OrderItemModel._();

  factory OrderItemModel.fromEntity(OrderItemEntity entity) => OrderItemModel(
        productId: entity.productId,
        productName: entity.productName,
        productImage: entity.productImage,
        color: entity.color,
        price: entity.price,
        quantity: entity.quantity,
      );

  OrderItemEntity toEntity() => OrderItemEntity(
        productId: productId,
        productName: productName,
        productImage: productImage,
        color: color,
        price: price,
        quantity: quantity,
      );
}

/// OrderEventModel — DTO cho mốc lịch sử đơn hàng
@freezed
abstract class OrderEventModel with _$OrderEventModel {
  const factory OrderEventModel({
    required String status,
    required String note,
    required DateTime timestamp,
  }) = _OrderEventModel;

  factory OrderEventModel.fromJson(Map<String, dynamic> json) =>
      _$OrderEventModelFromJson(json);

  factory OrderEventModel.fromFirestore(Map<String, dynamic> json) {
    final rawTimestamp = json['timestamp'];
    DateTime ts;
    if (rawTimestamp is Timestamp) {
      ts = rawTimestamp.toDate();
    } else if (rawTimestamp is String) {
      ts = DateTime.tryParse(rawTimestamp) ?? DateTime.now();
    } else {
      ts = DateTime.now();
    }

    return OrderEventModel(
      status: json['status'] as String? ?? 'pending',
      note: json['note'] as String? ?? '',
      timestamp: ts,
    );
  }

  const OrderEventModel._();

  factory OrderEventModel.fromEntity(OrderEventEntity entity) => OrderEventModel(
        status: entity.status,
        note: entity.note,
        timestamp: entity.timestamp,
      );

  OrderEventEntity toEntity() => OrderEventEntity(
        status: status,
        note: note,
        timestamp: timestamp,
      );
}

/// OrderModel — DTO cho Firestore `/orders/{orderId}`
@freezed
abstract class OrderModel with _$OrderModel {
  const factory OrderModel({
    required String id,
    required String userId,
    required List<OrderItemModel> items,
    required double subtotal,
    @Default(0.0) double discount,
    @Default(0.0) double shippingFee,
    required double total,
    @Default('pending') String status,
    @Default('cod') String paymentMethod,
    @Default('unpaid') String paymentStatus,
    @Default('') String paymentRef,
    required AddressModel shippingAddress,
    String? voucherId,
    String? voucherCode,
    @Default('') String note,
    DateTime? createdAt,
    DateTime? updatedAt,
    @Default([]) List<OrderEventModel> timeline,
  }) = _OrderModel;

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);

  const OrderModel._();

  factory OrderModel.fromFirestore(Map<String, dynamic> data, String id) {
    DateTime? parseDateTime(dynamic value) {
      if (value is Timestamp) return value.toDate();
      if (value is String) return DateTime.tryParse(value);
      return null;
    }

    final itemsRaw = data['items'] as List<dynamic>? ?? [];
    final items = itemsRaw
        .map((item) {
          if (item is Map<String, dynamic>) {
            return OrderItemModel.fromFirestore(item);
          } else if (item is Map) {
            return OrderItemModel.fromFirestore(Map<String, dynamic>.from(item));
          }
          return null;
        })
        .whereType<OrderItemModel>()
        .toList();

    final timelineRaw = data['timeline'] as List<dynamic>? ?? [];
    final timeline = timelineRaw
        .map((e) {
          if (e is Map<String, dynamic>) {
            return OrderEventModel.fromFirestore(e);
          } else if (e is Map) {
            return OrderEventModel.fromFirestore(Map<String, dynamic>.from(e));
          }
          return null;
        })
        .whereType<OrderEventModel>()
        .toList();

    return OrderModel(
      id: id,
      userId: data['userId'] as String? ?? '',
      items: items,
      subtotal: (data['subtotal'] as num?)?.toDouble() ?? 0.0,
      discount: (data['discount'] as num?)?.toDouble() ?? 0.0,
      shippingFee: (data['shippingFee'] as num?)?.toDouble() ?? 0.0,
      total: (data['total'] as num?)?.toDouble() ?? 0.0,
      status: data['status'] as String? ?? 'pending',
      paymentMethod: data['paymentMethod'] as String? ?? 'cod',
      paymentStatus: data['paymentStatus'] as String? ?? 'unpaid',
      paymentRef: data['paymentRef'] as String? ?? '',
      shippingAddress: AddressModel.fromFirestore(data['shippingAddress']),
      voucherId: data['voucherId'] as String?,
      voucherCode: data['voucherCode'] as String?,
      note: data['note'] as String? ?? '',
      createdAt: parseDateTime(data['createdAt']),
      updatedAt: parseDateTime(data['updatedAt']),
      timeline: timeline,
    );
  }

  Map<String, dynamic> toFirestore() => {
        'id': id,
        'userId': userId,
        'items': items.map((i) => i.toJson()).toList(),
        'subtotal': subtotal,
        'discount': discount,
        'shippingFee': shippingFee,
        'total': total,
        'status': status,
        'paymentMethod': paymentMethod,
        'paymentStatus': paymentStatus,
        'paymentRef': paymentRef,
        'shippingAddress': shippingAddress.toJson(),
        if (voucherId != null) 'voucherId': voucherId,
        if (voucherCode != null) 'voucherCode': voucherCode,
        'note': note,
        'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
        'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : FieldValue.serverTimestamp(),
        'timeline': timeline.map((e) => e.toJson()).toList(),
      };

  OrderEntity toEntity() => OrderEntity(
        id: id,
        userId: userId,
        items: items.map((i) => i.toEntity()).toList(),
        subtotal: subtotal,
        discount: discount,
        shippingFee: shippingFee,
        total: total,
        status: status,
        paymentMethod: paymentMethod,
        paymentStatus: paymentStatus,
        paymentRef: paymentRef,
        shippingAddress: shippingAddress.toEntity(),
        voucherId: voucherId,
        voucherCode: voucherCode,
        note: note,
        createdAt: createdAt,
        updatedAt: updatedAt,
        timeline: timeline.map((e) => e.toEntity()).toList(),
      );

  factory OrderModel.fromEntity(OrderEntity entity) => OrderModel(
        id: entity.id,
        userId: entity.userId,
        items: entity.items.map((i) => OrderItemModel.fromEntity(i)).toList(),
        subtotal: entity.subtotal,
        discount: entity.discount,
        shippingFee: entity.shippingFee,
        total: entity.total,
        status: entity.status,
        paymentMethod: entity.paymentMethod,
        paymentStatus: entity.paymentStatus,
        paymentRef: entity.paymentRef,
        shippingAddress: AddressModel.fromEntity(entity.shippingAddress),
        voucherId: entity.voucherId,
        voucherCode: entity.voucherCode,
        note: entity.note,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
        timeline: entity.timeline.map((e) => OrderEventModel.fromEntity(e)).toList(),
      );
}
