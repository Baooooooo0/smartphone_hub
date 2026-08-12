// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OrderItemEntity {

 String get productId; String get productName; String get productImage; String get color; double get price; int get quantity;
/// Create a copy of OrderItemEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderItemEntityCopyWith<OrderItemEntity> get copyWith => _$OrderItemEntityCopyWithImpl<OrderItemEntity>(this as OrderItemEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderItemEntity&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.productImage, productImage) || other.productImage == productImage)&&(identical(other.color, color) || other.color == color)&&(identical(other.price, price) || other.price == price)&&(identical(other.quantity, quantity) || other.quantity == quantity));
}


@override
int get hashCode => Object.hash(runtimeType,productId,productName,productImage,color,price,quantity);

@override
String toString() {
  return 'OrderItemEntity(productId: $productId, productName: $productName, productImage: $productImage, color: $color, price: $price, quantity: $quantity)';
}


}

/// @nodoc
abstract mixin class $OrderItemEntityCopyWith<$Res>  {
  factory $OrderItemEntityCopyWith(OrderItemEntity value, $Res Function(OrderItemEntity) _then) = _$OrderItemEntityCopyWithImpl;
@useResult
$Res call({
 String productId, String productName, String productImage, String color, double price, int quantity
});




}
/// @nodoc
class _$OrderItemEntityCopyWithImpl<$Res>
    implements $OrderItemEntityCopyWith<$Res> {
  _$OrderItemEntityCopyWithImpl(this._self, this._then);

  final OrderItemEntity _self;
  final $Res Function(OrderItemEntity) _then;

/// Create a copy of OrderItemEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productId = null,Object? productName = null,Object? productImage = null,Object? color = null,Object? price = null,Object? quantity = null,}) {
  return _then(_self.copyWith(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,productImage: null == productImage ? _self.productImage : productImage // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderItemEntity].
extension OrderItemEntityPatterns on OrderItemEntity {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderItemEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderItemEntity() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderItemEntity value)  $default,){
final _that = this;
switch (_that) {
case _OrderItemEntity():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderItemEntity value)?  $default,){
final _that = this;
switch (_that) {
case _OrderItemEntity() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String productId,  String productName,  String productImage,  String color,  double price,  int quantity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderItemEntity() when $default != null:
return $default(_that.productId,_that.productName,_that.productImage,_that.color,_that.price,_that.quantity);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String productId,  String productName,  String productImage,  String color,  double price,  int quantity)  $default,) {final _that = this;
switch (_that) {
case _OrderItemEntity():
return $default(_that.productId,_that.productName,_that.productImage,_that.color,_that.price,_that.quantity);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String productId,  String productName,  String productImage,  String color,  double price,  int quantity)?  $default,) {final _that = this;
switch (_that) {
case _OrderItemEntity() when $default != null:
return $default(_that.productId,_that.productName,_that.productImage,_that.color,_that.price,_that.quantity);case _:
  return null;

}
}

}

/// @nodoc


class _OrderItemEntity extends OrderItemEntity {
  const _OrderItemEntity({required this.productId, required this.productName, required this.productImage, required this.color, required this.price, required this.quantity}): super._();
  

@override final  String productId;
@override final  String productName;
@override final  String productImage;
@override final  String color;
@override final  double price;
@override final  int quantity;

/// Create a copy of OrderItemEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderItemEntityCopyWith<_OrderItemEntity> get copyWith => __$OrderItemEntityCopyWithImpl<_OrderItemEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderItemEntity&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.productImage, productImage) || other.productImage == productImage)&&(identical(other.color, color) || other.color == color)&&(identical(other.price, price) || other.price == price)&&(identical(other.quantity, quantity) || other.quantity == quantity));
}


@override
int get hashCode => Object.hash(runtimeType,productId,productName,productImage,color,price,quantity);

@override
String toString() {
  return 'OrderItemEntity(productId: $productId, productName: $productName, productImage: $productImage, color: $color, price: $price, quantity: $quantity)';
}


}

