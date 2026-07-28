import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/app_exception.dart';

part 'auth_repository_impl.g.dart';

@riverpod
AuthRepository authRepository(Ref ref) => AuthRepositoryImpl(
      firebaseAuth: FirebaseAuth.instance,
      firestore: FirebaseFirestore.instance,
      googleSignIn: GoogleSignIn(),
    );


/// AuthRepositoryImpl — concrete implementation dùng Firebase Auth + Firestore
class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;

  AuthRepositoryImpl({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
    required GoogleSignIn googleSignIn,
  })  : _auth = firebaseAuth,
        _firestore = firestore,
        _googleSignIn = googleSignIn;

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection('users');

  // ─── Stream auth state ──────────────────────────────────────
  @override
  Stream<UserEntity?> get authStateChanges {
    return _auth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;
      return _fetchOrCreateUser(firebaseUser);
    });
  }

  @override
  UserEntity? get currentUser {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser == null) return null;
    // Return minimal entity từ Firebase Auth (không có addresses)
    return UserEntity(
      id: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      displayName: firebaseUser.displayName ?? '',
      photoURL: firebaseUser.photoURL ?? '',
    );
  }

  // ─── Email Sign In ──────────────────────────────────────────
  @override
  Future<UserEntity> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _fetchOrCreateUser(credential.user!);
    } on FirebaseAuthException catch (e) {
      throw AppException.fromFirebaseAuth(e);
    }
  }

  // ─── Google Sign In ──────────────────────────────────────────────
  @override
  Future<UserEntity> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw const AuthFailure(message: 'Đăng nhập Google bị hủy');
      }
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential = await _auth.signInWithCredential(credential);
      return _fetchOrCreateUser(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      throw AppException.fromFirebaseAuth(e);
    } on AuthFailure {
      rethrow;
    } catch (e) {
      throw AuthFailure(message: 'Lỗi đăng nhập Google: $e');
    }
  }

  // ─── Register ───────────────────────────────────────────────
  @override
  Future<UserEntity> registerWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Cập nhật displayName trong Firebase Auth
      await credential.user!.updateDisplayName(displayName);

      // Tạo document trong Firestore /users/{uid}
      final userModel = UserModel(
        id: credential.user!.uid,
        email: email,
        displayName: displayName,
        role: 'customer',
        createdAt: DateTime.now(),
      );
      await _users
          .doc(credential.user!.uid)
          .set(userModel.toFirestore());

      return userModel.toEntity();
    } on FirebaseAuthException catch (e) {
      throw AppException.fromFirebaseAuth(e);
    }
  }

  // ─── Forgot Password ────────────────────────────────────────
  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw AppException.fromFirebaseAuth(e);
    }
  }

  // ─── Sign Out ───────────────────────────────────────────────
  @override
  Future<void> signOut() async {
    await Future.wait([
      _auth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  // ─── Update FCM Token ───────────────────────────────────────
  @override
  Future<void> updateFcmToken(String token) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    await _users.doc(uid).update({
      'fcmTokens': FieldValue.arrayUnion([token]),
    });
  }

  // ─── Update Profile ─────────────────────────────────────────
  @override
  Future<UserEntity> updateProfile({
    String? displayName,
    String? photoURL,
    String? phoneNumber,
  }) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw const AuthFailure(message: 'Chưa đăng nhập');
    try {
      final updates = <String, dynamic>{};
      if (displayName != null) updates['displayName'] = displayName;
      if (photoURL != null) updates['photoURL'] = photoURL;
      if (phoneNumber != null) updates['phoneNumber'] = phoneNumber;

      if (updates.isNotEmpty) {
        await _users.doc(uid).update(updates);
        if (displayName != null) {
          await _auth.currentUser!.updateDisplayName(displayName);
        }
        if (photoURL != null) {
          await _auth.currentUser!.updatePhotoURL(photoURL);
        }
      }
      return _fetchOrCreateUser(_auth.currentUser!);
    } on FirebaseException catch (e) {
      throw AppException.fromFirestore(e);
    }
  }

  // ─── Private Helpers ────────────────────────────────────────

  /// Lấy user từ Firestore, tạo mới nếu chưa tồn tại
  Future<UserEntity> _fetchOrCreateUser(User firebaseUser) async {
    try {
      final doc = await _users.doc(firebaseUser.uid).get();
      if (doc.exists && doc.data() != null) {
        return UserModel.fromFirestore(doc.data()!, doc.id).toEntity();
      }
      // Tạo document mới (trường hợp đăng nhập Google lần đầu)
      final userModel = UserModel(
        id: firebaseUser.uid,
        email: firebaseUser.email ?? '',
        displayName: firebaseUser.displayName ?? '',
        photoURL: firebaseUser.photoURL ?? '',
        role: 'customer',
        createdAt: DateTime.now(),
      );
      await _users.doc(firebaseUser.uid).set(userModel.toFirestore());
      return userModel.toEntity();
    } on FirebaseException catch (e) {
      throw AppException.fromFirestore(e);
    }
  }
}
