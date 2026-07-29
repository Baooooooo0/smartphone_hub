import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/banner_entity.dart';

part 'banner_model.freezed.dart';
part 'banner_model.g.dart';

/// BannerModel — DTO cho Firestore /banners/{bannerId}
@freezed
abstract class BannerModel with _$BannerModel {
  const factory BannerModel({
    required String id,
    required String imageURL,
    @Default('external_url') String targetType,
    @Default('') String targetId,
    @Default(true) bool isActive,
    @Default(0) int order,
  }) = _BannerModel;

  factory BannerModel.fromJson(Map<String, dynamic> json) =>
      _$BannerModelFromJson(json);

  const BannerModel._();

  factory BannerModel.fromFirestore(Map<String, dynamic> data, String id) {
    return BannerModel(
      id: id,
      imageURL: data['imageURL'] as String? ?? '',
      targetType: data['targetType'] as String? ?? 'external_url',
      targetId: data['targetId'] as String? ?? '',
      isActive: data['isActive'] as bool? ?? true,
      order: (data['order'] as num?)?.toInt() ?? 0,
    );
  }

  BannerEntity toEntity() => BannerEntity(
        id: id,
        imageURL: imageURL,
        targetType: targetType,
        targetId: targetId,
        isActive: isActive,
        order: order,
      );
}
