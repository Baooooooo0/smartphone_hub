import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/user_entity.dart';

class ProfileHeaderCard extends StatelessWidget {
  final UserEntity? user;
  final bool isUploadingAvatar;
  final VoidCallback? onAvatarTap;
  final VoidCallback? onEditProfileTap;

  const ProfileHeaderCard({
    super.key,
    required this.user,
    this.isUploadingAvatar = false,
    this.onAvatarTap,
    this.onEditProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    final displayName = user?.displayName.isNotEmpty == true
        ? user!.displayName
        : (user?.email.isNotEmpty == true ? user!.email.split('@').first : 'Người dùng');
    final email = user?.email ?? '';
    final phone = user?.phoneNumber.isNotEmpty == true
        ? user!.phoneNumber
        : 'Chưa cập nhật SĐT';
    final photoURL = user?.photoURL ?? '';
    final isAdmin = user?.isAdmin ?? false;

    return Container(
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusXXL),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.8)),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        children: [
          Row(
            children: [
              // ── Avatar with Camera badge ──────────────────────
              Stack(
                children: [
                  GestureDetector(
                    onTap: isUploadingAvatar ? null : onAvatarTap,
                    child: Container(
                      width: AppSizes.avatarLG,
                      height: AppSizes.avatarLG,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primarySurface,
                        border: Border.all(
                          color: AppColors.primaryLight,
                          width: 2.5,
                        ),
                      ),
                      child: ClipOval(
                        child: isUploadingAvatar
                            ? const Center(
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: AppColors.primary,
                                  ),
                                ),
                              )
                            : photoURL.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: photoURL,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        const Center(
                                      child: SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        _buildInitialAvatar(displayName),
                                  )
                                : _buildInitialAvatar(displayName),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: isUploadingAvatar ? null : onAvatarTap,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.surface,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.4),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.camera_alt_rounded,
                          size: AppSizes.iconXS + 2,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: AppSizes.lg),

              // ── User Info ────────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            displayName,
                            style: AppTypography.titleLarge.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: AppSizes.xs),
                        if (isAdmin)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.sm,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFF9900), Color(0xFFFF5500)],
                              ),
                              borderRadius: BorderRadius.circular(
                                AppSizes.radiusFull,
                              ),
                            ),
                            child: const Text(
                              'ADMIN',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                              ),
                            ),
                          )
                        else
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.sm,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primarySurface,
                              borderRadius: BorderRadius.circular(
                                AppSizes.radiusFull,
                              ),
                            ),
                            child: Text(
                              'Thành viên',
                              style: AppTypography.caption.copyWith(
                                color: AppColors.primaryDark,
                                fontWeight: FontWeight.w600,
                                fontSize: 10,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    if (email.isNotEmpty)
                      Row(
                        children: [
                          const Icon(
                            Icons.email_outlined,
                            size: AppSizes.iconXS,
                            color: AppColors.textTertiary,
                          ),
                          const SizedBox(width: AppSizes.xs),
                          Expanded(
                            child: Text(
                              email,
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(
                          Icons.phone_android_outlined,
                          size: AppSizes.iconXS,
                          color: AppColors.textTertiary,
                        ),
                        const SizedBox(width: AppSizes.xs),
                        Text(
                          phone,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ── Edit Button ──────────────────────────────────
              IconButton(
                onPressed: onEditProfileTap,
                icon: Container(
                  padding: const EdgeInsets.all(AppSizes.sm),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.edit_outlined,
                    size: AppSizes.iconSM,
                    color: AppColors.textPrimary,
                  ),
                ),
                tooltip: 'Chỉnh sửa thông tin',
              ),
            ],
          ),
        ],
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
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
