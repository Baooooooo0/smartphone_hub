// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OrderItemModel _$OrderItemModelFromJson(Map<String, dynamic> json) =>
    _OrderItemModel(
      productId: json['product_id'] as String,
      productName: json['product_name'] as String,
      productImage: json['product_image'] as String,
      color: json['color'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: (json['quantity'] as num).toInt(),
    );

Map<String, dynamic> _$OrderItemModelToJson(_OrderItemModel instance) =>
    <String, dynamic>{
      'product_id': instance.productId,
      'product_name': instance.productName,
      'product_image': instance.productImage,
      'color': instance.color,
      'price': instance.price,
      'quantity': instance.quantity,
    };

_OrderEventModel _$OrderEventModelFromJson(Map<String, dynamic> json) =>
    _OrderEventModel(
      status: json['status'] as String,
      note: json['note'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$OrderEventModelToJson(_OrderEventModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'note': instance.note,
      'timestamp': instance.timestamp.toIso8601String(),
    };

_OrderModel _$OrderModelFromJson(Map<String, dynamic> json) => _OrderModel(
  id: json['id'] as String,
  userId: json['user_id'] as String,
  items: (json['items'] as List<dynamic>)
      .map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  subtotal: (json['subtotal'] as num).toDouble(),
  discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
  shippingFee: (json['shipping_fee'] as num?)?.toDouble() ?? 0.0,
  total: (json['total'] as num).toDouble(),
  status: json['status'] as String? ?? 'pending',
  paymentMethod: json['payment_method'] as String? ?? 'cod',
  paymentStatus: json['payment_status'] as String? ?? 'unpaid',
  paymentRef: json['payment_ref'] as String? ?? '',
  shippingAddress: AddressModel.fromJson(
    json['shipping_address'] as Map<String, dynamic>,
  ),
  voucherId: json['voucher_id'] as String?,
  voucherCode: json['voucher_code'] as String?,
  note: json['note'] as String? ?? '',
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
  timeline:
      (json['timeline'] as List<dynamic>?)
          ?.map((e) => OrderEventModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$OrderModelToJson(_OrderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'items': instance.items.map((e) => e.toJson()).toList(),
      'subtotal': instance.subtotal,
      'discount': instance.discount,
      'shipping_fee': instance.shippingFee,
      'total': instance.total,
      'status': instance.status,
      'payment_method': instance.paymentMethod,
      'payment_status': instance.paymentStatus,
      'payment_ref': instance.paymentRef,
      'shipping_address': instance.shippingAddress.toJson(),
      'voucher_id': instance.voucherId,
      'voucher_code': instance.voucherCode,
      'note': instance.note,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'timeline': instance.timeline.map((e) => e.toJson()).toList(),
    };
