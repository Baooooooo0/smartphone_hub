import 'package:intl/intl.dart';

/// CurrencyFormatter — Định dạng tiền tệ VNĐ
class CurrencyFormatter {
  CurrencyFormatter._();

  static final _formatter = NumberFormat.currency(
    locale: 'vi_VN',
    symbol: '₫',
    decimalDigits: 0,
  );

  /// Format số thành chuỗi tiền tệ VNĐ
  /// Ví dụ: 1500000 → "1.500.000 ₫"
  static String format(num amount) => _formatter.format(amount);

  /// Format rút gọn cho giá lớn
  /// Ví dụ: 15000000 → "15 triệu ₫"
  static String formatShort(num amount) {
    if (amount >= 1000000000) {
      return '${(amount / 1000000000).toStringAsFixed(1)} tỷ ₫';
    } else if (amount >= 1000000) {
      final millions = amount / 1000000;
      return '${millions % 1 == 0 ? millions.toInt() : millions.toStringAsFixed(1)} triệu ₫';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)}K ₫';
    }
    return format(amount);
  }

  /// Tính phần trăm giảm giá
  static int discountPercent(num original, num discounted) {
    if (original <= 0) return 0;
    return ((original - discounted) / original * 100).round();
  }
}

/// Validators — Kiểm tra tính hợp lệ của input
class Validators {
  Validators._();

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email không được để trống';
    }
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!regex.hasMatch(value.trim())) {
      return 'Email không hợp lệ';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mật khẩu không được để trống';
    }
    if (value.length < 6) {
      return 'Mật khẩu tối thiểu 6 ký tự';
    }
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng xác nhận mật khẩu';
    }
    if (value != password) {
      return 'Mật khẩu không khớp';
    }
    return null;
  }

  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'Trường này'} không được để trống';
    }
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Số điện thoại không được để trống';
    }
    final regex = RegExp(r'^(0[3|5|7|8|9])+([0-9]{8})$');
    if (!regex.hasMatch(value.trim())) {
      return 'Số điện thoại không hợp lệ (VD: 0912345678)';
    }
    return null;
  }
}
