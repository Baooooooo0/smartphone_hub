import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/user_entity.dart';
import '../widgets/primary_button.dart';
import 'providers/address_provider.dart';
import 'widgets/add_edit_address_bottom_sheet.dart';

/// AddressListScreen — Màn hình Quản lý danh sách địa chỉ giao hàng
class AddressListScreen extends ConsumerWidget {
  const AddressListScreen({super.key});

  void _openAddEditBottomSheet(
    BuildContext context,
    WidgetRef ref, {
    Address? initialAddress,
    int? index,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return AddEditAddressBottomSheet(
          initialAddress: initialAddress,
          onSave: (address) {
            final notifier = ref.read(addressProvider.notifier);
            if (index == null) {
              notifier.addAddress(address);
            } else {
              notifier.updateAddress(index, address);
            }
          },
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: const Text('Bạn có chắc muốn xóa địa chỉ này?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(addressProvider.notifier).deleteAddress(index);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
              child: const Text('Xóa', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addressState = ref.watch(addressProvider);
    final addresses = addressState.addresses;
    final selectedAddress = addressState.selectedAddress;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
        title: Text(
          'Địa chỉ giao hàng',
          style: AppTypography.headlineSmall.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_location_alt_outlined, color: AppColors.primary),
            tooltip: 'Thêm địa chỉ mới',
            onPressed: () => _openAddEditBottomSheet(context, ref),
          ),
        ],
      ),
      body: addresses.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.xxl),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: const BoxDecoration(
                        color: AppColors.primarySurface,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.location_off_rounded,
                        size: 48,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: AppSizes.lg),
                    Text(
                      'Chưa có địa chỉ giao hàng',
                      style: AppTypography.headlineSmall.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSizes.xs),
                    Text(
                      'Thêm địa chỉ để nhận hàng dễ dàng và nhanh chóng hơn.',
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSizes.xxl),
                    SizedBox(
                      width: 220,
                      child: PrimaryButton(
                        label: '+ Thêm địa chỉ ngay',
                        onPressed: () => _openAddEditBottomSheet(context, ref),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(AppSizes.lg),
              itemCount: addresses.length,
              itemBuilder: (context, index) {
                final addr = addresses[index];
                final isSelected = selectedAddress?.recipientName == addr.recipientName &&
                    selectedAddress?.phone == addr.phone &&
                    selectedAddress?.street == addr.street;

                return Container(
                  margin: const EdgeInsets.only(bottom: AppSizes.md),
                  padding: const EdgeInsets.all(AppSizes.md),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppSizes.radiusMD),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.border,
                      width: isSelected ? 1.5 : 1,
                    ),
                    boxShadow: AppColors.cardShadow,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Radio check selection
                      Radio<Address>(
                        value: addr,
                        groupValue: selectedAddress,
                        activeColor: AppColors.primary,
                        onChanged: (val) {
                          if (val != null) {
                            ref
                                .read(addressProvider.notifier)
                                .selectAddress(val);
                          }
                        },
                      ),
                      const SizedBox(width: AppSizes.xs),

                      // Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Label & Default tag
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSizes.sm,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primarySurface,
                                    borderRadius:
                                        BorderRadius.circular(AppSizes.radiusXS),
                                  ),
                                  child: Text(
                                    addr.label,
                                    style: AppTypography.labelSmall.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                if (addr.isDefault) ...[
                                  const SizedBox(width: AppSizes.xs),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppSizes.sm,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green[50],
                                      borderRadius:
                                          BorderRadius.circular(AppSizes.radiusXS),
                                    ),
                                    child: Text(
                                      'Mặc định',
                                      style: AppTypography.labelSmall.copyWith(
                                        color: Colors.green[700],
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: AppSizes.xs),

                            // Recipient & Phone
                            Text(
                              '${addr.recipientName}  |  ${addr.phone}',
                              style: AppTypography.titleMedium.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),

                            // Address Full Text
                            Text(
                              '${addr.street}, ${addr.ward}, ${addr.district}, ${addr.province}',
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                                height: 1.35,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Popup Menu Actions
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert_rounded,
                            color: AppColors.textSecondary),
                        onSelected: (action) {
                          if (action == 'edit') {
                            _openAddEditBottomSheet(context, ref,
                                initialAddress: addr, index: index);
                          } else if (action == 'default') {
                            ref
                                .read(addressProvider.notifier)
                                .setDefaultAddress(index);
                          } else if (action == 'delete') {
                            _confirmDelete(context, ref, index);
                          }
                        },
                        itemBuilder: (context) => [
                          if (!addr.isDefault)
                            const PopupMenuItem(
                              value: 'default',
                              child: Row(
                                children: [
                                  Icon(Icons.check_circle_outline_rounded,
                                      size: 18, color: Colors.green),
                                  SizedBox(width: 8),
                                  Text('Đặt làm mặc định'),
                                ],
                              ),
                            ),
                          const PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit_outlined,
                                    size: 18, color: AppColors.primary),
                                SizedBox(width: 8),
                                Text('Chỉnh sửa'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete_outline_rounded,
                                    size: 18, color: AppColors.error),
                                SizedBox(width: 8),
                                Text('Xóa'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
      bottomNavigationBar: addresses.isNotEmpty
          ? Container(
              padding: const EdgeInsets.all(AppSizes.lg),
              decoration: BoxDecoration(
                color: AppColors.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 12,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: SafeArea(
                child: PrimaryButton(
                  label: '+ Thêm địa chỉ mới',
                  onPressed: () => _openAddEditBottomSheet(context, ref),
                ),
              ),
            )
          : null,
    );
  }
}
