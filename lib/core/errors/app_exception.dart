import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuthException;
import 'package:cloud_firestore/cloud_firestore.dart' show FirebaseException;
import 'failures.dart';

/// AppException — Convert Firebase exceptions sang Failure domain objects
class AppException implements Exception {
  final String message;
  final String? code;

  const AppException({required this.message, this.code});

  /// Map FirebaseAuthException sang AuthFailure
  static AuthFailure fromFirebaseAuth(FirebaseAuthException e) {
    final msg = switch (e.code) {
      'user-not-found' => 'Không tìm thấy tài khoản với email này',
      'wrong-password' => 'Mật khẩu không đúng',
      'invalid-credential' => 'Email hoặc mật khẩu không đúng',
      'email-already-in-use' => 'Email này đã được sử dụng',
      'weak-password' => 'Mật khẩu quá yếu, tối thiểu 6 ký tự',
      'invalid-email' => 'Email không hợp lệ',
      'user-disabled' => 'Tài khoản đã bị vô hiệu hóa',
      'too-many-requests' => 'Quá nhiều lần thử, vui lòng thử lại sau',
      'network-request-failed' => 'Không có kết nối internet',
      _ => e.message ?? 'Lỗi xác thực không xác định',
    };
    return AuthFailure(message: msg, code: e.code);
  }

  /// Map FirebaseException (Firestore, Storage) sang Failure
  static Failure fromFirestore(FirebaseException e) {
    return switch (e.code) {
      'permission-denied' => const PermissionFailure(),
      'not-found' => const NotFoundFailure(),
      'unavailable' => ServerFailure(
          message: e.message ?? 'Dịch vụ Firestore tạm thời không khả dụng',
          code: e.code,
        ),
      'deadline-exceeded' => const NetworkFailure(
          message: 'Kết nối quá thời gian, thử lại sau',
        ),
      _ => ServerFailure(
          message: e.message ?? 'Lỗi server không xác định',
          code: e.code,
        ),
    };
  }

  @override
  String toString() => 'AppException(message: $message, code: $code)';
}
