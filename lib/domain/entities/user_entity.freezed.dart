// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Address {

 String get label; String get recipientName; String get phone; String get street; String get ward; String get district; String get province; bool get isDefault;
/// Create a copy of Address
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddressCopyWith<Address> get copyWith => _$AddressCopyWithImpl<Address>(this as Address, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Address&&(identical(other.label, label) || other.label == label)&&(identical(other.recipientName, recipientName) || other.recipientName == recipientName)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.street, street) || other.street == street)&&(identical(other.ward, ward) || other.ward == ward)&&(identical(other.district, district) || other.district == district)&&(identical(other.province, province) || other.province == province)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault));
}


@override
int get hashCode => Object.hash(runtimeType,label,recipientName,phone,street,ward,district,province,isDefault);

@override
String toString() {
  return 'Address(label: $label, recipientName: $recipientName, phone: $phone, street: $street, ward: $ward, district: $district, province: $province, isDefault: $isDefault)';
}


}

/// @nodoc
abstract mixin class $AddressCopyWith<$Res>  {
  factory $AddressCopyWith(Address value, $Res Function(Address) _then) = _$AddressCopyWithImpl;
@useResult
$Res call({
 String label, String recipientName, String phone, String street, String ward, String district, String province, bool isDefault
});




}
/// @nodoc
class _$AddressCopyWithImpl<$Res>
    implements $AddressCopyWith<$Res> {
  _$AddressCopyWithImpl(this._self, this._then);

  final Address _self;
  final $Res Function(Address) _then;

/// Create a copy of Address
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? label = null,Object? recipientName = null,Object? phone = null,Object? street = null,Object? ward = null,Object? district = null,Object? province = null,Object? isDefault = null,}) {
  return _then(_self.copyWith(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,recipientName: null == recipientName ? _self.recipientName : recipientName // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,street: null == street ? _self.street : street // ignore: cast_nullable_to_non_nullable
as String,ward: null == ward ? _self.ward : ward // ignore: cast_nullable_to_non_nullable
as String,district: null == district ? _self.district : district // ignore: cast_nullable_to_non_nullable
as String,province: null == province ? _self.province : province // ignore: cast_nullable_to_non_nullable
as String,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Address].
extension AddressPatterns on Address {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Address value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Address() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Address value)  $default,){
final _that = this;
switch (_that) {
case _Address():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Address value)?  $default,){
final _that = this;
switch (_that) {
case _Address() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String label,  String recipientName,  String phone,  String street,  String ward,  String district,  String province,  bool isDefault)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Address() when $default != null:
return $default(_that.label,_that.recipientName,_that.phone,_that.street,_that.ward,_that.district,_that.province,_that.isDefault);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String label,  String recipientName,  String phone,  String street,  String ward,  String district,  String province,  bool isDefault)  $default,) {final _that = this;
switch (_that) {
case _Address():
return $default(_that.label,_that.recipientName,_that.phone,_that.street,_that.ward,_that.district,_that.province,_that.isDefault);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String label,  String recipientName,  String phone,  String street,  String ward,  String district,  String province,  bool isDefault)?  $default,) {final _that = this;
switch (_that) {
case _Address() when $default != null:
return $default(_that.label,_that.recipientName,_that.phone,_that.street,_that.ward,_that.district,_that.province,_that.isDefault);case _:
  return null;

}
}

}

/// @nodoc


class _Address implements Address {
  const _Address({required this.label, required this.recipientName, required this.phone, required this.street, required this.ward, required this.district, required this.province, this.isDefault = false});
  

@override final  String label;
@override final  String recipientName;
@override final  String phone;
@override final  String street;
@override final  String ward;
@override final  String district;
@override final  String province;
@override@JsonKey() final  bool isDefault;

/// Create a copy of Address
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddressCopyWith<_Address> get copyWith => __$AddressCopyWithImpl<_Address>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Address&&(identical(other.label, label) || other.label == label)&&(identical(other.recipientName, recipientName) || other.recipientName == recipientName)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.street, street) || other.street == street)&&(identical(other.ward, ward) || other.ward == ward)&&(identical(other.district, district) || other.district == district)&&(identical(other.province, province) || other.province == province)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault));
}


