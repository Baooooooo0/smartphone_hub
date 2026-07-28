// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AddressModel {

 String get label; String get recipientName; String get phone; String get street; String get ward; String get district; String get province; bool get isDefault;
/// Create a copy of AddressModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddressModelCopyWith<AddressModel> get copyWith => _$AddressModelCopyWithImpl<AddressModel>(this as AddressModel, _$identity);

  /// Serializes this AddressModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddressModel
  &&(identical(other.label, label) || other.label == label)
  &&(identical(other.recipientName, recipientName) || other.recipientName == recipientName)
  &&(identical(other.phone, phone) || other.phone == phone)
  &&(identical(other.street, street) || other.street == street)
  &&(identical(other.ward, ward) || other.ward == ward)
  &&(identical(other.district, district) || other.district == district)
  &&(identical(other.province, province) || other.province == province)
  &&(identical(other.isDefault, isDefault) || other.isDefault == isDefault));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,recipientName,phone,street,ward,district,province,isDefault);

@override
String toString() {
  return 'AddressModel(label: $label, recipientName: $recipientName, phone: $phone, street: $street, ward: $ward, district: $district, province: $province, isDefault: $isDefault)';
}


}

/// @nodoc
abstract mixin class $AddressModelCopyWith<$Res>  {
  factory $AddressModelCopyWith(AddressModel value, $Res Function(AddressModel) _then) = _$AddressModelCopyWithImpl;
@useResult
$Res call({
 String label, String recipientName, String phone, String street, String ward, String district, String province, bool isDefault
});




}
/// @nodoc
class _$AddressModelCopyWithImpl<$Res>
    implements $AddressModelCopyWith<$Res> {
  _$AddressModelCopyWithImpl(this._self, this._then);

  final AddressModel _self;
  final $Res Function(AddressModel) _then;

/// Create a copy of AddressModel
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


/// Adds pattern-matching-related methods to [AddressModel].
extension AddressModelPatterns on AddressModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AddressModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AddressModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AddressModel value)  $default,){
final _that = this;
switch (_that) {
case _AddressModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AddressModel value)?  $default,){
final _that = this;
switch (_that) {
case _AddressModel() when $default != null:
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
case _AddressModel() when $default != null:
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
case _AddressModel():
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
case _AddressModel() when $default != null:
return $default(_that.label,_that.recipientName,_that.phone,_that.street,_that.ward,_that.district,_that.province,_that.isDefault);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AddressModel extends AddressModel {
  const _AddressModel({required this.label, required this.recipientName, required this.phone, required this.street, required this.ward, required this.district, required this.province, this.isDefault = false}): super._();
  factory _AddressModel.fromJson(Map<String, dynamic> json) => _$AddressModelFromJson(json);

@override final  String label;
@override final  String recipientName;
@override final  String phone;
@override final  String street;
@override final  String ward;
@override final  String district;
@override final  String province;
@override@JsonKey() final  bool isDefault;

/// Create a copy of AddressModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddressModelCopyWith<_AddressModel> get copyWith => __$AddressModelCopyWithImpl<_AddressModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AddressModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AddressModel&&(identical(other.label, label) || other.label == label)&&(identical(other.recipientName, recipientName) || other.recipientName == recipientName)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.street, street) || other.street == street)&&(identical(other.ward, ward) || other.ward == ward)&&(identical(other.district, district) || other.district == district)&&(identical(other.province, province) || other.province == province)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,recipientName,phone,street,ward,district,province,isDefault);

@override
String toString() {
  return 'AddressModel(label: $label, recipientName: $recipientName, phone: $phone, street: $street, ward: $ward, district: $district, province: $province, isDefault: $isDefault)';
}


}

/// @nodoc
abstract mixin class _$AddressModelCopyWith<$Res> implements $AddressModelCopyWith<$Res> {
  factory _$AddressModelCopyWith(_AddressModel value, $Res Function(_AddressModel) _then) = __$AddressModelCopyWithImpl;
@override @useResult
$Res call({
 String label, String recipientName, String phone, String street, String ward, String district, String province, bool isDefault
});




}
/// @nodoc
class __$AddressModelCopyWithImpl<$Res>
    implements _$AddressModelCopyWith<$Res> {
  __$AddressModelCopyWithImpl(this._self, this._then);

  final _AddressModel _self;
  final $Res Function(_AddressModel) _then;

/// Create a copy of AddressModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? label = null,Object? recipientName = null,Object? phone = null,Object? street = null,Object? ward = null,Object? district = null,Object? province = null,Object? isDefault = null,}) {
  return _then(_AddressModel(
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
mixin _$UserModel {

 String get id; String get email; String get displayName; String get photoURL; String get phoneNumber; String get role; List<AddressModel> get addresses; DateTime? get createdAt; List<String> get fcmTokens;
/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserModelCopyWith<UserModel> get copyWith => _$UserModelCopyWithImpl<UserModel>(this as UserModel, _$identity);

  /// Serializes this UserModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.photoURL, photoURL) || other.photoURL == photoURL)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.role, role) || other.role == role)&&const DeepCollectionEquality().equals(other.addresses, addresses)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.fcmTokens, fcmTokens));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,displayName,photoURL,phoneNumber,role,const DeepCollectionEquality().hash(addresses),createdAt,const DeepCollectionEquality().hash(fcmTokens));

@override
String toString() {
  return 'UserModel(id: $id, email: $email, displayName: $displayName, photoURL: $photoURL, phoneNumber: $phoneNumber, role: $role, addresses: $addresses, createdAt: $createdAt, fcmTokens: $fcmTokens)';
}


}

/// @nodoc
abstract mixin class $UserModelCopyWith<$Res>  {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) _then) = _$UserModelCopyWithImpl;
@useResult
$Res call({
 String id, String email, String displayName, String photoURL, String phoneNumber, String role, List<AddressModel> addresses, DateTime? createdAt, List<String> fcmTokens
});




}
/// @nodoc
class _$UserModelCopyWithImpl<$Res>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._self, this._then);

  final UserModel _self;
  final $Res Function(UserModel) _then;

/// Create a copy of UserModel
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
as List<AddressModel>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,fcmTokens: null == fcmTokens ? _self.fcmTokens : fcmTokens // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [UserModel].
extension UserModelPatterns on UserModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserModel value)  $default,){
final _that = this;
switch (_that) {
case _UserModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserModel value)?  $default,){
final _that = this;
switch (_that) {
case _UserModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String email,  String displayName,  String photoURL,  String phoneNumber,  String role,  List<AddressModel> addresses,  DateTime? createdAt,  List<String> fcmTokens)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String email,  String displayName,  String photoURL,  String phoneNumber,  String role,  List<AddressModel> addresses,  DateTime? createdAt,  List<String> fcmTokens)  $default,) {final _that = this;
switch (_that) {
case _UserModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String email,  String displayName,  String photoURL,  String phoneNumber,  String role,  List<AddressModel> addresses,  DateTime? createdAt,  List<String> fcmTokens)?  $default,) {final _that = this;
switch (_that) {
case _UserModel() when $default != null:
return $default(_that.id,_that.email,_that.displayName,_that.photoURL,_that.phoneNumber,_that.role,_that.addresses,_that.createdAt,_that.fcmTokens);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserModel extends UserModel {
  const _UserModel({required this.id, required this.email, required this.displayName, this.photoURL = '', this.phoneNumber = '', this.role = 'customer', final  List<AddressModel> addresses = const [], this.createdAt, final  List<String> fcmTokens = const []}): _addresses = addresses,_fcmTokens = fcmTokens,super._();
  factory _UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

@override final  String id;
@override final  String email;
@override final  String displayName;
@override@JsonKey() final  String photoURL;
@override@JsonKey() final  String phoneNumber;
@override@JsonKey() final  String role;
 final  List<AddressModel> _addresses;
@override@JsonKey() List<AddressModel> get addresses {
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


/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserModelCopyWith<_UserModel> get copyWith => __$UserModelCopyWithImpl<_UserModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.photoURL, photoURL) || other.photoURL == photoURL)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.role, role) || other.role == role)&&const DeepCollectionEquality().equals(other._addresses, _addresses)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other._fcmTokens, _fcmTokens));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,displayName,photoURL,phoneNumber,role,const DeepCollectionEquality().hash(_addresses),createdAt,const DeepCollectionEquality().hash(_fcmTokens));

