// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'banner_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BannerEntity {

 String get id; String get imageURL; String get targetType; String get targetId; bool get isActive; int get order;
/// Create a copy of BannerEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BannerEntityCopyWith<BannerEntity> get copyWith => _$BannerEntityCopyWithImpl<BannerEntity>(this as BannerEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BannerEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.imageURL, imageURL) || other.imageURL == imageURL)&&(identical(other.targetType, targetType) || other.targetType == targetType)&&(identical(other.targetId, targetId) || other.targetId == targetId)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.order, order) || other.order == order));
}


@override
int get hashCode => Object.hash(runtimeType,id,imageURL,targetType,targetId,isActive,order);

@override
String toString() {
  return 'BannerEntity(id: $id, imageURL: $imageURL, targetType: $targetType, targetId: $targetId, isActive: $isActive, order: $order)';
}


}

/// @nodoc
abstract mixin class $BannerEntityCopyWith<$Res>  {
  factory $BannerEntityCopyWith(BannerEntity value, $Res Function(BannerEntity) _then) = _$BannerEntityCopyWithImpl;
@useResult
$Res call({
 String id, String imageURL, String targetType, String targetId, bool isActive, int order
});




}
/// @nodoc
class _$BannerEntityCopyWithImpl<$Res>
    implements $BannerEntityCopyWith<$Res> {
  _$BannerEntityCopyWithImpl(this._self, this._then);

  final BannerEntity _self;
  final $Res Function(BannerEntity) _then;

/// Create a copy of BannerEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? imageURL = null,Object? targetType = null,Object? targetId = null,Object? isActive = null,Object? order = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,imageURL: null == imageURL ? _self.imageURL : imageURL // ignore: cast_nullable_to_non_nullable
as String,targetType: null == targetType ? _self.targetType : targetType // ignore: cast_nullable_to_non_nullable
as String,targetId: null == targetId ? _self.targetId : targetId // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BannerEntity].
extension BannerEntityPatterns on BannerEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BannerEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BannerEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BannerEntity value)  $default,){
final _that = this;
switch (_that) {
case _BannerEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BannerEntity value)?  $default,){
final _that = this;
switch (_that) {
case _BannerEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String imageURL,  String targetType,  String targetId,  bool isActive,  int order)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BannerEntity() when $default != null:
return $default(_that.id,_that.imageURL,_that.targetType,_that.targetId,_that.isActive,_that.order);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String imageURL,  String targetType,  String targetId,  bool isActive,  int order)  $default,) {final _that = this;
switch (_that) {
case _BannerEntity():
return $default(_that.id,_that.imageURL,_that.targetType,_that.targetId,_that.isActive,_that.order);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String imageURL,  String targetType,  String targetId,  bool isActive,  int order)?  $default,) {final _that = this;
switch (_that) {
case _BannerEntity() when $default != null:
return $default(_that.id,_that.imageURL,_that.targetType,_that.targetId,_that.isActive,_that.order);case _:
  return null;

}
}

}

/// @nodoc


class _BannerEntity implements BannerEntity {
  const _BannerEntity({required this.id, required this.imageURL, this.targetType = 'external_url', this.targetId = '', this.isActive = true, this.order = 0});
  

@override final  String id;
@override final  String imageURL;
@override@JsonKey() final  String targetType;
@override@JsonKey() final  String targetId;
@override@JsonKey() final  bool isActive;
@override@JsonKey() final  int order;

/// Create a copy of BannerEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BannerEntityCopyWith<_BannerEntity> get copyWith => __$BannerEntityCopyWithImpl<_BannerEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BannerEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.imageURL, imageURL) || other.imageURL == imageURL)&&(identical(other.targetType, targetType) || other.targetType == targetType)&&(identical(other.targetId, targetId) || other.targetId == targetId)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.order, order) || other.order == order));
}


@override
int get hashCode => Object.hash(runtimeType,id,imageURL,targetType,targetId,isActive,order);

@override
String toString() {
  return 'BannerEntity(id: $id, imageURL: $imageURL, targetType: $targetType, targetId: $targetId, isActive: $isActive, order: $order)';
}


}

/// @nodoc
abstract mixin class _$BannerEntityCopyWith<$Res> implements $BannerEntityCopyWith<$Res> {
  factory _$BannerEntityCopyWith(_BannerEntity value, $Res Function(_BannerEntity) _then) = __$BannerEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String imageURL, String targetType, String targetId, bool isActive, int order
});




}
/// @nodoc
class __$BannerEntityCopyWithImpl<$Res>
    implements _$BannerEntityCopyWith<$Res> {
  __$BannerEntityCopyWithImpl(this._self, this._then);

  final _BannerEntity _self;
  final $Res Function(_BannerEntity) _then;

/// Create a copy of BannerEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? imageURL = null,Object? targetType = null,Object? targetId = null,Object? isActive = null,Object? order = null,}) {
  return _then(_BannerEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,imageURL: null == imageURL ? _self.imageURL : imageURL // ignore: cast_nullable_to_non_nullable
as String,targetType: null == targetType ? _self.targetType : targetType // ignore: cast_nullable_to_non_nullable
as String,targetId: null == targetId ? _self.targetId : targetId // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
