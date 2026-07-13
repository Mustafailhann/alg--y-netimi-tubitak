import 'package:freezed_annotation/freezed_annotation.dart';

part 'participant_dto.freezed.dart';
part 'participant_dto.g.dart';

@freezed
class ParticipantDto with _$ParticipantDto {
  const factory ParticipantDto({
    required String id,
    required String studentIdentifier,
    required DateTime joinedAt,
    required int progressPercentage,
    required int score,
    required String connectionStatus, // Enum
    required DateTime lastSeen,
  }) = _ParticipantDto;

  factory ParticipantDto.fromJson(Map<String, dynamic> json) => _$ParticipantDtoFromJson(json);
}
