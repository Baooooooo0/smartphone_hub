import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/user_entity.dart';
import 'add_address_dialog.dart';

/// AddressSelectionSheet — Modal bottom sheet để chọn hoặc thêm địa chỉ mới
class AddressSelectionSheet extends StatelessWidget {
  final List<Address> addresses;
  final Address? selectedAddress;
  final ValueChanged<Address> onSelectAddress;
  final ValueChanged<Address> onAddNewAddress;

  const AddressSelectionSheet({
    super.key,
    required this.addresses,
    required this.selectedAddress,
    required this.onSelectAddress,
    required this.onAddNewAddress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusLG),
        ),
      ),
      padding: EdgeInsets.only(
        left: AppSizes.lg,
        right: AppSizes.lg,
        top: AppSizes.lg,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSizes.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle indicator
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppSizes.md),
          Row(
            children: [
              Text(
                'Chọn địa chỉ nhận hàng',
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
          const SizedBox(height: AppSizes.sm),

          // Nút thêm địa chỉ mới
          OutlinedButton.icon(
            onPressed: () {
              Navigator.pop(context); // Close sheet
              showDialog(
                context: context,
                builder: (context) => AddAddressDialog(
                  onSave: onAddNewAddress,
                ),
              );
            },
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 44),
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
            ),
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Thêm địa chỉ mới'),
          ),
          const SizedBox(height: AppSizes.md),

          // Danh sách địa chỉ
          if (addresses.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSizes.xl),
              child: Center(
                child: Column(
                  children: [
                    const Icon(
                      Icons.location_off_outlined,
                      size: 48,
                      color: AppColors.textTertiary,
                    ),
                    const SizedBox(height: AppSizes.sm),
                    Text(
                      'Bạn chưa có địa chỉ nào lưu trữ.',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: addresses.length,
                separatorBuilder: (context, index) => const Divider(
                  height: AppSizes.md,
                  color: AppColors.border,
                ),
                itemBuilder: (context, index) {
                  final addr = addresses[index];
                  final isSelected = selectedAddress?.street == addr.street &&
                      selectedAddress?.phone == addr.phone;

                  return InkWell(
                    onTap: () {
                      onSelectAddress(addr);
                      Navigator.pop(context);
                    },
                    borderRadius: BorderRadius.circular(AppSizes.radiusMD),
                    child: Container(
                      padding: const EdgeInsets.all(AppSizes.md),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary.withValues(alpha: 0.05)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(AppSizes.radiusMD),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : Colors.transparent,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                            color: isSelected ? AppColors.primary : AppColors.textSecondary,
                          ),
                          const SizedBox(width: AppSizes.sm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      addr.recipientName,
                                      style: AppTypography.titleSmall.copyWith(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(width: AppSizes.xs),
                                    Text(
                                      '(${addr.phone})',
                                      style: AppTypography.bodySmall.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    if (addr.isDefault) ...[
                                      const SizedBox(width: AppSizes.xs),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 1,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary.withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          'Mặc định',
                                          style: AppTypography.labelSmall.copyWith(
                                            color: AppColors.primary,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${addr.street}, ${addr.ward}, ${addr.district}, ${addr.province}',
                                  style: AppTypography.bodySmall.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
