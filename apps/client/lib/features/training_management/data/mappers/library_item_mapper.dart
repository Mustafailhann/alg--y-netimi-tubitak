import '../models/library_item_dto.dart';
import '../../domain/models/library_item.dart';

class LibraryItemMapper {
  static LibraryItem fromSummaryDto(LibraryItemSummaryDto dto) {
    return LibraryItem(
      id: dto.id,
      assessmentId: dto.assessmentId,
      title: dto.title,
      mediaType: dto.mediaType,
      publishedAt: dto.publishedAt,
      version: dto.version,
    );
  }

  static LibraryItem fromDetailDto(LibraryItemDetailDto dto) {
    return LibraryItem(
      id: dto.id,
      assessmentId: dto.assessmentId,
      title: dto.title,
      mediaType: dto.mediaType,
      publishedAt: dto.publishedAt,
      version: dto.version,
      groundTruthSnapshot: dto.groundTruthSnapshot,
    );
  }
}