@override
String toString() {
  return 'UserModel(id: $id, email: $email, displayName: $displayName, photoURL: $photoURL, phoneNumber: $phoneNumber, role: $role, addresses: $addresses, createdAt: $createdAt, fcmTokens: $fcmTokens)';
}


}

/// @nodoc
abstract mixin class _$UserModelCopyWith<$Res> implements $UserModelCopyWith<$Res> {
  factory _$UserModelCopyWith(_UserModel value, $Res Function(_UserModel) _then) = __$UserModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String email, String displayName, String photoURL, String phoneNumber, String role, List<AddressModel> addresses, DateTime? createdAt, List<String> fcmTokens
});




}
/// @nodoc
class __$UserModelCopyWithImpl<$Res>
    implements _$UserModelCopyWith<$Res> {
  __$UserModelCopyWithImpl(this._self, this._then);

  final _UserModel _self;
  final $Res Function(_UserModel) _then;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? email = null,Object? displayName = null,Object? photoURL = null,Object? phoneNumber = null,Object? role = null,Object? addresses = null,Object? createdAt = freezed,Object? fcmTokens = null,}) {
  return _then(_UserModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,photoURL: null == photoURL ? _self.photoURL : photoURL // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,addresses: null == addresses ? _self._addresses : addresses // ignore: cast_nullable_to_non_nullable
as List<AddressModel>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,fcmTokens: null == fcmTokens ? _self._fcmTokens : fcmTokens // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