@override
int get hashCode => Object.hash(runtimeType,label,recipientName,phone,street,ward,district,province,isDefault);

@override
String toString() {
  return 'Address(label: $label, recipientName: $recipientName, phone: $phone, street: $street, ward: $ward, district: $district, province: $province, isDefault: $isDefault)';
}


}

/// @nodoc
abstract mixin class _$AddressCopyWith<$Res> implements $AddressCopyWith<$Res> {
  factory _$AddressCopyWith(_Address value, $Res Function(_Address) _then) = __$AddressCopyWithImpl;
@override @useResult
$Res call({
 String label, String recipientName, String phone, String street, String ward, String district, String province, bool isDefault
});




}
/// @nodoc
class __$AddressCopyWithImpl<$Res>
    implements _$AddressCopyWith<$Res> {
  __$AddressCopyWithImpl(this._self, this._then);

  final _Address _self;
  final $Res Function(_Address) _then;

/// Create a copy of Address
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? label = null,Object? recipientName = null,Object? phone = null,Object? street = null,Object? ward = null,Object? district = null,Object? province = null,Object? isDefault = null,}) {
  return _then(_Address(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,recipientName: null == recipientName ? _self.recipientName : recipientName // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,street: null == street ? _self.street : street // ignore: cast_nullable_to_non_nullable
as String,ward: null == ward ? _self.ward : ward // ignore: cast_nullable_to_non_nullable
as String,district: null == district ? _self.district : district // ignore: cast_nullable_to_non_nullable
as String,province: null == province ? _self.province : province // ignore: cast_nullable_to_non_nullable
as String,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$UserEntity {

 String get id; String get email; String get displayName; String get photoURL; String get phoneNumber; String get role; List<Address> get addresses; DateTime? get createdAt; List<String> get fcmTokens;
/// Create a copy of UserEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserEntityCopyWith<UserEntity> get copyWith => _$UserEntityCopyWithImpl<UserEntity>(this as UserEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.photoURL, photoURL) || other.photoURL == photoURL)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.role, role) || other.role == role)&&const DeepCollectionEquality().equals(other.addresses, addresses)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.fcmTokens, fcmTokens));
}


@override
int get hashCode => Object.hash(runtimeType,id,email,displayName,photoURL,phoneNumber,role,const DeepCollectionEquality().hash(addresses),createdAt,const DeepCollectionEquality().hash(fcmTokens));

@override
String toString() {
  return 'UserEntity(id: $id, email: $email, displayName: $displayName, photoURL: $photoURL, phoneNumber: $phoneNumber, role: $role, addresses: $addresses, createdAt: $createdAt, fcmTokens: $fcmTokens)';
}


}

/// @nodoc
abstract mixin class $UserEntityCopyWith<$Res>  {
  factory $UserEntityCopyWith(UserEntity value, $Res Function(UserEntity) _then) = _$UserEntityCopyWithImpl;
@useResult
$Res call({
 String id, String email, String displayName, String photoURL, String phoneNumber, String role, List<Address> addresses, DateTime? createdAt, List<String> fcmTokens
});




}
/// @nodoc
class _$UserEntityCopyWithImpl<$Res>
    implements $UserEntityCopyWith<$Res> {
  _$UserEntityCopyWithImpl(this._self, this._then);

  final UserEntity _self;
  final $Res Function(UserEntity) _then;

/// Create a copy of UserEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? email = null,Object? displayName = null,Object? photoURL = null,Object? phoneNumber = null,Object? role = null,Object? addresses = null,Object? createdAt = freezed,Object? fcmTokens = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,photoURL: null == photoURL ? _self.photoURL : photoURL // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,addresses: null == addresses ? _self.addresses : addresses // ignore: cast_nullable_to_non_nullable
as List<Address>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,fcmTokens: null == fcmTokens ? _self.fcmTokens : fcmTokens // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [UserEntity].
extension UserEntityPatterns on UserEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserEntity value)  $default,){
final _that = this;
switch (_that) {
case _UserEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserEntity value)?  $default,){
final _that = this;
switch (_that) {
case _UserEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String email,  String displayName,  String photoURL,  String phoneNumber,  String role,  List<Address> addresses,  DateTime? createdAt,  List<String> fcmTokens)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserEntity() when $default != null:
return $default(_that.id,_that.email,_that.displayName,_that.photoURL,_that.phoneNumber,_that.role,_that.addresses,_that.createdAt,_that.fcmTokens);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String email,  String displayName,  String photoURL,  String phoneNumber,  String role,  List<Address> addresses,  DateTime? createdAt,  List<String> fcmTokens)  $default,) {final _that = this;
switch (_that) {
case _UserEntity():
return $default(_that.id,_that.email,_that.displayName,_that.photoURL,_that.phoneNumber,_that.role,_that.addresses,_that.createdAt,_that.fcmTokens);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String email,  String displayName,  String photoURL,  String phoneNumber,  String role,  List<Address> addresses,  DateTime? createdAt,  List<String> fcmTokens)?  $default,) {final _that = this;
switch (_that) {
case _UserEntity() when $default != null:
return $default(_that.id,_that.email,_that.displayName,_that.photoURL,_that.phoneNumber,_that.role,_that.addresses,_that.createdAt,_that.fcmTokens);case _:
  return null;

}
}

}

