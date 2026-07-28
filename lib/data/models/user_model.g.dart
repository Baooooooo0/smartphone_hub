// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AddressModel _$AddressModelFromJson(Map<String, dynamic> json) =>
    _AddressModel(
      label: json['label'] as String,
      recipientName: json['recipient_name'] as String,
      phone: json['phone'] as String,
      street: json['street'] as String,
      ward: json['ward'] as String,
      district: json['district'] as String,
      province: json['province'] as String,
      isDefault: json['is_default'] as bool? ?? false,
    );

Map<String, dynamic> _$AddressModelToJson(_AddressModel instance) =>
    <String, dynamic>{
      'label': instance.label,
      'recipient_name': instance.recipientName,
      'phone': instance.phone,
      'street': instance.street,
      'ward': instance.ward,
      'district': instance.district,
      'province': instance.province,
      'is_default': instance.isDefault,
    };

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
  id: json['id'] as String,
  email: json['email'] as String,
  displayName: json['display_name'] as String,
  photoURL: json['photo_u_r_l'] as String? ?? '',
  phoneNumber: json['phone_number'] as String? ?? '',
  role: json['role'] as String? ?? 'customer',
  addresses:
      (json['addresses'] as List<dynamic>?)
          ?.map((e) => AddressModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  fcmTokens:
      (json['fcm_tokens'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
);

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'display_name': instance.displayName,
      'photo_u_r_l': instance.photoURL,
      'phone_number': instance.phoneNumber,
      'role': instance.role,
      'addresses': instance.addresses.map((e) => e.toJson()).toList(),
      'created_at': instance.createdAt?.toIso8601String(),
      'fcm_tokens': instance.fcmTokens,
    };
