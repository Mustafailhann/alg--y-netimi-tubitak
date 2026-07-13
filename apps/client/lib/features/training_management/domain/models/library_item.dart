import 'package:freezed_annotation/freezed_annotation.dart';

part 'library_item.freezed.dart';

@freezed
class LibraryItem with _$LibraryItem {
  const factory LibraryItem({
    required String id,
    required String assessmentId,
    required String title,
    required String mediaType,
    required DateTime publishedAt,
    required String version,
    String? groundTruthSnapshot,
  }) = _LibraryItem;
}
