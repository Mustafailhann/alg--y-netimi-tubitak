import 'package:dio/dio.dart';
import '../models/annotation_model.dart';

class AnnotationDataSource {
  final Dio _dio;

  AnnotationDataSource(this._dio);

  /// GET /api/annotations/{id}
  Future<AnnotationModel> getById(String id) async {
    final response = await _dio.get('/annotations/$id');
    return AnnotationModel.fromJson(response.data as Map<String, dynamic>);
  }

  /// GET /api/annotations/groundtruth/{groundTruthId}
  Future<List<AnnotationModel>> getByGroundTruth(String groundTruthId) async {
    final response = await _dio.get('/annotations/groundtruth/$groundTruthId');
    return (response.data as List)
        .map((item) => AnnotationModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// GET /api/annotations/session/{sessionId}/participant
  Future<List<AnnotationModel>> getBySessionParticipant(String sessionId) async {
    final response = await _dio.get('/annotations/session/$sessionId/participant');
    return (response.data as List)
        .map((item) => AnnotationModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// POST /api/annotations
  Future<AnnotationModel> createAnnotation({
    String? groundTruthId,
    required String type,
    required Map<String, dynamic> geometry,
  }) async {
    final data = <String, dynamic>{
      'type': type,
      'geometry': geometry,
    };
    if (groundTruthId != null) {
      data['groundTruthId'] = groundTruthId;
    }
    final response = await _dio.post('/annotations', data: data);
    return AnnotationModel.fromJson(response.data as Map<String, dynamic>);
  }

  /// PUT /api/annotations/{id}
  Future<AnnotationModel> updateAnnotation({
    required String id,
    required String type,
    required Map<String, dynamic> geometry,
  }) async {
    final response = await _dio.put('/annotations/$id', data: {
      'type': type,
      'geometry': geometry,
    });
    return AnnotationModel.fromJson(response.data as Map<String, dynamic>);
  }

  /// DELETE /api/annotations/{id}
  Future<void> deleteAnnotation(String id) async {
    await _dio.delete('/annotations/$id');
  }
}
