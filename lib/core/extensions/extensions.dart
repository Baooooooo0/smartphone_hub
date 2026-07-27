import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';

/// BuildContext extensions
extension BuildContextX on BuildContext {
  // Theme shortcuts
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  // Screen size
  Size get screenSize => MediaQuery.sizeOf(this);
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;
  EdgeInsets get padding => MediaQuery.paddingOf(this);

  // Navigation
  bool get canPop => Navigator.canPop(this);
  void pop<T>([T? result]) => Navigator.pop(this, result);

  // Snackbar helpers
  void showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: AppColors.success, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
      ),
    );
  }

  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: AppColors.error, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.errorSurface,
      ),
    );
  }

  void showInfoSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

/// String extensions
extension StringX on String {
  /// Viết hoa chữ đầu mỗi từ
  String get toTitleCase => split(' ')
      .map((w) => w.isEmpty ? w : w[0].toUpperCase() + w.substring(1))
      .join(' ');

  /// Ẩn một phần email: abc***@gmail.com
  String get maskEmail {
    final parts = split('@');
    if (parts.length != 2) return this;
    final name = parts[0];
    final masked = name.length > 3
        ? '${name.substring(0, 3)}***'
        : '${name[0]}***';
    return '$masked@${parts[1]}';
  }

  /// Kiểm tra email hợp lệ
  bool get isValidEmail {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(trim());
  }
}

/// num extensions
extension NumX on num {
  /// Làm tròn đến n chữ số thập phân
  double roundTo(int places) {
    final mod = math.pow(10, places);
    return (this * mod).round() / mod;
  }
}

/// DateTime extensions
extension DateTimeX on DateTime {
  /// Định dạng ngày tháng năm: "26/07/2025"
  String get toDateString {
    return '${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/$year';
  }

  /// Định dạng ngày giờ: "26/07/2025 17:30"
  String get toDateTimeString {
    return '$toDateString ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  /// Thời gian tương đối: "2 giờ trước"
  String get timeAgo {
    final now = DateTime.now();
    final diff = now.difference(this);

    if (diff.inSeconds < 60) return 'Vừa xong';
    if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
    if (diff.inHours < 24) return '${diff.inHours} giờ trước';
    if (diff.inDays < 7) return '${diff.inDays} ngày trước';
    return toDateString;
  }

  /// Kiểm tra là hôm nay
  bool get isToday {
    final now = DateTime.now();
    return day == now.day && month == now.month && year == now.year;
  }
}

/// AsyncValue display extension — dùng với Riverpod
extension AsyncValueX<T> on AsyncValue<T> {
  /// Lấy error message từ AsyncError
  String get errorMessage {
    return when(
      data: (_) => '',
      loading: () => AppStrings.loading,
      error: (e, _) => e.toString(),
    );
  }
}
