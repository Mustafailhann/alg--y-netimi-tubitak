class AssessmentListModel {
  final String id;
  final String mediaId;
  final String question;
  final String status;

  AssessmentListModel({
    required this.id,
    required this.mediaId,
    required this.question,
    required this.status,
  });

  factory AssessmentListModel.fromJson(Map<String, dynamic> json) {
    return AssessmentListModel(
      id: json['id'],
      mediaId: json['mediaId'],
      question: json['question'],
      status: json['status'].toString(),
    );
  }
}

class GroundTruthModel {
  final String id;
  final String assessmentId;
  final String judgment;
  final String? manipulationCategoryId;
  final String reason;
  final String status;

  GroundTruthModel({
    required this.id,
    required this.assessmentId,
    required this.judgment,
    this.manipulationCategoryId,
    required this.reason,
    required this.status,
  });

  factory GroundTruthModel.fromJson(Map<String, dynamic> json) {
    return GroundTruthModel(
      id: json['id'],
      assessmentId: json['assessmentId'],
      judgment: json['judgment'].toString(),
      manipulationCategoryId: json['manipulationCategoryId']?.toString(),
      reason: json['reason'] ?? '',
      status: json['status'].toString(),
    );
  }
}

class AssessmentDetailModel {
  final String id;
  final String mediaId;
  final String question;
  final String status;
  final GroundTruthModel? groundTruth;

  AssessmentDetailModel({
    required this.id,
    required this.mediaId,
    required this.question,
    required this.status,
    this.groundTruth,
  });

  factory AssessmentDetailModel.fromJson(Map<String, dynamic> json) {
    return AssessmentDetailModel(
      id: json['id'],
      mediaId: json['mediaId'],
      question: json['question'],
      status: json['status'].toString(),
      groundTruth: json['groundTruth'] != null ? GroundTruthModel.fromJson(json['groundTruth']) : null,
    );
  }
}