/// @nodoc
abstract mixin class _$OrderItemEntityCopyWith<$Res> implements $OrderItemEntityCopyWith<$Res> {
  factory _$OrderItemEntityCopyWith(_OrderItemEntity value, $Res Function(_OrderItemEntity) _then) = __$OrderItemEntityCopyWithImpl;
@override @useResult
$Res call({
 String productId, String productName, String productImage, String color, double price, int quantity
});




}
/// @nodoc
class __$OrderItemEntityCopyWithImpl<$Res>
    implements _$OrderItemEntityCopyWith<$Res> {
  __$OrderItemEntityCopyWithImpl(this._self, this._then);

  final _OrderItemEntity _self;
  final $Res Function(_OrderItemEntity) _then;

/// Create a copy of OrderItemEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productId = null,Object? productName = null,Object? productImage = null,Object? color = null,Object? price = null,Object? quantity = null,}) {
  return _then(_OrderItemEntity(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,productImage: null == productImage ? _self.productImage : productImage // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$OrderEventEntity {

 String get status; String get note; DateTime get timestamp;
/// Create a copy of OrderEventEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderEventEntityCopyWith<OrderEventEntity> get copyWith => _$OrderEventEntityCopyWithImpl<OrderEventEntity>(this as OrderEventEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderEventEntity&&(identical(other.status, status) || other.status == status)&&(identical(other.note, note) || other.note == note)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}


@override
int get hashCode => Object.hash(runtimeType,status,note,timestamp);

@override
String toString() {
  return 'OrderEventEntity(status: $status, note: $note, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class $OrderEventEntityCopyWith<$Res>  {
  factory $OrderEventEntityCopyWith(OrderEventEntity value, $Res Function(OrderEventEntity) _then) = _$OrderEventEntityCopyWithImpl;
@useResult
$Res call({
 String status, String note, DateTime timestamp
});




}
/// @nodoc
class _$OrderEventEntityCopyWithImpl<$Res>
    implements $OrderEventEntityCopyWith<$Res> {
  _$OrderEventEntityCopyWithImpl(this._self, this._then);

  final OrderEventEntity _self;
  final $Res Function(OrderEventEntity) _then;

/// Create a copy of OrderEventEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? note = null,Object? timestamp = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderEventEntity].
extension OrderEventEntityPatterns on OrderEventEntity {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderEventEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderEventEntity() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderEventEntity value)  $default,){
final _that = this;
switch (_that) {
case _OrderEventEntity():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderEventEntity value)?  $default,){
final _that = this;
switch (_that) {
case _OrderEventEntity() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String status,  String note,  DateTime timestamp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderEventEntity() when $default != null:
return $default(_that.status,_that.note,_that.timestamp);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String status,  String note,  DateTime timestamp)  $default,) {final _that = this;
switch (_that) {
case _OrderEventEntity():
return $default(_that.status,_that.note,_that.timestamp);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String status,  String note,  DateTime timestamp)?  $default,) {final _that = this;
switch (_that) {
case _OrderEventEntity() when $default != null:
return $default(_that.status,_that.note,_that.timestamp);case _:
  return null;

}
}

}

/// @nodoc


class _OrderEventEntity implements OrderEventEntity {
  const _OrderEventEntity({required this.status, required this.note, required this.timestamp});
  

@override final  String status;
@override final  String note;
@override final  DateTime timestamp;

/// Create a copy of OrderEventEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderEventEntityCopyWith<_OrderEventEntity> get copyWith => __$OrderEventEntityCopyWithImpl<_OrderEventEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderEventEntity&&(identical(other.status, status) || other.status == status)&&(identical(other.note, note) || other.note == note)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}


@override
int get hashCode => Object.hash(runtimeType,status,note,timestamp);

@override
String toString() {
  return 'OrderEventEntity(status: $status, note: $note, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class _$OrderEventEntityCopyWith<$Res> implements $OrderEventEntityCopyWith<$Res> {
  factory _$OrderEventEntityCopyWith(_OrderEventEntity value, $Res Function(_OrderEventEntity) _then) = __$OrderEventEntityCopyWithImpl;
@override @useResult
$Res call({
 String status, String note, DateTime timestamp
});




}
/// @nodoc
class __$OrderEventEntityCopyWithImpl<$Res>
    implements _$OrderEventEntityCopyWith<$Res> {
  __$OrderEventEntityCopyWithImpl(this._self, this._then);

  final _OrderEventEntity _self;
  final $Res Function(_OrderEventEntity) _then;

/// Create a copy of OrderEventEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? note = null,Object? timestamp = null,}) {
  return _then(_OrderEventEntity(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc
mixin _$OrderEntity {

 String get id; String get userId; List<OrderItemEntity> get items; double get subtotal; double get discount; double get shippingFee; double get total; String get status; String get paymentMethod; String get paymentStatus; String get paymentRef; Address get shippingAddress; String? get voucherId; String? get voucherCode; String get note; DateTime? get createdAt; DateTime? get updatedAt; List<OrderEventEntity> get timeline;
/// Create a copy of OrderEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderEntityCopyWith<OrderEntity> get copyWith => _$OrderEntityCopyWithImpl<OrderEntity>(this as OrderEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.discount, discount) || other.discount == discount)&&(identical(other.shippingFee, shippingFee) || other.shippingFee == shippingFee)&&(identical(other.total, total) || other.total == total)&&(identical(other.status, status) || other.status == status)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.paymentStatus, paymentStatus) || other.paymentStatus == paymentStatus)&&(identical(other.paymentRef, paymentRef) || other.paymentRef == paymentRef)&&(identical(other.shippingAddress, shippingAddress) || other.shippingAddress == shippingAddress)&&(identical(other.voucherId, voucherId) || other.voucherId == voucherId)&&(identical(other.voucherCode, voucherCode) || other.voucherCode == voucherCode)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other.timeline, timeline));
}


@override
int get hashCode => Object.hash(runtimeType,id,userId,const DeepCollectionEquality().hash(items),subtotal,discount,shippingFee,total,status,paymentMethod,paymentStatus,paymentRef,shippingAddress,voucherId,voucherCode,note,createdAt,updatedAt,const DeepCollectionEquality().hash(timeline));

@override
String toString() {
  return 'OrderEntity(id: $id, userId: $userId, items: $items, subtotal: $subtotal, discount: $discount, shippingFee: $shippingFee, total: $total, status: $status, paymentMethod: $paymentMethod, paymentStatus: $paymentStatus, paymentRef: $paymentRef, shippingAddress: $shippingAddress, voucherId: $voucherId, voucherCode: $voucherCode, note: $note, createdAt: $createdAt, updatedAt: $updatedAt, timeline: $timeline)';
}


}

/// @nodoc
abstract mixin class $OrderEntityCopyWith<$Res>  {
  factory $OrderEntityCopyWith(OrderEntity value, $Res Function(OrderEntity) _then) = _$OrderEntityCopyWithImpl;
@useResult
$Res call({
 String id, String userId, List<OrderItemEntity> items, double subtotal, double discount, double shippingFee, double total, String status, String paymentMethod, String paymentStatus, String paymentRef, Address shippingAddress, String? voucherId, String? voucherCode, String note, DateTime? createdAt, DateTime? updatedAt, List<OrderEventEntity> timeline
});


$AddressCopyWith<$Res> get shippingAddress;

}
/// @nodoc
class _$OrderEntityCopyWithImpl<$Res>
    implements $OrderEntityCopyWith<$Res> {
  _$OrderEntityCopyWithImpl(this._self, this._then);

  final OrderEntity _self;
  final $Res Function(OrderEntity) _then;

/// Create a copy of OrderEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? items = null,Object? subtotal = null,Object? discount = null,Object? shippingFee = null,Object? total = null,Object? status = null,Object? paymentMethod = null,Object? paymentStatus = null,Object? paymentRef = null,Object? shippingAddress = null,Object? voucherId = freezed,Object? voucherCode = freezed,Object? note = null,Object? createdAt = freezed,Object? updatedAt = freezed,Object? timeline = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<OrderItemEntity>,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as double,discount: null == discount ? _self.discount : discount // ignore: cast_nullable_to_non_nullable
as double,shippingFee: null == shippingFee ? _self.shippingFee : shippingFee // ignore: cast_nullable_to_non_nullable
as double,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as double,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String,paymentStatus: null == paymentStatus ? _self.paymentStatus : paymentStatus // ignore: cast_nullable_to_non_nullable
as String,paymentRef: null == paymentRef ? _self.paymentRef : paymentRef // ignore: cast_nullable_to_non_nullable
as String,shippingAddress: null == shippingAddress ? _self.shippingAddress : shippingAddress // ignore: cast_nullable_to_non_nullable
as Address,voucherId: freezed == voucherId ? _self.voucherId : voucherId // ignore: cast_nullable_to_non_nullable
as String?,voucherCode: freezed == voucherCode ? _self.voucherCode : voucherCode // ignore: cast_nullable_to_non_nullable
as String?,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,timeline: null == timeline ? _self.timeline : timeline // ignore: cast_nullable_to_non_nullable
as List<OrderEventEntity>,
  ));
}
/// Create a copy of OrderEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AddressCopyWith<$Res> get shippingAddress {
  
  return $AddressCopyWith<$Res>(_self.shippingAddress, (value) {
    return _then(_self.copyWith(shippingAddress: value));
  });
}
}


/// Adds pattern-matching-related methods to [OrderEntity].
extension OrderEntityPatterns on OrderEntity {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderEntity() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderEntity value)  $default,){
final _that = this;
switch (_that) {
case _OrderEntity():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderEntity value)?  $default,){
final _that = this;
switch (_that) {
case _OrderEntity() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  List<OrderItemEntity> items,  double subtotal,  double discount,  double shippingFee,  double total,  String status,  String paymentMethod,  String paymentStatus,  String paymentRef,  Address shippingAddress,  String? voucherId,  String? voucherCode,  String note,  DateTime? createdAt,  DateTime? updatedAt,  List<OrderEventEntity> timeline)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderEntity() when $default != null:
return $default(_that.id,_that.userId,_that.items,_that.subtotal,_that.discount,_that.shippingFee,_that.total,_that.status,_that.paymentMethod,_that.paymentStatus,_that.paymentRef,_that.shippingAddress,_that.voucherId,_that.voucherCode,_that.note,_that.createdAt,_that.updatedAt,_that.timeline);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  List<OrderItemEntity> items,  double subtotal,  double discount,  double shippingFee,  double total,  String status,  String paymentMethod,  String paymentStatus,  String paymentRef,  Address shippingAddress,  String? voucherId,  String? voucherCode,  String note,  DateTime? createdAt,  DateTime? updatedAt,  List<OrderEventEntity> timeline)  $default,) {final _that = this;
switch (_that) {
case _OrderEntity():
return $default(_that.id,_that.userId,_that.items,_that.subtotal,_that.discount,_that.shippingFee,_that.total,_that.status,_that.paymentMethod,_that.paymentStatus,_that.paymentRef,_that.shippingAddress,_that.voucherId,_that.voucherCode,_that.note,_that.createdAt,_that.updatedAt,_that.timeline);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  List<OrderItemEntity> items,  double subtotal,  double discount,  double shippingFee,  double total,  String status,  String paymentMethod,  String paymentStatus,  String paymentRef,  Address shippingAddress,  String? voucherId,  String? voucherCode,  String note,  DateTime? createdAt,  DateTime? updatedAt,  List<OrderEventEntity> timeline)?  $default,) {final _that = this;
switch (_that) {
case _OrderEntity() when $default != null:
return $default(_that.id,_that.userId,_that.items,_that.subtotal,_that.discount,_that.shippingFee,_that.total,_that.status,_that.paymentMethod,_that.paymentStatus,_that.paymentRef,_that.shippingAddress,_that.voucherId,_that.voucherCode,_that.note,_that.createdAt,_that.updatedAt,_that.timeline);case _:
  return null;

}
}

}

