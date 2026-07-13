import 'package:freezed_annotation/freezed_annotation.dart';

part 'training_item.freezed.dart';

@freezed
class TrainingItem with _$TrainingItem {
  const factory TrainingItem({
    required String id,
    required String libraryItemId,
    required int orderIndex,
    required String libraryItemTitle,
    required String libraryItemMediaType,
  }) = _TrainingItem;
}
