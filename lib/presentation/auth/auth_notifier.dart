import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/usecases/auth/auth_usecases.dart';
import '../../../data/repositories/auth_repository_impl.dart';

part 'auth_notifier.g.dart';

/// AuthState — trạng thái của form auth (login/register)
enum AuthStatus { initial, loading, success, error }

class AuthState {
  final AuthStatus status;
  final String? errorMessage;
  final UserEntity? user;

  const AuthState({
    this.status = AuthStatus.initial,
    this.errorMessage,
    this.user,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? errorMessage,
    UserEntity? user,
  }) =>
      AuthState(
        status: status ?? this.status,
        errorMessage: errorMessage,
        user: user ?? this.user,
      );

  bool get isLoading => status == AuthStatus.loading;
  bool get isError => status == AuthStatus.error;
  bool get isSuccess => status == AuthStatus.success;
}

/// AuthNotifier — Quản lý state của login/register actions
@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() => const AuthState();

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final repo = ref.read(authRepositoryProvider);
      final useCase = SignInWithEmailUseCase(repo);
      final user = await useCase(email: email, password: password);
      state = state.copyWith(status: AuthStatus.success, user: user);
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> signInWithGoogle() async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final repo = ref.read(authRepositoryProvider);
      final useCase = SignInWithGoogleUseCase(repo);
      final user = await useCase();
      state = state.copyWith(status: AuthStatus.success, user: user);
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final repo = ref.read(authRepositoryProvider);
      final useCase = RegisterUseCase(repo);
      final user = await useCase(
        email: email,
        password: password,
        displayName: displayName,
      );
      state = state.copyWith(status: AuthStatus.success, user: user);
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> sendPasswordReset(String email) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final repo = ref.read(authRepositoryProvider);
      final useCase = SendPasswordResetEmailUseCase(repo);
      await useCase(email);
      state = state.copyWith(status: AuthStatus.success);
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> signOut() async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final repo = ref.read(authRepositoryProvider);
      final useCase = SignOutUseCase(repo);
      await useCase();
      state = const AuthState();
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  void clearError() {
    state = state.copyWith(status: AuthStatus.initial);
  }
}
