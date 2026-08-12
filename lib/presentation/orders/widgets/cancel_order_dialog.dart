import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_theme.dart';

/// CancelOrderDialog — Dialog xác nhận hủy đơn hàng kèm lý do
class CancelOrderDialog extends StatefulWidget {
  final ValueChanged<String> onConfirm;

  const CancelOrderDialog({
    super.key,
    required this.onConfirm,
  });

  @override
  State<CancelOrderDialog> createState() => _CancelOrderDialogState();
}

class _CancelOrderDialogState extends State<CancelOrderDialog> {
  static const List<String> _reasons = [
    'Muốn thay đổi sản phẩm / màu sắc',
    'Cập nhật lại địa chỉ giao hàng / SĐT',
    'Tìm thấy giá tốt hơn',
    'Đổi ý không muốn mua nữa',
    'Lý do khác',
  ];

  String _selectedReason = _reasons[0];
  final _otherReasonController = TextEditingController();

  @override
  void dispose() {
    _otherReasonController.dispose();
    super.dispose();
  }

  void _submit() {
    final finalReason = _selectedReason == 'Lý do khác' &&
            _otherReasonController.text.trim().isNotEmpty
        ? _otherReasonController.text.trim()
        : _selectedReason;

    widget.onConfirm(finalReason);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLG),
      ),
      insetPadding: const EdgeInsets.all(AppSizes.md),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.cancel_outlined,
                  color: AppColors.error,
                  size: 28,
                ),
                const SizedBox(width: AppSizes.sm),
                Text(
                  'Hủy đơn hàng',
                  style: AppTypography.titleLarge.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.xs),
            Text(
              'Vui lòng chọn lý do bạn muốn hủy đơn hàng này:',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSizes.md),

            ..._reasons.map((reason) {
              final isSelected = _selectedReason == reason;
              return InkWell(
                onTap: () {
                  setState(() {
                    _selectedReason = reason;
                  });
                },
                borderRadius: BorderRadius.circular(AppSizes.radiusSM),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Row(
                    children: [
                      Icon(
                        isSelected
                            ? Icons.radio_button_checked
                            : Icons.radio_button_off,
                        color: isSelected ? AppColors.error : AppColors.textSecondary,
                        size: 20,
                      ),
                      const SizedBox(width: AppSizes.sm),
                      Expanded(
                        child: Text(
                          reason,
                          style: AppTypography.bodyMedium.copyWith(
                            color: isSelected
                                ? AppColors.textPrimary
                                : AppColors.textSecondary,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),

            if (_selectedReason == 'Lý do khác') ...[
              const SizedBox(height: AppSizes.sm),
              TextField(
                controller: _otherReasonController,
                maxLines: 2,
                decoration: const InputDecoration(
                  hintText: 'Nhập chi tiết lý do của bạn...',
                  border: OutlineInputBorder(),
                ),
              ),
            ],

            const SizedBox(height: AppSizes.lg),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Giữ đơn hàng'),
                  ),
                ),
                const SizedBox(width: AppSizes.md),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                    ),
                    child: const Text(
                      'Xác nhận hủy',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
