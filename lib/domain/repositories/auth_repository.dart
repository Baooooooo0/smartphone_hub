import '../entities/user_entity.dart';

/// AuthRepository — Abstract interface cho domain layer
/// Implementation nằm ở data/repositories/auth_repository_impl.dart
abstract interface class AuthRepository {
  /// Stream trạng thái đăng nhập (null = chưa đăng nhập)
  Stream<UserEntity?> get authStateChanges;

  /// Lấy user hiện tại (null nếu chưa đăng nhập)
  UserEntity? get currentUser;

  /// Đăng nhập bằng Email + Password
  Future<UserEntity> signInWithEmail({
    required String email,
    required String password,
  });

  /// Đăng nhập bằng Google
  Future<UserEntity> signInWithGoogle();

  /// Đăng ký tài khoản mới
  Future<UserEntity> registerWithEmail({
    required String email,
    required String password,
    required String displayName,
  });

  /// Gửi email đặt lại mật khẩu
  Future<void> sendPasswordResetEmail(String email);

  /// Đăng xuất
  Future<void> signOut();

  /// Cập nhật FCM token của user vào Firestore
  Future<void> updateFcmToken(String token);

  /// Cập nhật thông tin profile
  Future<UserEntity> updateProfile({
    String? displayName,
    String? photoURL,
    String? phoneNumber,
  });

  /// Thêm địa chỉ giao hàng mới
  Future<UserEntity> addAddress(String userId, Address address);

  /// Cập nhật địa chỉ tại vị trí index
  Future<UserEntity> updateAddress(String userId, int index, Address address);

  /// Xóa địa chỉ tại vị trí index
  Future<UserEntity> deleteAddress(String userId, int index);

  /// Đặt địa chỉ tại index làm mặc định
  Future<UserEntity> setDefaultAddress(String userId, int index);
}