/// @nodoc


class _OrderEntity extends OrderEntity {
  const _OrderEntity({required this.id, required this.userId, required final  List<OrderItemEntity> items, required this.subtotal, this.discount = 0.0, this.shippingFee = 0.0, required this.total, this.status = 'pending', this.paymentMethod = 'cod', this.paymentStatus = 'unpaid', this.paymentRef = '', required this.shippingAddress, this.voucherId, this.voucherCode, this.note = '', this.createdAt, this.updatedAt, final  List<OrderEventEntity> timeline = const []}): _items = items,_timeline = timeline,super._();
  

@override final  String id;
@override final  String userId;
 final  List<OrderItemEntity> _items;
@override List<OrderItemEntity> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  double subtotal;
@override@JsonKey() final  double discount;
@override@JsonKey() final  double shippingFee;
@override final  double total;
@override@JsonKey() final  String status;
@override@JsonKey() final  String paymentMethod;
@override@JsonKey() final  String paymentStatus;
@override@JsonKey() final  String paymentRef;
@override final  Address shippingAddress;
@override final  String? voucherId;
@override final  String? voucherCode;
@override@JsonKey() final  String note;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;
 final  List<OrderEventEntity> _timeline;
@override@JsonKey() List<OrderEventEntity> get timeline {
  if (_timeline is EqualUnmodifiableListView) return _timeline;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_timeline);
}


