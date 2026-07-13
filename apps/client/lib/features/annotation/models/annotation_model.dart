class AnnotationModel {
  final String id;
  final String? groundTruthId;
  final String? answerId;
  final String type;
  final Map<String, dynamic> geometry; // structured JSON object
  final double? startSeconds;
  final double? endSeconds;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AnnotationModel({
    required this.id,
    this.groundTruthId,
    this.answerId,
    required this.type,
    required this.geometry,
    this.startSeconds,
    this.endSeconds,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AnnotationModel.fromJson(Map<String, dynamic> json) {
    return AnnotationModel(
      id: json['id'] as String,
      groundTruthId: json['groundTruthId'] as String?,
      answerId: json['answerId'] as String?,
      type: json['type'] as String,
      geometry: (json['geometry'] as Map<String, dynamic>?) ?? {},
      startSeconds: json['startSeconds'] != null
          ? (json['startSeconds'] as num).toDouble()
          : null,
      endSeconds: json['endSeconds'] != null
          ? (json['endSeconds'] as num).toDouble()
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}
