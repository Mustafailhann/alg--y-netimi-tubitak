import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../data/admin_data_source.dart';
import '../data/admin_repository.dart';
import '../models/category_model.dart';
import '../models/media_model.dart';
import '../models/assessment_model.dart';

final adminDataSourceProvider = Provider<AdminDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return AdminDataSource(dio);
});

final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  return AdminRepository(ref.watch(adminDataSourceProvider));
});

final categoriesProvider = FutureProvider.autoDispose<List<CategoryModel>>((ref) {
  return ref.watch(adminRepositoryProvider).getCategories();
});

final mediaProvider = FutureProvider.autoDispose<List<MediaModel>>((ref) {
  return ref.watch(adminRepositoryProvider).getMedia();
});

final assessmentsProvider = FutureProvider.autoDispose<List<AssessmentListModel>>((ref) {
  return ref.watch(adminRepositoryProvider).getAssessments();
});

final assessmentDetailProvider = FutureProvider.family.autoDispose<AssessmentDetailModel, String>((ref, id) {
  return ref.watch(adminRepositoryProvider).getAssessmentById(id);
});
