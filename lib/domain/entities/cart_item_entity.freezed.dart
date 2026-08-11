// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cart_item_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CartItemEntity {

 String get productId; String get productName; String get productImage; String get color; double get price; double get originalPrice; int get quantity;
/// Create a copy of CartItemEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CartItemEntityCopyWith<CartItemEntity> get copyWith => _$CartItemEntityCopyWithImpl<CartItemEntity>(this as CartItemEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CartItemEntity&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.productImage, productImage) || other.productImage == productImage)&&(identical(other.color, color) || other.color == color)&&(identical(other.price, price) || other.price == price)&&(identical(other.originalPrice, originalPrice) || other.originalPrice == originalPrice)&&(identical(other.quantity, quantity) || other.quantity == quantity));
}


@override
int get hashCode => Object.hash(runtimeType,productId,productName,productImage,color,price,originalPrice,quantity);

@override
String toString() {
  return 'CartItemEntity(productId: $productId, productName: $productName, productImage: $productImage, color: $color, price: $price, originalPrice: $originalPrice, quantity: $quantity)';
}


}

/// @nodoc
abstract mixin class $CartItemEntityCopyWith<$Res>  {
  factory $CartItemEntityCopyWith(CartItemEntity value, $Res Function(CartItemEntity) _then) = _$CartItemEntityCopyWithImpl;
@useResult
$Res call({
 String productId, String productName, String productImage, String color, double price, double originalPrice, int quantity
});




}
/// @nodoc
class _$CartItemEntityCopyWithImpl<$Res>
    implements $CartItemEntityCopyWith<$Res> {
  _$CartItemEntityCopyWithImpl(this._self, this._then);

  final CartItemEntity _self;
  final $Res Function(CartItemEntity) _then;

/// Create a copy of CartItemEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productId = null,Object? productName = null,Object? productImage = null,Object? color = null,Object? price = null,Object? originalPrice = null,Object? quantity = null,}) {
  return _then(_self.copyWith(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,productImage: null == productImage ? _self.productImage : productImage // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,originalPrice: null == originalPrice ? _self.originalPrice : originalPrice // ignore: cast_nullable_to_non_nullable
as double,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CartItemEntity].
extension CartItemEntityPatterns on CartItemEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CartItemEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CartItemEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CartItemEntity value)  $default,){
final _that = this;
switch (_that) {
case _CartItemEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CartItemEntity value)?  $default,){
final _that = this;
switch (_that) {
case _CartItemEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String productId,  String productName,  String productImage,  String color,  double price,  double originalPrice,  int quantity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CartItemEntity() when $default != null:
return $default(_that.productId,_that.productName,_that.productImage,_that.color,_that.price,_that.originalPrice,_that.quantity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String productId,  String productName,  String productImage,  String color,  double price,  double originalPrice,  int quantity)  $default,) {final _that = this;
switch (_that) {
case _CartItemEntity():
return $default(_that.productId,_that.productName,_that.productImage,_that.color,_that.price,_that.originalPrice,_that.quantity);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String productId,  String productName,  String productImage,  String color,  double price,  double originalPrice,  int quantity)?  $default,) {final _that = this;
switch (_that) {
case _CartItemEntity() when $default != null:
return $default(_that.productId,_that.productName,_that.productImage,_that.color,_that.price,_that.originalPrice,_that.quantity);case _:
  return null;

}
}

}

/// @nodoc


class _CartItemEntity extends CartItemEntity {
  const _CartItemEntity({required this.productId, required this.productName, required this.productImage, required this.color, required this.price, this.originalPrice = 0.0, this.quantity = 1}): super._();
  

@override final  String productId;
@override final  String productName;
@override final  String productImage;
@override final  String color;
@override final  double price;
@override@JsonKey() final  double originalPrice;
@override@JsonKey() final  int quantity;

/// Create a copy of CartItemEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CartItemEntityCopyWith<_CartItemEntity> get copyWith => __$CartItemEntityCopyWithImpl<_CartItemEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CartItemEntity&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.productImage, productImage) || other.productImage == productImage)&&(identical(other.color, color) || other.color == color)&&(identical(other.price, price) || other.price == price)&&(identical(other.originalPrice, originalPrice) || other.originalPrice == originalPrice)&&(identical(other.quantity, quantity) || other.quantity == quantity));
}


@override
int get hashCode => Object.hash(runtimeType,productId,productName,productImage,color,price,originalPrice,quantity);

@override
String toString() {
  return 'CartItemEntity(productId: $productId, productName: $productName, productImage: $productImage, color: $color, price: $price, originalPrice: $originalPrice, quantity: $quantity)';
}


}

/// @nodoc
abstract mixin class _$CartItemEntityCopyWith<$Res> implements $CartItemEntityCopyWith<$Res> {
  factory _$CartItemEntityCopyWith(_CartItemEntity value, $Res Function(_CartItemEntity) _then) = __$CartItemEntityCopyWithImpl;
@override @useResult
$Res call({
 String productId, String productName, String productImage, String color, double price, double originalPrice, int quantity
});




}
/// @nodoc
class __$CartItemEntityCopyWithImpl<$Res>
    implements _$CartItemEntityCopyWith<$Res> {
  __$CartItemEntityCopyWithImpl(this._self, this._then);

  final _CartItemEntity _self;
  final $Res Function(_CartItemEntity) _then;

/// Create a copy of CartItemEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productId = null,Object? productName = null,Object? productImage = null,Object? color = null,Object? price = null,Object? originalPrice = null,Object? quantity = null,}) {
  return _then(_CartItemEntity(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,productImage: null == productImage ? _self.productImage : productImage // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,originalPrice: null == originalPrice ? _self.originalPrice : originalPrice // ignore: cast_nullable_to_non_nullable
as double,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
