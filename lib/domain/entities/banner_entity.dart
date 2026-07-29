import 'package:freezed_annotation/freezed_annotation.dart';

part 'banner_entity.freezed.dart';

/// BannerEntity — Business entity cho banner quảng cáo
@freezed
abstract class BannerEntity with _$BannerEntity {
  const factory BannerEntity({
    required String id,
    required String imageURL,
    @Default('external_url') String targetType,
    @Default('') String targetId,
    @Default(true) bool isActive,
    @Default(0) int order,
  }) = _BannerEntity;
}