/// Create a copy of OrderEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderEntityCopyWith<_OrderEntity> get copyWith => __$OrderEntityCopyWithImpl<_OrderEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.discount, discount) || other.discount == discount)&&(identical(other.shippingFee, shippingFee) || other.shippingFee == shippingFee)&&(identical(other.total, total) || other.total == total)&&(identical(other.status, status) || other.status == status)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.paymentStatus, paymentStatus) || other.paymentStatus == paymentStatus)&&(identical(other.paymentRef, paymentRef) || other.paymentRef == paymentRef)&&(identical(other.shippingAddress, shippingAddress) || other.shippingAddress == shippingAddress)&&(identical(other.voucherId, voucherId) || other.voucherId == voucherId)&&(identical(other.voucherCode, voucherCode) || other.voucherCode == voucherCode)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other._timeline, _timeline));
}


@override
int get hashCode => Object.hash(runtimeType,id,userId,const DeepCollectionEquality().hash(_items),subtotal,discount,shippingFee,total,status,paymentMethod,paymentStatus,paymentRef,shippingAddress,voucherId,voucherCode,note,createdAt,updatedAt,const DeepCollectionEquality().hash(_timeline));

@override
String toString() {
  return 'OrderEntity(id: $id, userId: $userId, items: $items, subtotal: $subtotal, discount: $discount, shippingFee: $shippingFee, total: $total, status: $status, paymentMethod: $paymentMethod, paymentStatus: $paymentStatus, paymentRef: $paymentRef, shippingAddress: $shippingAddress, voucherId: $voucherId, voucherCode: $voucherCode, note: $note, createdAt: $createdAt, updatedAt: $updatedAt, timeline: $timeline)';
}


}

