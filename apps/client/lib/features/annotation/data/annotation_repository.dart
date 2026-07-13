import 'annotation_data_source.dart';
import '../models/annotation_model.dart';

class AnnotationRepository {
  final AnnotationDataSource _dataSource;

  AnnotationRepository(this._dataSource);

  Future<AnnotationModel> getById(String id) =>
      _dataSource.getById(id);

  Future<List<AnnotationModel>> getByGroundTruth(String groundTruthId) =>
      _dataSource.getByGroundTruth(groundTruthId);

  Future<List<AnnotationModel>> getBySessionParticipant(String sessionId) =>
      _dataSource.getBySessionParticipant(sessionId);

  Future<AnnotationModel> createAnnotation({
    String? groundTruthId,
    required String type,
    required Map<String, dynamic> geometry,
  }) =>
      _dataSource.createAnnotation(
        groundTruthId: groundTruthId,
        type: type,
        geometry: geometry,
      );

  Future<AnnotationModel> updateAnnotation({
    required String id,
    required String type,
    required Map<String, dynamic> geometry,
  }) =>
      _dataSource.updateAnnotation(id: id, type: type, geometry: geometry);

  Future<void> deleteAnnotation(String id) =>
      _dataSource.deleteAnnotation(id);
}
