import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/user_entity.dart';

class AddAddressDialog extends StatefulWidget {
  final ValueChanged<Address> onSave;

  const AddAddressDialog({
    super.key,
    required this.onSave,
  });

  @override
  State<AddAddressDialog> createState() => _AddAddressDialogState();
}

class _AddAddressDialogState extends State<AddAddressDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _streetController = TextEditingController();
  final _wardController = TextEditingController();
  final _districtController = TextEditingController();
  final _provinceController = TextEditingController();

  String _selectedLabel = 'Nhà riêng';
  bool _isDefault = false;

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
        label: _selectedLabel,
        recipientName: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        street: _streetController.text.trim(),
        ward: _wardController.text.trim(),
        district: _districtController.text.trim(),
        province: _provinceController.text.trim(),
        isDefault: _isDefault,
      );

      widget.onSave(address);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLG),
      ),
      insetPadding: const EdgeInsets.all(AppSizes.md),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Thêm địa chỉ mới',
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
              const SizedBox(height: AppSizes.md),

              // Tên người nhận
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Tên người nhận *',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (val) =>
                    (val == null || val.trim().isEmpty) ? 'Vui lòng nhập tên người nhận' : null,
              ),
              const SizedBox(height: AppSizes.md),

              // Số điện thoại
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Số điện thoại *',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Vui lòng nhập số điện thoại';
                  }
                  if (val.trim().length < 9) {
                    return 'Số điện thoại không hợp lệ';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSizes.md),

              // Tỉnh / Thành phố
              TextFormField(
                controller: _provinceController,
                decoration: const InputDecoration(
                  labelText: 'Tỉnh / Thành phố *',
                  prefixIcon: Icon(Icons.map_outlined),
                ),
                validator: (val) =>
                    (val == null || val.trim().isEmpty) ? 'Vui lòng nhập Tỉnh/Thành phố' : null,
              ),
              const SizedBox(height: AppSizes.md),

              // Quận / Huyện
              TextFormField(
                controller: _districtController,
                decoration: const InputDecoration(
                  labelText: 'Quận / Huyện *',
                  prefixIcon: Icon(Icons.location_city_outlined),
                ),
                validator: (val) =>
                    (val == null || val.trim().isEmpty) ? 'Vui lòng nhập Quận/Huyện' : null,
              ),
              const SizedBox(height: AppSizes.md),

              // Phường / Xã
              TextFormField(
                controller: _wardController,
                decoration: const InputDecoration(
                  labelText: 'Phường / Xã *',
                  prefixIcon: Icon(Icons.holiday_village_outlined),
                ),
                validator: (val) =>
                    (val == null || val.trim().isEmpty) ? 'Vui lòng nhập Phường/Xã' : null,
              ),
              const SizedBox(height: AppSizes.md),

              // Số nhà, tên đường
              TextFormField(
                controller: _streetController,
                decoration: const InputDecoration(
                  labelText: 'Số nhà, tên đường *',
                  prefixIcon: Icon(Icons.home_outlined),
                ),
                validator: (val) =>
                    (val == null || val.trim().isEmpty) ? 'Vui lòng nhập số nhà, tên đường' : null,
              ),
              const SizedBox(height: AppSizes.md),

              // Nhãn (Nhà riêng / Cơ quan)
              Row(
                children: [
                  Text('Loại địa chỉ:', style: AppTypography.titleSmall),
                  const SizedBox(width: AppSizes.md),
                  ChoiceChip(
                    label: const Text('Nhà riêng'),
                    selected: _selectedLabel == 'Nhà riêng',
                    onSelected: (selected) {
                      if (selected) setState(() => _selectedLabel = 'Nhà riêng');
                    },
                  ),
                  const SizedBox(width: AppSizes.xs),
                  ChoiceChip(
                    label: const Text('Cơ quan'),
                    selected: _selectedLabel == 'Cơ quan',
                    onSelected: (selected) {
                      if (selected) setState(() => _selectedLabel = 'Cơ quan');
                    },
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.sm),

              // Đặt làm mặc định
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Đặt làm địa chỉ mặc định'),
                value: _isDefault,
                onChanged: (val) => setState(() => _isDefault = val),
                activeTrackColor: AppColors.primary,
              ),
              const SizedBox(height: AppSizes.lg),

              // Button lưu
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: AppSizes.md),
                    backgroundColor: AppColors.primary,
                  ),
                  child: const Text('Lưu địa chỉ', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
