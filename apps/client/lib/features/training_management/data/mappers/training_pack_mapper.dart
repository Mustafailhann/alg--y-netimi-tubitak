import '../models/training_pack_dto.dart';
import '../../domain/models/training_pack.dart';
import '../../domain/models/training_item.dart';

class TrainingPackMapper {
  static TrainingPack fromDto(TrainingPackDto dto) {
    return TrainingPack(
      id: dto.id,
      title: dto.title,
      status: _mapStatus(dto.status),
      estimatedDuration: dto.estimatedDuration,
      itemCount: dto.itemCount,
      version: dto.version,
    );
  }

  static TrainingPack fromDetailDto(TrainingPackDetailDto dto) {
    return TrainingPack(
      id: dto.id,
      title: dto.title,
      status: _mapStatus(dto.status),
      estimatedDuration: dto.estimatedDuration,
      itemCount: 0, // Not provided in detail dto, needs to be merged or loaded separately
      version: dto.version,
      createdAt: dto.createdAt,
    );
  }

  static TrainingItem itemFromDto(TrainingItemDto dto) {
    return TrainingItem(
      id: dto.id,
      libraryItemId: dto.libraryItemId,
      orderIndex: dto.orderIndex,
      libraryItemTitle: dto.libraryItemTitle,
      libraryItemMediaType: dto.libraryItemMediaType,
    );
  }

  static TrainingPackStatus _mapStatus(String status) {
    switch (status) {
      case 'Draft':
        return TrainingPackStatus.draft;
      case 'Published':
        return TrainingPackStatus.published;
      case 'Archived':
        return TrainingPackStatus.archived;
      default:
        return TrainingPackStatus.draft;
    }
  }
}
