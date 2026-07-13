import 'admin_data_source.dart';
import '../models/category_model.dart';
import '../models/media_model.dart';
import '../models/assessment_model.dart';

class AdminRepository {
  final AdminDataSource _dataSource;

  AdminRepository(this._dataSource);

  Future<List<CategoryModel>> getCategories() => _dataSource.getCategories();
  Future<CategoryModel> createCategory(String name, String desc) => _dataSource.createCategory(name, desc);
  Future<void> deleteCategory(String id) => _dataSource.deleteCategory(id);

  Future<List<MediaModel>> getMedia() => _dataSource.getMedia();
  Future<MediaModel> uploadMedia(String filePath, {List<int>? bytes, String? filename}) => _dataSource.uploadMedia(filePath, bytes: bytes, filename: filename);
  Future<void> deleteMedia(String id) => _dataSource.deleteMedia(id);
  Future<MediaModel> reprocessMedia(String id) => _dataSource.reprocessMedia(id);

  Future<List<AssessmentListModel>> getAssessments() => _dataSource.getAssessments();
  Future<AssessmentDetailModel> getAssessmentById(String id) => _dataSource.getAssessmentById(id);
  Future<AssessmentDetailModel> createAssessment(String mediaId, String question) => _dataSource.createAssessment(mediaId, question);
  Future<void> archiveAssessment(String id) => _dataSource.archiveAssessment(id);
  Future<void> markAssessmentReady(String id) => _dataSource.markAssessmentReady(id);
  Future<void> publishAssessment(String id) => _dataSource.publishAssessment(id);

  Future<GroundTruthModel> createGroundTruth(String assessmentId, int judgment, String? categoryId, String reason) => _dataSource.createGroundTruth(assessmentId, judgment, categoryId, reason);
}
