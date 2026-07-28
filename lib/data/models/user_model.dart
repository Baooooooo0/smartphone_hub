import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user_entity.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// AddressModel — DTO cho địa chỉ giao hàng
@freezed
abstract class AddressModel with _$AddressModel {
  const factory AddressModel({
    required String label,
    required String recipientName,
    required String phone,
    required String street,
    required String ward,
    required String district,
    required String province,
    @Default(false) bool isDefault,
  }) = _AddressModel;

  factory AddressModel.fromJson(Map<String, dynamic> json) =>
      _$AddressModelFromJson(json);

  const AddressModel._();

  factory AddressModel.fromEntity(Address entity) => AddressModel(
        label: entity.label,
        recipientName: entity.recipientName,
        phone: entity.phone,
        street: entity.street,
        ward: entity.ward,
        district: entity.district,
        province: entity.province,
        isDefault: entity.isDefault,
      );

  Address toEntity() => Address(
        label: label,
        recipientName: recipientName,
        phone: phone,
        street: street,
        ward: ward,
        district: district,
        province: province,
        isDefault: isDefault,
      );
}

/// UserModel — Data Transfer Object cho Firestore /users/{uid}
@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    required String displayName,
    @Default('') String photoURL,
    @Default('') String phoneNumber,
    @Default('customer') String role,
    @Default([]) List<AddressModel> addresses,
    DateTime? createdAt,
    @Default([]) List<String> fcmTokens,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  const UserModel._();

  factory UserModel.fromFirestore(Map<String, dynamic> data, String id) {
    return UserModel(
      id: id,
      email: data['email'] as String? ?? '',
      displayName: data['displayName'] as String? ?? '',
      photoURL: data['photoURL'] as String? ?? '',
      phoneNumber: data['phoneNumber'] as String? ?? '',
      role: data['role'] as String? ?? 'customer',
      addresses: (data['addresses'] as List<dynamic>?)
              ?.map((a) => AddressModel.fromJson(a as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as dynamic).toDate() as DateTime
          : null,
      fcmTokens: (data['fcmTokens'] as List<dynamic>?)
              ?.map((t) => t as String)
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toFirestore() => {
        'id': id,
        'email': email,
        'displayName': displayName,
        'photoURL': photoURL,
        'phoneNumber': phoneNumber,
        'role': role,
        'addresses': addresses.map((a) => a.toJson()).toList(),
        'createdAt': createdAt,
        'fcmTokens': fcmTokens,
      };

  UserEntity toEntity() => UserEntity(
        id: id,
        email: email,
        displayName: displayName,
        photoURL: photoURL,
        phoneNumber: phoneNumber,
        role: role,
        addresses: addresses.map((a) => a.toEntity()).toList(),
        createdAt: createdAt,
        fcmTokens: fcmTokens,
      );

  factory UserModel.fromEntity(UserEntity entity) => UserModel(
        id: entity.id,
        email: entity.email,
        displayName: entity.displayName,
        photoURL: entity.photoURL,
        phoneNumber: entity.phoneNumber,
        role: entity.role,
        addresses: entity.addresses
            .map((a) => AddressModel.fromEntity(a))
            .toList(),
        createdAt: entity.createdAt,
        fcmTokens: entity.fcmTokens,
      );
}
