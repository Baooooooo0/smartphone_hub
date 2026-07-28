import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../data/repositories/auth_repository_impl.dart';


// ─── UseCase Classes ──────────────────────────────────────────────────────────

class SignInWithEmailUseCase {
  final AuthRepository _repo;
  SignInWithEmailUseCase(this._repo);

  Future<UserEntity> call({
    required String email,
    required String password,
  }) =>
      _repo.signInWithEmail(email: email, password: password);
}

class SignInWithGoogleUseCase {
  final AuthRepository _repo;
  SignInWithGoogleUseCase(this._repo);

  Future<UserEntity> call() => _repo.signInWithGoogle();
}

class RegisterUseCase {
  final AuthRepository _repo;
  RegisterUseCase(this._repo);

  Future<UserEntity> call({
    required String email,
    required String password,
    required String displayName,
  }) =>
      _repo.registerWithEmail(
        email: email,
        password: password,
        displayName: displayName,
      );
}

class SendPasswordResetEmailUseCase {
  final AuthRepository _repo;
  SendPasswordResetEmailUseCase(this._repo);

  Future<void> call(String email) => _repo.sendPasswordResetEmail(email);
}

class SignOutUseCase {
  final AuthRepository _repo;
  SignOutUseCase(this._repo);

  Future<void> call() => _repo.signOut();
}

// ─── Auth State Providers (manual — tránh nullable type issue với code gen) ───

/// Stream trạng thái đăng nhập: null = chưa đăng nhập
final authStateProvider = StreamProvider<UserEntity?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

/// User hiện tại (null nếu chưa đăng nhập)
final currentUserProvider = Provider<UserEntity?>((ref) {
  final asyncUser = ref.watch(authStateProvider);
  return asyncUser.when(
    data: (user) => user,
    loading: () => null,
    error: (_, _) => null,
  );
});

/// true nếu đã đăng nhập
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(currentUserProvider) != null;
});

/// true nếu user có role admin
final isAdminProvider = Provider<bool>((ref) {
  return ref.watch(currentUserProvider)?.isAdmin ?? false;
});