/// @nodoc


class _UserEntity extends UserEntity {
  const _UserEntity({required this.id, required this.email, required this.displayName, this.photoURL = '', this.phoneNumber = '', this.role = 'customer', final  List<Address> addresses = const [], this.createdAt, final  List<String> fcmTokens = const []}): _addresses = addresses,_fcmTokens = fcmTokens,super._();
  

@override final  String id;
@override final  String email;
@override final  String displayName;
@override@JsonKey() final  String photoURL;
@override@JsonKey() final  String phoneNumber;
@override@JsonKey() final  String role;
 final  List<Address> _addresses;
@override@JsonKey() List<Address> get addresses {
  if (_addresses is EqualUnmodifiableListView) return _addresses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_addresses);
}

@override final  DateTime? createdAt;
 final  List<String> _fcmTokens;
@override@JsonKey() List<String> get fcmTokens {
  if (_fcmTokens is EqualUnmodifiableListView) return _fcmTokens;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_fcmTokens);
}


/// Create a copy of UserEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserEntityCopyWith<_UserEntity> get copyWith => __$UserEntityCopyWithImpl<_UserEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.photoURL, photoURL) || other.photoURL == photoURL)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.role, role) || other.role == role)&&const DeepCollectionEquality().equals(other._addresses, _addresses)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other._fcmTokens, _fcmTokens));
}


@override
int get hashCode => Object.hash(runtimeType,id,email,displayName,photoURL,phoneNumber,role,const DeepCollectionEquality().hash(_addresses),createdAt,const DeepCollectionEquality().hash(_fcmTokens));

@override
String toString() {
  return 'UserEntity(id: $id, email: $email, displayName: $displayName, photoURL: $photoURL, phoneNumber: $phoneNumber, role: $role, addresses: $addresses, createdAt: $createdAt, fcmTokens: $fcmTokens)';
}


}

/// @nodoc
abstract mixin class _$UserEntityCopyWith<$Res> implements $UserEntityCopyWith<$Res> {
  factory _$UserEntityCopyWith(_UserEntity value, $Res Function(_UserEntity) _then) = __$UserEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String email, String displayName, String photoURL, String phoneNumber, String role, List<Address> addresses, DateTime? createdAt, List<String> fcmTokens
});




}
/// @nodoc
class __$UserEntityCopyWithImpl<$Res>
    implements _$UserEntityCopyWith<$Res> {
  __$UserEntityCopyWithImpl(this._self, this._then);

  final _UserEntity _self;
  final $Res Function(_UserEntity) _then;

/// Create a copy of UserEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? email = null,Object? displayName = null,Object? photoURL = null,Object? phoneNumber = null,Object? role = null,Object? addresses = null,Object? createdAt = freezed,Object? fcmTokens = null,}) {
  return _then(_UserEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,photoURL: null == photoURL ? _self.photoURL : photoURL // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,addresses: null == addresses ? _self._addresses : addresses // ignore: cast_nullable_to_non_nullable
as List<Address>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,fcmTokens: null == fcmTokens ? _self._fcmTokens : fcmTokens // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
