import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_entity.freezed.dart';

/// CategoryEntity — Business entity cho danh mục sản phẩm
@freezed
abstract class CategoryEntity with _$CategoryEntity {
  const factory CategoryEntity({
    required String id,
    required String name,
    @Default('') String iconURL,
    @Default(0) int order,
    @Default(0) int productCount,
  }) = _CategoryEntity;
}
