import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../errors/app_exception.dart';

/// ImageUploadService — Dịch vụ chọn ảnh và upload lên Storage
class ImageUploadService {
  final ImagePicker _picker;
  final FirebaseStorage _storage;

  ImageUploadService({
    ImagePicker? picker,
    FirebaseStorage? storage,
  })  : _picker = picker ?? ImagePicker(),
        _storage = storage ?? FirebaseStorage.instance;

  /// Chọn ảnh từ máy ảnh hoặc thư viện
  Future<File?> pickImage({
    required ImageSource source,
    double maxWidth = 1024,
    double maxHeight = 1024,
    int imageQuality = 85,
  }) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: imageQuality,
      );

      if (pickedFile == null) return null;
      return File(pickedFile.path);
    } catch (e) {
      throw AppException(
        message: 'Không thể chọn ảnh: $e',
        code: 'image_pick_error',
      );
    }
  }

  /// Upload avatar người dùng lên Firebase Storage và trả về URL
  Future<String> uploadAvatar({
    required String userId,
    required File file,
  }) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final ref = _storage.ref().child('avatars/$userId/avatar_$timestamp.jpg');

      final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'userId': userId},
      );

      final uploadTask = ref.putFile(file, metadata);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } on FirebaseException catch (e) {
      throw AppException.fromStorage(e);
    } catch (e) {
      throw AppException(
        message: 'Không thể tải ảnh lên máy chủ: $e',
        code: 'avatar_upload_error',
      );
    }
  }
}
