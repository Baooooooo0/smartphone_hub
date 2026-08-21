import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/order_providers.dart';

/// Duration trước khi tự động hủy đơn hàng chờ xác nhận: 15 phút (900 giây)
const int kAutoCancelPendingDurationSeconds = 15 * 60;

/// Widget đếm ngược tự động hủy đơn hàng sau 15 phút.
///
/// Có 2 kiểu hiển thị:
/// - `isBanner: true` (dùng cho OrderDetailScreen): Banner cảnh báo rộng màu vàng cam.
/// - `isBanner: false` (dùng cho OrderCard): Chip nhỏ gọn tinh tế.
class OrderAutoCancelTimer extends ConsumerStatefulWidget {
  final String orderId;
  final DateTime? createdAt;
  final bool isBanner;

  const OrderAutoCancelTimer({
    super.key,
    required this.orderId,
    required this.createdAt,
    this.isBanner = false,
  });

  @override
  ConsumerState<OrderAutoCancelTimer> createState() =>
      _OrderAutoCancelTimerState();
}

class _OrderAutoCancelTimerState extends ConsumerState<OrderAutoCancelTimer> {
  Timer? _timer;
  late int _remainingSeconds;
  bool _isCancelling = false;

  @override
  void initState() {
    super.initState();
    _calculateRemaining();
    _startTimer();
  }

  void _calculateRemaining() {
    if (widget.createdAt == null) {
      _remainingSeconds = 0;
      return;
    }
    final elapsed = DateTime.now().difference(widget.createdAt!).inSeconds;
    _remainingSeconds = (kAutoCancelPendingDurationSeconds - elapsed).clamp(0, kAutoCancelPendingDurationSeconds);
  }

  void _startTimer() {
    if (_remainingSeconds <= 0) {
      _onTimeExpired();
      return;
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          timer.cancel();
          _onTimeExpired();
        }
      });
    });
  }

  Future<void> _onTimeExpired() async {
    if (_isCancelling) return;
    _isCancelling = true;

    // Tự động kích hoạt hủy đơn hàng trên Firestore
    await ref.read(orderActionProvider.notifier).cancelOrder(
          widget.orderId,
          reason: 'Hệ thống tự động hủy do quá thời gian chờ xác nhận (15 phút)',
        );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    final minStr = minutes.toString().padLeft(2, '0');
    final secStr = seconds.toString().padLeft(2, '0');
    return '$minStr:$secStr';
  }

  @override
  Widget build(BuildContext context) {
    if (_remainingSeconds <= 0) {
      return const SizedBox.shrink();
    }

    final formattedTime = _formatTime(_remainingSeconds);

    if (widget.isBanner) {
      return Container(
        margin: const EdgeInsets.only(bottom: AppSizes.md),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.md,
          vertical: AppSizes.sm + 2,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF7E6), // Amber light surface
          borderRadius: BorderRadius.circular(AppSizes.radiusMD),
          border: Border.all(
            color: const Color(0xFFFFD591), // Amber border
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.timer_outlined,
              size: 20,
              color: Color(0xFFD46B08), // Amber dark
            ),
            const SizedBox(width: AppSizes.sm),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: AppTypography.bodySmall.copyWith(
                    color: const Color(0xFFD46B08),
                  ),
                  children: [
                    const TextSpan(text: 'Đơn hàng sẽ tự động hủy sau '),
                    TextSpan(
                      text: formattedTime,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontFamily: 'monospace',
                      ),
                    ),
                    const TextSpan(text: ' nếu chưa được xác nhận.'),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Chip hiển thị nhỏ gọn trong OrderCard
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7E6),
        borderRadius: BorderRadius.circular(AppSizes.radiusXS),
        border: Border.all(
          color: const Color(0xFFFFD591),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.timer_outlined,
            size: 13,
            color: Color(0xFFD46B08),
          ),
          const SizedBox(width: 4),
          Text(
            'Tự hủy sau: $formattedTime',
            style: AppTypography.labelSmall.copyWith(
              color: const Color(0xFFD46B08),
              fontWeight: FontWeight.w700,
              fontSize: 11,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}
