// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProductEntity {

 String get id; String get name; String get brand; String get category; String get description; double get price; double get discountPrice; List<String> get images; Map<String, String> get specs; List<String> get colors; int get stock; int get sold; double get rating; int get reviewCount; List<String> get tags; bool get isActive; bool get isFeatured; DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of ProductEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductEntityCopyWith<ProductEntity> get copyWith => _$ProductEntityCopyWithImpl<ProductEntity>(this as ProductEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.category, category) || other.category == category)&&(identical(other.description, description) || other.description == description)&&(identical(other.price, price) || other.price == price)&&(identical(other.discountPrice, discountPrice) || other.discountPrice == discountPrice)&&const DeepCollectionEquality().equals(other.images, images)&&const DeepCollectionEquality().equals(other.specs, specs)&&const DeepCollectionEquality().equals(other.colors, colors)&&(identical(other.stock, stock) || other.stock == stock)&&(identical(other.sold, sold) || other.sold == sold)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.reviewCount, reviewCount) || other.reviewCount == reviewCount)&&const DeepCollectionEquality().equals(other.tags, tags)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.isFeatured, isFeatured) || other.isFeatured == isFeatured)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,name,brand,category,description,price,discountPrice,const DeepCollectionEquality().hash(images),const DeepCollectionEquality().hash(specs),const DeepCollectionEquality().hash(colors),stock,sold,rating,reviewCount,const DeepCollectionEquality().hash(tags),isActive,isFeatured,createdAt,updatedAt]);

@override
String toString() {
  return 'ProductEntity(id: $id, name: $name, brand: $brand, category: $category, description: $description, price: $price, discountPrice: $discountPrice, images: $images, specs: $specs, colors: $colors, stock: $stock, sold: $sold, rating: $rating, reviewCount: $reviewCount, tags: $tags, isActive: $isActive, isFeatured: $isFeatured, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ProductEntityCopyWith<$Res>  {
  factory $ProductEntityCopyWith(ProductEntity value, $Res Function(ProductEntity) _then) = _$ProductEntityCopyWithImpl;
@useResult
$Res call({
 String id, String name, String brand, String category, String description, double price, double discountPrice, List<String> images, Map<String, String> specs, List<String> colors, int stock, int sold, double rating, int reviewCount, List<String> tags, bool isActive, bool isFeatured, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$ProductEntityCopyWithImpl<$Res>
    implements $ProductEntityCopyWith<$Res> {
  _$ProductEntityCopyWithImpl(this._self, this._then);

  final ProductEntity _self;
  final $Res Function(ProductEntity) _then;

/// Create a copy of ProductEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? brand = null,Object? category = null,Object? description = null,Object? price = null,Object? discountPrice = null,Object? images = null,Object? specs = null,Object? colors = null,Object? stock = null,Object? sold = null,Object? rating = null,Object? reviewCount = null,Object? tags = null,Object? isActive = null,Object? isFeatured = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,brand: null == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,discountPrice: null == discountPrice ? _self.discountPrice : discountPrice // ignore: cast_nullable_to_non_nullable
as double,images: null == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as List<String>,specs: null == specs ? _self.specs : specs // ignore: cast_nullable_to_non_nullable
as Map<String, String>,colors: null == colors ? _self.colors : colors // ignore: cast_nullable_to_non_nullable
as List<String>,stock: null == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as int,sold: null == sold ? _self.sold : sold // ignore: cast_nullable_to_non_nullable
as int,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,reviewCount: null == reviewCount ? _self.reviewCount : reviewCount // ignore: cast_nullable_to_non_nullable
as int,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,isFeatured: null == isFeatured ? _self.isFeatured : isFeatured // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductEntity].
extension ProductEntityPatterns on ProductEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductEntity value)  $default,){
final _that = this;
switch (_that) {
case _ProductEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ProductEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String brand,  String category,  String description,  double price,  double discountPrice,  List<String> images,  Map<String, String> specs,  List<String> colors,  int stock,  int sold,  double rating,  int reviewCount,  List<String> tags,  bool isActive,  bool isFeatured,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductEntity() when $default != null:
return $default(_that.id,_that.name,_that.brand,_that.category,_that.description,_that.price,_that.discountPrice,_that.images,_that.specs,_that.colors,_that.stock,_that.sold,_that.rating,_that.reviewCount,_that.tags,_that.isActive,_that.isFeatured,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String brand,  String category,  String description,  double price,  double discountPrice,  List<String> images,  Map<String, String> specs,  List<String> colors,  int stock,  int sold,  double rating,  int reviewCount,  List<String> tags,  bool isActive,  bool isFeatured,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _ProductEntity():
return $default(_that.id,_that.name,_that.brand,_that.category,_that.description,_that.price,_that.discountPrice,_that.images,_that.specs,_that.colors,_that.stock,_that.sold,_that.rating,_that.reviewCount,_that.tags,_that.isActive,_that.isFeatured,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String brand,  String category,  String description,  double price,  double discountPrice,  List<String> images,  Map<String, String> specs,  List<String> colors,  int stock,  int sold,  double rating,  int reviewCount,  List<String> tags,  bool isActive,  bool isFeatured,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ProductEntity() when $default != null:
return $default(_that.id,_that.name,_that.brand,_that.category,_that.description,_that.price,_that.discountPrice,_that.images,_that.specs,_that.colors,_that.stock,_that.sold,_that.rating,_that.reviewCount,_that.tags,_that.isActive,_that.isFeatured,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _ProductEntity extends ProductEntity {
  const _ProductEntity({required this.id, required this.name, required this.brand, required this.category, this.description = '', required this.price, this.discountPrice = 0, final  List<String> images = const [], final  Map<String, String> specs = const {}, final  List<String> colors = const [], this.stock = 0, this.sold = 0, this.rating = 0.0, this.reviewCount = 0, final  List<String> tags = const [], this.isActive = true, this.isFeatured = false, this.createdAt, this.updatedAt}): _images = images,_specs = specs,_colors = colors,_tags = tags,super._();
  

@override final  String id;
@override final  String name;
@override final  String brand;
@override final  String category;
@override@JsonKey() final  String description;
@override final  double price;
@override@JsonKey() final  double discountPrice;
 final  List<String> _images;
@override@JsonKey() List<String> get images {
  if (_images is EqualUnmodifiableListView) return _images;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_images);
}

 final  Map<String, String> _specs;
@override@JsonKey() Map<String, String> get specs {
  if (_specs is EqualUnmodifiableMapView) return _specs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_specs);
}

 final  List<String> _colors;
@override@JsonKey() List<String> get colors {
  if (_colors is EqualUnmodifiableListView) return _colors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_colors);
}

@override@JsonKey() final  int stock;
@override@JsonKey() final  int sold;
@override@JsonKey() final  double rating;
@override@JsonKey() final  int reviewCount;
 final  List<String> _tags;
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

@override@JsonKey() final  bool isActive;
@override@JsonKey() final  bool isFeatured;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of ProductEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductEntityCopyWith<_ProductEntity> get copyWith => __$ProductEntityCopyWithImpl<_ProductEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.category, category) || other.category == category)&&(identical(other.description, description) || other.description == description)&&(identical(other.price, price) || other.price == price)&&(identical(other.discountPrice, discountPrice) || other.discountPrice == discountPrice)&&const DeepCollectionEquality().equals(other._images, _images)&&const DeepCollectionEquality().equals(other._specs, _specs)&&const DeepCollectionEquality().equals(other._colors, _colors)&&(identical(other.stock, stock) || other.stock == stock)&&(identical(other.sold, sold) || other.sold == sold)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.reviewCount, reviewCount) || other.reviewCount == reviewCount)&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.isFeatured, isFeatured) || other.isFeatured == isFeatured)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,name,brand,category,description,price,discountPrice,const DeepCollectionEquality().hash(_images),const DeepCollectionEquality().hash(_specs),const DeepCollectionEquality().hash(_colors),stock,sold,rating,reviewCount,const DeepCollectionEquality().hash(_tags),isActive,isFeatured,createdAt,updatedAt]);

