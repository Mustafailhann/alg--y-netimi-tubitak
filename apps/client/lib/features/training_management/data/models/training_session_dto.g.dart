// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'training_session_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TrainingSessionDtoImpl _$$TrainingSessionDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$TrainingSessionDtoImpl(
      id: json['id'] as String,
      trainingPackId: json['trainingPackId'] as String,
      joinCode: json['joinCode'] as String,
      status: json['status'] as String,
      participantCount: (json['participantCount'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$TrainingSessionDtoImplToJson(
        _$TrainingSessionDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'trainingPackId': instance.trainingPackId,
      'joinCode': instance.joinCode,
      'status': instance.status,
      'participantCount': instance.participantCount,
      'createdAt': instance.createdAt.toIso8601String(),
    };

_$TrainingSessionDetailDtoImpl _$$TrainingSessionDetailDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$TrainingSessionDetailDtoImpl(
      id: json['id'] as String,
      trainingPackId: json['trainingPackId'] as String,
      joinCode: json['joinCode'] as String,
      status: json['status'] as String,
      participantCount: (json['participantCount'] as num).toInt(),
      timeLimitMinutes: (json['timeLimitMinutes'] as num?)?.toInt(),
      randomQuestionOrder: json['randomQuestionOrder'] as bool? ?? false,
      allowRetry: json['allowRetry'] as bool? ?? false,
      showImmediateFeedback: json['showImmediateFeedback'] as bool? ?? false,
      leaderboardEnabled: json['leaderboardEnabled'] as bool? ?? false,
      canvasRequired: json['canvasRequired'] as bool? ?? false,
      maximumAttempts: (json['maximumAttempts'] as num?)?.toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      version: json['version'] as String,
    );

Map<String, dynamic> _$$TrainingSessionDetailDtoImplToJson(
        _$TrainingSessionDetailDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'trainingPackId': instance.trainingPackId,
      'joinCode': instance.joinCode,
      'status': instance.status,
      'participantCount': instance.participantCount,
      'timeLimitMinutes': instance.timeLimitMinutes,
      'randomQuestionOrder': instance.randomQuestionOrder,
      'allowRetry': instance.allowRetry,
      'showImmediateFeedback': instance.showImmediateFeedback,
      'leaderboardEnabled': instance.leaderboardEnabled,
      'canvasRequired': instance.canvasRequired,
      'maximumAttempts': instance.maximumAttempts,
      'createdAt': instance.createdAt.toIso8601String(),
      'version': instance.version,
    };
