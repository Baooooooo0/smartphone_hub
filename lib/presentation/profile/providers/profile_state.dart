import '../../../domain/entities/user_entity.dart';

enum ProfileStatus { initial, loading, success, error }

class ProfileState {
  final ProfileStatus status;
  final bool isUploadingAvatar;
  final String? errorMessage;
  final String? successMessage;
  final UserEntity? user;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.isUploadingAvatar = false,
    this.errorMessage,
    this.successMessage,
    this.user,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    bool? isUploadingAvatar,
    String? errorMessage,
    String? successMessage,
    UserEntity? user,
  }) =>
      ProfileState(
        status: status ?? this.status,
        isUploadingAvatar: isUploadingAvatar ?? this.isUploadingAvatar,
        errorMessage: errorMessage,
        successMessage: successMessage,
        user: user ?? this.user,
      );

  bool get isLoading => status == ProfileStatus.loading;
  bool get isSuccess => status == ProfileStatus.success;
  bool get isError => status == ProfileStatus.error;
}