@override
String toString() {
  return 'ProductEntity(id: $id, name: $name, brand: $brand, category: $category, description: $description, price: $price, discountPrice: $discountPrice, images: $images, specs: $specs, colors: $colors, stock: $stock, sold: $sold, rating: $rating, reviewCount: $reviewCount, tags: $tags, isActive: $isActive, isFeatured: $isFeatured, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ProductEntityCopyWith<$Res> implements $ProductEntityCopyWith<$Res> {
  factory _$ProductEntityCopyWith(_ProductEntity value, $Res Function(_ProductEntity) _then) = __$ProductEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String brand, String category, String description, double price, double discountPrice, List<String> images, Map<String, String> specs, List<String> colors, int stock, int sold, double rating, int reviewCount, List<String> tags, bool isActive, bool isFeatured, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$ProductEntityCopyWithImpl<$Res>
    implements _$ProductEntityCopyWith<$Res> {
  __$ProductEntityCopyWithImpl(this._self, this._then);

  final _ProductEntity _self;
  final $Res Function(_ProductEntity) _then;

/// Create a copy of ProductEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? brand = null,Object? category = null,Object? description = null,Object? price = null,Object? discountPrice = null,Object? images = null,Object? specs = null,Object? colors = null,Object? stock = null,Object? sold = null,Object? rating = null,Object? reviewCount = null,Object? tags = null,Object? isActive = null,Object? isFeatured = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_ProductEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,brand: null == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,discountPrice: null == discountPrice ? _self.discountPrice : discountPrice // ignore: cast_nullable_to_non_nullable
as double,images: null == images ? _self._images : images // ignore: cast_nullable_to_non_nullable
as List<String>,specs: null == specs ? _self._specs : specs // ignore: cast_nullable_to_non_nullable
as Map<String, String>,colors: null == colors ? _self._colors : colors // ignore: cast_nullable_to_non_nullable
as List<String>,stock: null == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as int,sold: null == sold ? _self.sold : sold // ignore: cast_nullable_to_non_nullable
as int,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,reviewCount: null == reviewCount ? _self.reviewCount : reviewCount // ignore: cast_nullable_to_non_nullable
as int,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,isFeatured: null == isFeatured ? _self.isFeatured : isFeatured // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
