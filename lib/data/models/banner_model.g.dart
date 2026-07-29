// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banner_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BannerModel _$BannerModelFromJson(Map<String, dynamic> json) => _BannerModel(
  id: json['id'] as String,
  imageURL: json['image_u_r_l'] as String,
  targetType: json['target_type'] as String? ?? 'external_url',
  targetId: json['target_id'] as String? ?? '',
  isActive: json['is_active'] as bool? ?? true,
  order: (json['order'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$BannerModelToJson(_BannerModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'image_u_r_l': instance.imageURL,
      'target_type': instance.targetType,
      'target_id': instance.targetId,
      'is_active': instance.isActive,
      'order': instance.order,
    };
