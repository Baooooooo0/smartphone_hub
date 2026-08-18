import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/usecases/auth/auth_usecases.dart';
import '../auth/widgets/auth_text_field.dart';
import '../widgets/primary_button.dart';
import 'providers/profile_notifier.dart';
import 'widgets/avatar_picker_sheet.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    final user = ref.read(currentUserProvider);
    _nameController = TextEditingController(text: user?.displayName ?? '');
    _phoneController = TextEditingController(text: user?.phoneNumber ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    final source = await AvatarPickerSheet.show(context);
    if (source != null) {
      final success =
          await ref.read(profileNotifierProvider.notifier).changeAvatar(source);
      if (mounted && success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cập nhật ảnh đại diện thành công!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref.read(profileNotifierProvider.notifier).updateProfile(
          displayName: _nameController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
        );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cập nhật thông tin thành công!'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileNotifierProvider);
    final user = profileState.user ?? ref.watch(currentUserProvider);

    ref.listen(profileNotifierProvider, (previous, next) {
      if (next.isError && next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: AppColors.error,
          ),
        );
        ref.read(profileNotifierProvider.notifier).clearMessages();
      }
    });

    final photoURL = user?.photoURL ?? '';
    final displayName = user?.displayName ?? '';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
        title: Text(
          'Chỉnh sửa hồ sơ',
          style: AppTypography.headlineSmall.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.screenPaddingH,
          vertical: AppSizes.lg,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: AppSizes.md),

              // ── Avatar Preview & Change Button ──────────────
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: AppSizes.avatarXL + 16,
                      height: AppSizes.avatarXL + 16,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primarySurface,
                        border: Border.all(
                          color: AppColors.primaryLight,
                          width: 3,
                        ),
                        boxShadow: AppColors.cardShadow,
                      ),
                      child: ClipOval(
                        child: profileState.isUploadingAvatar
                            ? const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  color: AppColors.primary,
                                ),
                              )
                            : photoURL.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: photoURL,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        _buildInitialAvatar(displayName),
                                  )
                                : _buildInitialAvatar(displayName),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 4,
                      child: GestureDetector(
                        onTap: profileState.isUploadingAvatar ? null : _pickAvatar,
                        child: Container(
                          padding: const EdgeInsets.all(AppSizes.sm),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.surface,
                              width: 2.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.camera_alt_rounded,
                            size: AppSizes.iconSM,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSizes.xs),
              TextButton.icon(
                onPressed: profileState.isUploadingAvatar ? null : _pickAvatar,
                icon: const Icon(Icons.photo_library_outlined, size: 18),
                label: const Text('Thay đổi ảnh đại diện'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  textStyle: AppTypography.labelLarge,
                ),
              ),

              const SizedBox(height: AppSizes.xl),

              // ── Information Card ─────────────────────────────
              Container(
                padding: const EdgeInsets.all(AppSizes.lg),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSizes.radiusXL),
                  border: Border.all(
                    color: AppColors.border.withValues(alpha: 0.8),
                  ),
                  boxShadow: AppColors.cardShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Thông tin cá nhân',
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSizes.lg),

                    // Họ và tên
                    AuthTextField(
                      controller: _nameController,
                      label: 'Họ và tên',
                      hint: 'Nhập họ và tên',
                      prefixIcon: Icons.person_outline_rounded,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Vui lòng nhập họ và tên';
                        }
                        if (val.trim().length < 2) {
                          return 'Tên phải có ít nhất 2 ký tự';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: AppSizes.md),

                    // Số điện thoại
                    AuthTextField(
                      controller: _phoneController,
                      label: 'Số điện thoại',
                      hint: '0912345678',
                      keyboardType: TextInputType.phone,
                      prefixIcon: Icons.phone_android_outlined,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return null; // optional nếu chưa có
                        }
                        final cleanPhone = val.replaceAll(RegExp(r'\s+'), '');
                        if (!RegExp(r'^(0[3|5|7|8|9])[0-9]{8}$').hasMatch(cleanPhone)) {
                          return 'Số điện thoại không hợp lệ (10 chữ số)';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: AppSizes.md),

                    // Email (Read-only)
                    AuthTextField(
                      controller: _emailController,
                      label: 'Email tài khoản (Không thể sửa)',
                      hint: 'email@domain.com',
                      readOnly: true,
                      prefixIcon: Icons.email_outlined,
                      suffixIcon: const Icon(
                        Icons.lock_outline_rounded,
                        color: AppColors.textDisabled,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSizes.xxl),

              // ── Save Button ──────────────────────────────────
              PrimaryButton(
                label: 'Lưu thay đổi',
                isLoading: profileState.isLoading,
                onPressed: profileState.isLoading ? null : _saveProfile,
              ),

              const SizedBox(height: AppSizes.lg),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInitialAvatar(String name) {
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'U';
    return Container(
      color: AppColors.primary,
      alignment: Alignment.center,
      child: Text(
        initial,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 38,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
