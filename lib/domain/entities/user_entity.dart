import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_entity.freezed.dart';

/// Address — địa chỉ giao hàng của user
@freezed
abstract class Address with _$Address {
  const factory Address({
    required String label,
    required String recipientName,
    required String phone,
    required String street,
    required String ward,
    required String district,
    required String province,
    @Default(false) bool isDefault,
  }) = _Address;
}

/// UserEntity — Business entity, không phụ thuộc Firebase
@freezed
abstract class UserEntity with _$UserEntity {
  const factory UserEntity({
    required String id,
    required String email,
    required String displayName,
    @Default('') String photoURL,
    @Default('') String phoneNumber,
    @Default('customer') String role,
    @Default([]) List<Address> addresses,
    DateTime? createdAt,
    @Default([]) List<String> fcmTokens,
  }) = _UserEntity;

  const UserEntity._();

  bool get isAdmin => role == 'admin';
  bool get isCustomer => role == 'customer';

  Address? get defaultAddress =>
      addresses.where((a) => a.isDefault).firstOrNull;
}
