import 'package:freezed_annotation/freezed_annotation.dart';

part 'participant.freezed.dart';

enum ConnectionStatus {
  disconnected,
  connected,
}

@freezed
class Participant with _$Participant {
  const factory Participant({
    required String id,
    required String studentIdentifier,
    required DateTime joinedAt,
    required int progressPercentage,
    required int score,
    required ConnectionStatus connectionStatus,
    required DateTime lastSeen,
  }) = _Participant;
}
