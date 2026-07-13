import '../models/participant_dto.dart';
import '../../domain/models/participant.dart';

class ParticipantMapper {
  static Participant fromDto(ParticipantDto dto) {
    return Participant(
      id: dto.id,
      studentIdentifier: dto.studentIdentifier,
      joinedAt: dto.joinedAt,
      progressPercentage: dto.progressPercentage,
      score: dto.score,
      connectionStatus: _mapConnectionStatus(dto.connectionStatus),
      lastSeen: dto.lastSeen,
    );
  }

  static ConnectionStatus _mapConnectionStatus(String status) {
    switch (status) {
      case 'Offline':
        return ConnectionStatus.disconnected;
      case 'Online':
      case 'Idle':
        return ConnectionStatus.connected;
      default:
        return ConnectionStatus.disconnected;
    }
  }
}
