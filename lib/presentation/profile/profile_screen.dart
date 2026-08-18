import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/usecases/auth/auth_usecases.dart';
import '../../../router/app_router.dart';
import 'providers/profile_notifier.dart';
import 'widgets/avatar_picker_sheet.dart';
import 'widgets/profile_header_card.dart';
import 'widgets/profile_menu_tile.dart';
import 'widgets/profile_stat_card.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  Future<void> _changeAvatar(BuildContext context, WidgetRef ref) async {
    final source = await AvatarPickerSheet.show(context);
    if (source != null) {
      final success =
          await ref.read(profileNotifierProvider.notifier).changeAvatar(source);
      if (context.mounted && success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cập nhật ảnh đại diện thành công!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    }
  }

  void _confirmSignOut(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusLG),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSizes.xs + 2),
              decoration: BoxDecoration(
                color: AppColors.errorSurface,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.logout_rounded,
                color: AppColors.error,
                size: AppSizes.iconMD,
              ),
            ),
            const SizedBox(width: AppSizes.sm),
            const Text('Đăng xuất'),
          ],
        ),
        content: const Text(
          'Bạn có chắc chắn muốn đăng xuất khỏi tài khoản này?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogCtx);
              ref.read(profileNotifierProvider.notifier).signOut();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            child: const Text('Đăng xuất'),
          ),
        ],
      ),
    );
  }

  void _confirmResetPassword(BuildContext context, WidgetRef ref) {
    final user = ref.read(currentUserProvider);
    if (user == null || user.email.isEmpty) return;

    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusLG),
        ),
        title: const Text('Đặt lại mật khẩu'),
        content: Text(
          'Hệ thống sẽ gửi email chứa liên kết đặt lại mật khẩu đến địa chỉ:\n\n${user.email}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogCtx);
              final success = await ref
                  .read(profileNotifierProvider.notifier)
                  .sendPasswordResetEmail();
              if (context.mounted && success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Đã gửi email đặt lại mật khẩu đến ${user.email}',
                    ),
                    backgroundColor: AppColors.success,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            child: const Text('Gửi email'),
          ),
        ],
      ),
    );
  }

  Future<void> _callHotline() async {
    final Uri phoneUri = Uri(scheme: 'tel', path: '19008888');
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileNotifierProvider);
    final user = profileState.user ?? ref.watch(currentUserProvider);

    final addressCount = user?.addresses.length ?? 0;
    final isAdmin = user?.isAdmin ?? false;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
        title: Text(
          'Tài khoản của tôi',
          style: AppTypography.headlineSmall.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            tooltip: 'Thông báo',
            onPressed: () => context.push(AppRoutes.notifications),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Stream updates automatically, but we can trigger a micro refresh
          await Future.delayed(const Duration(milliseconds: 400));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.screenPaddingH,
            vertical: AppSizes.md,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── 1. Profile Header Card ─────────────────────
              FadeInDown(
                duration: const Duration(milliseconds: 400),
                child: ProfileHeaderCard(
                  user: user,
                  isUploadingAvatar: profileState.isUploadingAvatar,
                  onAvatarTap: () => _changeAvatar(context, ref),
                  onEditProfileTap: () => context.push(AppRoutes.editProfile),
                ),
              ),

              const SizedBox(height: AppSizes.lg),

              // ── 2. Quick Stats Row ─────────────────────────
              FadeInDown(
                delay: const Duration(milliseconds: 100),
                duration: const Duration(milliseconds: 400),
                child: Row(
                  children: [
                    ProfileStatCard(
                      title: 'Đơn hàng',
                      value: 'Xem tất cả',
                      icon: Icons.receipt_long_outlined,
                      iconColor: AppColors.primary,
                      onTap: () => context.go(AppRoutes.orderList),
                    ),
                    const SizedBox(width: AppSizes.sm),
                    ProfileStatCard(
                      title: 'Sổ địa chỉ',
                      value: '$addressCount địa chỉ',
                      icon: Icons.location_on_outlined,
                      iconColor: const Color(0xFF00C48C),
                      onTap: () => context.push(AppRoutes.addresses),
                    ),
                    const SizedBox(width: AppSizes.sm),
                    ProfileStatCard(
                      title: 'Kho Voucher',
                      value: 'Ưu đãi hot',
                      icon: Icons.confirmation_number_outlined,
                      iconColor: const Color(0xFFFFB800),
                      onTap: () => context.push(AppRoutes.vouchers),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSizes.xl),

              // ── 3. Admin Panel Section (Conditional) ───────
              if (isAdmin) ...[
                FadeInLeft(
                  delay: const Duration(milliseconds: 150),
                  duration: const Duration(milliseconds: 400),
                  child: _buildSectionCard(
                    title: 'Quản trị hệ thống',
                    items: [
                      ProfileMenuTile(
                        icon: Icons.admin_panel_settings_rounded,
                        iconColor: const Color(0xFFFF9900),
                        iconBgColor: const Color(0xFFFFF3E0),
                        title: 'Trang quản trị (Admin Dashboard)',
                        subtitle: 'Quản lý sản phẩm, đơn hàng, người dùng',
                        showDivider: false,
                        onTap: () => context.push(AppRoutes.adminDashboard),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSizes.lg),
              ],

              // ── 4. Account Settings Section ────────────────
              FadeInLeft(
                delay: const Duration(milliseconds: 200),
                duration: const Duration(milliseconds: 400),
                child: _buildSectionCard(
                  title: 'Quản lý tài khoản',
                  items: [
                    ProfileMenuTile(
                      icon: Icons.person_outline_rounded,
                      title: 'Chỉnh sửa hồ sơ cá nhân',
                      subtitle: 'Họ tên, số điện thoại, ảnh đại diện',
                      onTap: () => context.push(AppRoutes.editProfile),
                    ),
                    ProfileMenuTile(
                      icon: Icons.location_on_outlined,
                      title: 'Sổ địa chỉ nhận hàng',
                      subtitle: '$addressCount địa chỉ đã lưu',
                      onTap: () => context.push(AppRoutes.addresses),
                    ),
                    ProfileMenuTile(
                      icon: Icons.lock_reset_rounded,
                      title: 'Đổi mật khẩu / Đặt lại mật khẩu',
                      subtitle: 'Gửi liên kết đặt lại về email',
                      showDivider: false,
                      onTap: () => _confirmResetPassword(context, ref),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSizes.lg),

              // ── 5. Shopping & Activities Section ───────────
              FadeInLeft(
                delay: const Duration(milliseconds: 250),
                duration: const Duration(milliseconds: 400),
                child: _buildSectionCard(
                  title: 'Mua sắm & Hoạt động',
                  items: [
                    ProfileMenuTile(
                      icon: Icons.shopping_bag_outlined,
                      title: 'Đơn hàng của tôi',
                      subtitle: 'Theo dõi tiến độ và lịch sử mua sắm',
                      onTap: () => context.go(AppRoutes.orderList),
                    ),
                    ProfileMenuTile(
                      icon: Icons.card_giftcard_outlined,
                      title: 'Kho voucher & Mã giảm giá',
                      subtitle: 'Các ưu đãi độc quyền dành cho bạn',
                      onTap: () => context.push(AppRoutes.vouchers),
                    ),
                    ProfileMenuTile(
                      icon: Icons.notifications_none_rounded,
                      title: 'Thông báo',
                      subtitle: 'Cập nhật đơn hàng và khuyến mãi mới',
                      onTap: () => context.push(AppRoutes.notifications),
                    ),
                    ProfileMenuTile(
                      icon: Icons.rate_review_outlined,
                      title: 'Đánh giá sản phẩm đã mua',
                      subtitle: 'Nhận xét về các điện thoại bạn đã mua',
                      showDivider: false,
                      onTap: () => context.push(AppRoutes.writeReview),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSizes.lg),

              // ── 6. Support & About Section ─────────────────
              FadeInLeft(
                delay: const Duration(milliseconds: 300),
                duration: const Duration(milliseconds: 400),
                child: _buildSectionCard(
                  title: 'Hỗ trợ & Thông tin',
                  items: [
                    ProfileMenuTile(
                      icon: Icons.headset_mic_outlined,
                      title: 'Tổng đài hỗ trợ (1900 8888)',
                      subtitle: 'Hỗ trợ kỹ thuật và mua hàng 24/7',
                      onTap: _callHotline,
                    ),
                    ProfileMenuTile(
                      icon: Icons.verified_user_outlined,
                      title: 'Chính sách bảo hành & Đổi trả',
                      subtitle: 'Bảo hành chính hãng 12 tháng',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Chính sách bảo hành chính hãng 12 tháng, đổi mới 30 ngày.',
                            ),
                          ),
                        );
                      },
                    ),
                    ProfileMenuTile(
                      icon: Icons.info_outline_rounded,
                      title: 'Phiên bản ứng dụng',
                      subtitle: 'SmartphoneHub v1.0.0 (Portfolio Build)',
                      showDivider: false,
                      trailing: const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSizes.lg),

              // ── 7. Logout Section ──────────────────────────
              FadeInUp(
                delay: const Duration(milliseconds: 350),
                duration: const Duration(milliseconds: 400),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppSizes.radiusLG),
                    border: Border.all(
                      color: AppColors.border.withValues(alpha: 0.8),
                    ),
                    boxShadow: AppColors.cardShadow,
                  ),
                  child: ProfileMenuTile(
                    icon: Icons.logout_rounded,
                    title: 'Đăng xuất tài khoản',
                    isDestructive: true,
                    showDivider: false,
                    onTap: () => _confirmSignOut(context, ref),
                  ),
                ),
              ),

              const SizedBox(height: AppSizes.xxxl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required List<Widget> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: AppSizes.sm),
          child: Text(
            title,
            style: AppTypography.titleSmall.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSizes.radiusLG),
            border: Border.all(
              color: AppColors.border.withValues(alpha: 0.8),
            ),
            boxShadow: AppColors.cardShadow,
          ),
          child: Column(
            children: items,
          ),
        ),
      ],
    );
  }
}
