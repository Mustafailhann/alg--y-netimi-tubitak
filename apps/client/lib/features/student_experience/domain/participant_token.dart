class ParticipantToken {
  final String participantId;
  final String token;

  const ParticipantToken({
    required this.participantId,
    required this.token,
  });

  factory ParticipantToken.fromJson(Map<String, dynamic> json) {
    return ParticipantToken(
      participantId: json['id'] as String,
      token: json['token'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': participantId,
      'token': token,
    };
  }
}
