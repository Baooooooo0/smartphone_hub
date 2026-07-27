/// Failure — Base class cho tất cả các lỗi trong domain layer
abstract class Failure {
  final String message;
  final String? code;

  const Failure({required this.message, this.code});

  @override
  String toString() => 'Failure(message: $message, code: $code)';
}

/// ServerFailure — Lỗi từ Firebase / API
class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.code});
}

/// NetworkFailure — Không có kết nối internet
class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'Không có kết nối internet',
    super.code = 'network_error',
  });
}

/// CacheFailure — Lỗi đọc/ghi local cache
class CacheFailure extends Failure {
  const CacheFailure({required super.message, super.code});
}

/// AuthFailure — Lỗi xác thực
class AuthFailure extends Failure {
  const AuthFailure({required super.message, super.code});
}

/// NotFoundFailure — Không tìm thấy data
class NotFoundFailure extends Failure {
  const NotFoundFailure({
    super.message = 'Không tìm thấy dữ liệu',
    super.code = 'not_found',
  });
}

/// PermissionFailure — Không có quyền
class PermissionFailure extends Failure {
  const PermissionFailure({
    super.message = 'Bạn không có quyền thực hiện hành động này',
    super.code = 'permission_denied',
  });
}

/// ValidationFailure — Lỗi validate input
class ValidationFailure extends Failure {
  const ValidationFailure({required super.message, super.code});
}

/// PaymentFailure — Lỗi thanh toán
class PaymentFailure extends Failure {
  const PaymentFailure({required super.message, super.code});
}

/// UnknownFailure — Lỗi không xác định
class UnknownFailure extends Failure {
  const UnknownFailure({
    super.message = 'Đã xảy ra lỗi không xác định',
    super.code = 'unknown',
  });
}
