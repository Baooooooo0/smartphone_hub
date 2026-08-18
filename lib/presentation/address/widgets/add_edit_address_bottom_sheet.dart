import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/user_entity.dart';
import '../../auth/widgets/auth_text_field.dart';
import '../../widgets/primary_button.dart';

/// AddEditAddressBottomSheet — Form thêm mới hoặc chỉnh sửa địa chỉ giao hàng
class AddEditAddressBottomSheet extends StatefulWidget {
  final Address? initialAddress;
  final ValueChanged<Address> onSave;

  const AddEditAddressBottomSheet({
    super.key,
    this.initialAddress,
    required this.onSave,
  });

  @override
  State<AddEditAddressBottomSheet> createState() =>
      _AddEditAddressBottomSheetState();
}

class _AddEditAddressBottomSheetState
    extends State<AddEditAddressBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  late String _label;
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _streetController;
  late TextEditingController _wardController;
  late TextEditingController _districtController;
  late TextEditingController _provinceController;
  late bool _isDefault;

  final List<String> _labelOptions = ['Nhà riêng', 'Công ty', 'Khác'];

  @override
  void initState() {
    super.initState();
    final addr = widget.initialAddress;
    _label = addr?.label ?? 'Nhà riêng';
    _nameController = TextEditingController(text: addr?.recipientName ?? '');
    _phoneController = TextEditingController(text: addr?.phone ?? '');
    _streetController = TextEditingController(text: addr?.street ?? '');
    _wardController = TextEditingController(text: addr?.ward ?? '');
    _districtController = TextEditingController(text: addr?.district ?? '');
    _provinceController = TextEditingController(text: addr?.province ?? '');
    _isDefault = addr?.isDefault ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _streetController.dispose();
    _wardController.dispose();
    _districtController.dispose();
    _provinceController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final address = Address(
        label: _label,
        recipientName: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        street: _streetController.text.trim(),
        ward: _wardController.text.trim(),
        district: _districtController.text.trim(),
        province: _provinceController.text.trim(),
        isDefault: _isDefault,
      );
      widget.onSave(address);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialAddress != null;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(AppSizes.lg),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSizes.radiusLG),
          ),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ──────────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isEditing ? 'Chỉnh sửa địa chỉ' : 'Thêm địa chỉ mới',
                      style: AppTypography.titleLarge.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(height: AppSizes.sm),

                // ── Label Selector ──────────────────────────────────
                Text(
                  'Nhãn địa chỉ',
                  style: AppTypography.labelLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSizes.xs),
                Wrap(
                  spacing: AppSizes.sm,
                  children: _labelOptions.map((opt) {
                    final isSelected = _label == opt;
                    return ChoiceChip(
                      label: Text(opt),
                      selected: isSelected,
                      selectedColor: AppColors.primarySurface,
                      backgroundColor: const Color(0xFFF8FAFC),
                      side: BorderSide(
                        color: isSelected ? AppColors.primary : AppColors.border,
                      ),
                      labelStyle: TextStyle(
                        color: isSelected ? AppColors.primary : AppColors.textPrimary,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
                      ),
                      onSelected: (selected) {
                        if (selected) setState(() => _label = opt);
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: AppSizes.md),

                // ── Fields ──────────────────────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: AuthTextField(
                        controller: _nameController,
                        label: 'Tên người nhận',
                        hint: 'Nguyễn Văn A',
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Vui lòng nhập tên' : null,
                      ),
                    ),
                    const SizedBox(width: AppSizes.sm),
                    Expanded(
                      child: AuthTextField(
                        controller: _phoneController,
                        label: 'Số điện thoại',
                        hint: '0987654321',
                        keyboardType: TextInputType.phone,
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Vui lòng nhập SĐT' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.sm),

                Row(
                  children: [
                    Expanded(
                      child: AuthTextField(
                        controller: _provinceController,
                        label: 'Tỉnh / Thành phố',
                        hint: 'Hồ Chí Minh',
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Bắt buộc' : null,
                      ),
                    ),
                    const SizedBox(width: AppSizes.sm),
                    Expanded(
                      child: AuthTextField(
                        controller: _districtController,
                        label: 'Quận / Huyện',
                        hint: 'Quận 1',
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Bắt buộc' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.sm),

                AuthTextField(
                  controller: _wardController,
                  label: 'Phường / Xã',
                  hint: 'Phường Bến Nghé',
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Bắt buộc' : null,
                ),
                const SizedBox(height: AppSizes.sm),

                AuthTextField(
                  controller: _streetController,
                  label: 'Số nhà, Tên đường',
                  hint: '123 Nguyễn Huệ',
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Bắt buộc' : null,
                ),
                const SizedBox(height: AppSizes.md),

                // ── Switch Default ──────────────────────────────────
                SwitchListTile(
                  title: const Text('Đặt làm địa chỉ mặc định'),
                  subtitle: const Text('Tự động chọn khi đặt hàng'),
                  value: _isDefault,
                  activeThumbColor: AppColors.primary,
                  contentPadding: EdgeInsets.zero,
                  onChanged: (val) => setState(() => _isDefault = val),
                ),
                const SizedBox(height: AppSizes.lg),

                // ── Save Button ─────────────────────────────────────
                PrimaryButton(
                  label: isEditing ? 'Lưu thay đổi' : 'Thêm địa chỉ',
                  onPressed: _submit,
                ),
                const SizedBox(height: AppSizes.sm),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
