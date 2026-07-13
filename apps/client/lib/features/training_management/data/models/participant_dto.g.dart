// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participant_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ParticipantDtoImpl _$$ParticipantDtoImplFromJson(Map<String, dynamic> json) =>
    _$ParticipantDtoImpl(
      id: json['id'] as String,
      studentIdentifier: json['studentIdentifier'] as String,
      joinedAt: DateTime.parse(json['joinedAt'] as String),
      progressPercentage: (json['progressPercentage'] as num).toInt(),
      score: (json['score'] as num).toInt(),
      connectionStatus: json['connectionStatus'] as String,
      lastSeen: DateTime.parse(json['lastSeen'] as String),
    );

Map<String, dynamic> _$$ParticipantDtoImplToJson(
        _$ParticipantDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'studentIdentifier': instance.studentIdentifier,
      'joinedAt': instance.joinedAt.toIso8601String(),
      'progressPercentage': instance.progressPercentage,
      'score': instance.score,
      'connectionStatus': instance.connectionStatus,
      'lastSeen': instance.lastSeen.toIso8601String(),
    };
