import 'package:dio/dio.dart';
import '../models/category_model.dart';
import '../models/media_model.dart';
import '../models/assessment_model.dart';

class AdminDataSource {
  final Dio _dio;

  AdminDataSource(this._dio);

  // Category
  Future<List<CategoryModel>> getCategories() async {
    final response = await _dio.get('/categories');
    return (response.data as List).map((x) => CategoryModel.fromJson(x)).toList();
  }

  Future<CategoryModel> createCategory(String name, String desc) async {
    final response = await _dio.post('/categories', data: {'name': name, 'description': desc});
    return CategoryModel.fromJson(response.data);
  }

  Future<void> deleteCategory(String id) async {
    await _dio.delete('/categories/$id');
  }

  // Media
  Future<List<MediaModel>> getMedia() async {
    final response = await _dio.get('/media');
    return (response.data as List).map((x) => MediaModel.fromJson(x)).toList();
  }

  Future<MediaModel> uploadMedia(String filePath, {List<int>? bytes, String? filename, ProgressCallback? onSendProgress}) async {
    MultipartFile file;
    if (bytes != null && filename != null) {
      file = MultipartFile.fromBytes(bytes, filename: filename);
    } else {
      file = await MultipartFile.fromFile(filePath);
    }
    
    final formData = FormData.fromMap({
      'file': file,
    });
    final response = await _dio.post(
      '/media/upload', 
      data: formData,
      onSendProgress: onSendProgress,
    );
    return MediaModel.fromJson(response.data);
  }

  Future<void> deleteMedia(String id) async {
    await _dio.delete('/media/$id');
  }

  Future<MediaModel> reprocessMedia(String id) async {
    final response = await _dio.post('/media/$id/reprocess');
    return MediaModel.fromJson(response.data);
  }

  // Assessment
  Future<List<AssessmentListModel>> getAssessments() async {
    final response = await _dio.get('/assessments');
    return (response.data as List).map((x) => AssessmentListModel.fromJson(x)).toList();
  }

  Future<AssessmentDetailModel> getAssessmentById(String id) async {
    final response = await _dio.get('/assessments/$id');
    return AssessmentDetailModel.fromJson(response.data);
  }

  Future<AssessmentDetailModel> createAssessment(String mediaId, String question) async {
    final response = await _dio.post('/assessments', data: {'mediaId': mediaId, 'question': question});
    return AssessmentDetailModel.fromJson(response.data);
  }

  Future<void> archiveAssessment(String id) async {
    await _dio.put('/assessments/$id/archive');
  }

  Future<void> markAssessmentReady(String id) async {
    await _dio.put('/assessments/$id/ready');
  }

  Future<void> publishAssessment(String id) async {
    await _dio.put('/assessments/$id/publish');
  }

  // Ground Truth
  Future<GroundTruthModel> createGroundTruth(String assessmentId, int judgment, String? categoryId, String reason) async {
    final response = await _dio.post('/assessments/$assessmentId/groundtruth', data: {
      'judgment': judgment,
      'manipulationCategoryId': categoryId,
      'reason': reason
    });
    return GroundTruthModel.fromJson(response.data);
  }
}
