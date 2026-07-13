import 'package:freezed_annotation/freezed_annotation.dart';

part 'training_pack.freezed.dart';

enum TrainingPackStatus {
  draft,
  published,
  archived,
}

@freezed
class TrainingPack with _$TrainingPack {
  const factory TrainingPack({
    required String id,
    required String title,
    required TrainingPackStatus status,
    int? estimatedDuration,
    @Default(0) int itemCount,
    required String version,
    DateTime? createdAt,
  }) = _TrainingPack;
}