/// @nodoc
abstract mixin class _$OrderEntityCopyWith<$Res> implements $OrderEntityCopyWith<$Res> {
  factory _$OrderEntityCopyWith(_OrderEntity value, $Res Function(_OrderEntity) _then) = __$OrderEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, List<OrderItemEntity> items, double subtotal, double discount, double shippingFee, double total, String status, String paymentMethod, String paymentStatus, String paymentRef, Address shippingAddress, String? voucherId, String? voucherCode, String note, DateTime? createdAt, DateTime? updatedAt, List<OrderEventEntity> timeline
});


@override $AddressCopyWith<$Res> get shippingAddress;

}
/// @nodoc
class __$OrderEntityCopyWithImpl<$Res>
    implements _$OrderEntityCopyWith<$Res> {
  __$OrderEntityCopyWithImpl(this._self, this._then);

  final _OrderEntity _self;
  final $Res Function(_OrderEntity) _then;

/// Create a copy of OrderEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? items = null,Object? subtotal = null,Object? discount = null,Object? shippingFee = null,Object? total = null,Object? status = null,Object? paymentMethod = null,Object? paymentStatus = null,Object? paymentRef = null,Object? shippingAddress = null,Object? voucherId = freezed,Object? voucherCode = freezed,Object? note = null,Object? createdAt = freezed,Object? updatedAt = freezed,Object? timeline = null,}) {
  return _then(_OrderEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<OrderItemEntity>,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as double,discount: null == discount ? _self.discount : discount // ignore: cast_nullable_to_non_nullable
as double,shippingFee: null == shippingFee ? _self.shippingFee : shippingFee // ignore: cast_nullable_to_non_nullable
as double,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as double,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String,paymentStatus: null == paymentStatus ? _self.paymentStatus : paymentStatus // ignore: cast_nullable_to_non_nullable
as String,paymentRef: null == paymentRef ? _self.paymentRef : paymentRef // ignore: cast_nullable_to_non_nullable
as String,shippingAddress: null == shippingAddress ? _self.shippingAddress : shippingAddress // ignore: cast_nullable_to_non_nullable
as Address,voucherId: freezed == voucherId ? _self.voucherId : voucherId // ignore: cast_nullable_to_non_nullable
as String?,voucherCode: freezed == voucherCode ? _self.voucherCode : voucherCode // ignore: cast_nullable_to_non_nullable
as String?,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,timeline: null == timeline ? _self._timeline : timeline // ignore: cast_nullable_to_non_nullable
as List<OrderEventEntity>,
  ));
}

/// Create a copy of OrderEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AddressCopyWith<$Res> get shippingAddress {
  
  return $AddressCopyWith<$Res>(_self.shippingAddress, (value) {
    return _then(_self.copyWith(shippingAddress: value));
  });
}
}

// dart format on
