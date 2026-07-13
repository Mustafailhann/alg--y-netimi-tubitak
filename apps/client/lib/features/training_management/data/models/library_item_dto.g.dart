// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_item_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LibraryItemSummaryDtoImpl _$$LibraryItemSummaryDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$LibraryItemSummaryDtoImpl(
      id: json['id'] as String,
      assessmentId: json['assessmentId'] as String,
      title: json['title'] as String,
      mediaType: json['mediaType'] as String,
      publishedAt: DateTime.parse(json['publishedAt'] as String),
      version: json['version'] as String,
    );

Map<String, dynamic> _$$LibraryItemSummaryDtoImplToJson(
        _$LibraryItemSummaryDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'assessmentId': instance.assessmentId,
      'title': instance.title,
      'mediaType': instance.mediaType,
      'publishedAt': instance.publishedAt.toIso8601String(),
      'version': instance.version,
    };

_$LibraryItemDetailDtoImpl _$$LibraryItemDetailDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$LibraryItemDetailDtoImpl(
      id: json['id'] as String,
      assessmentId: json['assessmentId'] as String,
      title: json['title'] as String,
      mediaType: json['mediaType'] as String,
      groundTruthSnapshot: json['groundTruthSnapshot'] as String?,
      publishedAt: DateTime.parse(json['publishedAt'] as String),
      version: json['version'] as String,
    );

Map<String, dynamic> _$$LibraryItemDetailDtoImplToJson(
        _$LibraryItemDetailDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'assessmentId': instance.assessmentId,
      'title': instance.title,
      'mediaType': instance.mediaType,
      'groundTruthSnapshot': instance.groundTruthSnapshot,
      'publishedAt': instance.publishedAt.toIso8601String(),
      'version': instance.version,
    };
