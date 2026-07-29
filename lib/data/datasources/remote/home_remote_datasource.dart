import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/banner_model.dart';
import '../../models/category_model.dart';

/// HomeRemoteDataSource — Fetch banners + categories từ Firestore
class HomeRemoteDataSource {
  final FirebaseFirestore _firestore;

  HomeRemoteDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Lấy danh sách banner đang active, sắp xếp theo order tăng dần
  Future<List<BannerModel>> getBanners() async {
    final snapshot = await _firestore
        .collection('banners')
        .where('isActive', isEqualTo: true)
        .orderBy('order')
        .get();

    return snapshot.docs
        .map((doc) => BannerModel.fromFirestore(doc.data(), doc.id))
        .toList();
  }

  /// Lấy danh sách danh mục, sắp xếp theo order tăng dần
  Future<List<CategoryModel>> getCategories() async {
    final snapshot = await _firestore
        .collection('categories')
        .orderBy('order')
        .get();

    return snapshot.docs
        .map((doc) => CategoryModel.fromFirestore(doc.data(), doc.id))
        .toList();
  }
}
