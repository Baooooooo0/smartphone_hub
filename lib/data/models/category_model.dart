import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/category_entity.dart';

part 'category_model.freezed.dart';
part 'category_model.g.dart';

/// CategoryModel — DTO cho Firestore /categories/{categoryId}
@freezed
abstract class CategoryModel with _$CategoryModel {
  const factory CategoryModel({
    required String id,
    required String name,
    @Default('') String iconURL,
    @Default(0) int order,
    @Default(0) int productCount,
  }) = _CategoryModel;

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  const CategoryModel._();

  factory CategoryModel.fromFirestore(Map<String, dynamic> data, String id) {
    return CategoryModel(
      id: id,
      name: data['name'] as String? ?? '',
      iconURL: data['iconURL'] as String? ?? '',
      order: (data['order'] as num?)?.toInt() ?? 0,
      productCount: (data['productCount'] as num?)?.toInt() ?? 0,
    );
  }

  CategoryEntity toEntity() => CategoryEntity(
        id: id,
        name: name,
        iconURL: iconURL,
        order: order,
        productCount: productCount,
      );
}
