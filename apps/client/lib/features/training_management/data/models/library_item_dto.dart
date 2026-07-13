import 'package:freezed_annotation/freezed_annotation.dart';

part 'library_item_dto.freezed.dart';
part 'library_item_dto.g.dart';

@freezed
class LibraryItemSummaryDto with _$LibraryItemSummaryDto {
  const factory LibraryItemSummaryDto({
    required String id,
    required String assessmentId,
    required String title,
    required String mediaType,
    required DateTime publishedAt,
    required String version,
  }) = _LibraryItemSummaryDto;

  factory LibraryItemSummaryDto.fromJson(Map<String, dynamic> json) => _$LibraryItemSummaryDtoFromJson(json);
}

@freezed
class LibraryItemDetailDto with _$LibraryItemDetailDto {
  const factory LibraryItemDetailDto({
    required String id,
    required String assessmentId,
    required String title,
    required String mediaType,
    String? groundTruthSnapshot,
    required DateTime publishedAt,
    required String version,
  }) = _LibraryItemDetailDto;

  factory LibraryItemDetailDto.fromJson(Map<String, dynamic> json) => _$LibraryItemDetailDtoFromJson(json);
}
