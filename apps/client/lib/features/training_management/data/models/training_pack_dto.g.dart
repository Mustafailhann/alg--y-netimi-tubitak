// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'training_pack_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TrainingPackDtoImpl _$$TrainingPackDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$TrainingPackDtoImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      status: json['status'] as String,
      estimatedDuration: (json['estimatedDuration'] as num?)?.toInt(),
      itemCount: (json['itemCount'] as num).toInt(),
      version: json['version'] as String,
    );

Map<String, dynamic> _$$TrainingPackDtoImplToJson(
        _$TrainingPackDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'status': instance.status,
      'estimatedDuration': instance.estimatedDuration,
      'itemCount': instance.itemCount,
      'version': instance.version,
    };

_$TrainingPackDetailDtoImpl _$$TrainingPackDetailDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$TrainingPackDetailDtoImpl(
      id: json['id'] as String,
      teacherId: json['teacherId'] as String,
      title: json['title'] as String,
      status: json['status'] as String,
      estimatedDuration: (json['estimatedDuration'] as num?)?.toInt(),
      version: json['version'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$TrainingPackDetailDtoImplToJson(
        _$TrainingPackDetailDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'teacherId': instance.teacherId,
      'title': instance.title,
      'status': instance.status,
      'estimatedDuration': instance.estimatedDuration,
      'version': instance.version,
      'createdAt': instance.createdAt.toIso8601String(),
    };

_$TrainingItemDtoImpl _$$TrainingItemDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$TrainingItemDtoImpl(
      id: json['id'] as String,
      libraryItemId: json['libraryItemId'] as String,
      orderIndex: (json['orderIndex'] as num).toInt(),
      libraryItemTitle: json['libraryItemTitle'] as String,
      libraryItemMediaType: json['libraryItemMediaType'] as String,
    );

Map<String, dynamic> _$$TrainingItemDtoImplToJson(
        _$TrainingItemDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'libraryItemId': instance.libraryItemId,
      'orderIndex': instance.orderIndex,
      'libraryItemTitle': instance.libraryItemTitle,
      'libraryItemMediaType': instance.libraryItemMediaType,
    };
