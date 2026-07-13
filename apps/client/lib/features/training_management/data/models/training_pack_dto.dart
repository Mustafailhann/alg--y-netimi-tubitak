import 'package:freezed_annotation/freezed_annotation.dart';

part 'training_pack_dto.freezed.dart';
part 'training_pack_dto.g.dart';

@freezed
class TrainingPackDto with _$TrainingPackDto {
  const factory TrainingPackDto({
    required String id,
    required String title,
    required String status, // "Draft", "Published", "Archived" from backend
    int? estimatedDuration,
    required int itemCount,
    required String version,
  }) = _TrainingPackDto;

  factory TrainingPackDto.fromJson(Map<String, dynamic> json) => _$TrainingPackDtoFromJson(json);
}

@freezed
class TrainingPackDetailDto with _$TrainingPackDetailDto {
  const factory TrainingPackDetailDto({
    required String id,
    required String teacherId,
    required String title,
    required String status,
    int? estimatedDuration,
    required String version,
    required DateTime createdAt,
  }) = _TrainingPackDetailDto;

  factory TrainingPackDetailDto.fromJson(Map<String, dynamic> json) => _$TrainingPackDetailDtoFromJson(json);
}

@freezed
class TrainingItemDto with _$TrainingItemDto {
  const factory TrainingItemDto({
    required String id,
    required String libraryItemId,
    required int orderIndex,
    required String libraryItemTitle,
    required String libraryItemMediaType,
  }) = _TrainingItemDto;

  factory TrainingItemDto.fromJson(Map<String, dynamic> json) => _$TrainingItemDtoFromJson(json);
}
