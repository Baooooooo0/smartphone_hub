import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/errors/failures.dart';
import '../../../core/services/image_upload_service.dart';
import '../../../data/repositories/auth_repository_impl.dart';
import '../../../domain/usecases/auth/auth_usecases.dart';
import 'profile_state.dart';

part 'profile_notifier.g.dart';

/// Alias tương thích với convention
final profileNotifierProvider = profileProvider;

@riverpod
class ProfileNotifier extends _$ProfileNotifier {
  late final ImageUploadService _imageUploadService;

  @override
  ProfileState build() {
    _imageUploadService = ImageUploadService();
    final currentUser = ref.watch(currentUserProvider);
    return ProfileState(user: currentUser);
  }

  String _getErrorMessage(dynamic e) {
    if (e is Failure) return e.message;
    if (e is AppException) return e.message;
    return e.toString();
  }

  /// Cập nhật thông tin hồ sơ (Tên, Số điện thoại)
  Future<bool> updateProfile({
    required String displayName,
    required String phoneNumber,
  }) async {
    state = state.copyWith(
      status: ProfileStatus.loading,
      errorMessage: null,
      successMessage: null,
    );

    try {
      final repo = ref.read(authRepositoryProvider);
      final useCase = UpdateProfileUseCase(repo);
      final updatedUser = await useCase(
        displayName: displayName.trim(),
        phoneNumber: phoneNumber.trim(),
      );

      state = state.copyWith(
        status: ProfileStatus.success,
        user: updatedUser,
        successMessage: 'Cập nhật thông tin thành công!',
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        status: ProfileStatus.error,
        errorMessage: _getErrorMessage(e),
      );
      return false;
    }
  }

  /// Chọn và tải lên ảnh đại diện mới
  Future<bool> changeAvatar(ImageSource source) async {
    final user = state.user ?? ref.read(currentUserProvider);
    if (user == null) {
      state = state.copyWith(
        status: ProfileStatus.error,
        errorMessage: 'Vui lòng đăng nhập để thực hiện thay đổi.',
      );
      return false;
    }

    try {
      final imageFile = await _imageUploadService.pickImage(source: source);
      if (imageFile == null) return false;

      state = state.copyWith(
        isUploadingAvatar: true,
        errorMessage: null,
        successMessage: null,
      );

      final downloadUrl = await _imageUploadService.uploadAvatar(
        userId: user.id,
        file: imageFile,
      );

      final repo = ref.read(authRepositoryProvider);
      final useCase = UpdateProfileUseCase(repo);
      final updatedUser = await useCase(photoURL: downloadUrl);

      state = state.copyWith(
        status: ProfileStatus.success,
        isUploadingAvatar: false,
        user: updatedUser,
        successMessage: 'Cập nhật ảnh đại diện thành công!',
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        status: ProfileStatus.error,
        isUploadingAvatar: false,
        errorMessage: _getErrorMessage(e),
      );
      return false;
    }
  }

  /// Gửi email đặt lại mật khẩu
  Future<bool> sendPasswordResetEmail() async {
    final user = state.user ?? ref.read(currentUserProvider);
    if (user == null || user.email.isEmpty) {
      state = state.copyWith(
        status: ProfileStatus.error,
        errorMessage: 'Không tìm thấy địa chỉ email của tài khoản.',
      );
      return false;
    }

    state = state.copyWith(status: ProfileStatus.loading, errorMessage: null);

    try {
      final repo = ref.read(authRepositoryProvider);
      final useCase = SendPasswordResetEmailUseCase(repo);
      await useCase(user.email);

      state = state.copyWith(
        status: ProfileStatus.success,
        successMessage: 'Đã gửi liên kết đặt lại mật khẩu tới ${user.email}',
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        status: ProfileStatus.error,
        errorMessage: _getErrorMessage(e),
      );
      return false;
    }
  }

  /// Đăng xuất tài khoản
  Future<void> signOut() async {
    state = state.copyWith(status: ProfileStatus.loading);
    try {
      final repo = ref.read(authRepositoryProvider);
      final useCase = SignOutUseCase(repo);
      await useCase();
      state = const ProfileState();
    } catch (e) {
      state = state.copyWith(
        status: ProfileStatus.error,
        errorMessage: _getErrorMessage(e),
      );
    }
  }

  void clearMessages() {
    state = state.copyWith(errorMessage: null, successMessage: null);
  }
}
