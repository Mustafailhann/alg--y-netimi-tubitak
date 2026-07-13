import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../data/annotation_data_source.dart';
import '../data/annotation_repository.dart';
import '../models/annotation_model.dart';

final annotationDataSourceProvider = Provider<AnnotationDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return AnnotationDataSource(dio);
});

final annotationRepositoryProvider = Provider<AnnotationRepository>((ref) {
  return AnnotationRepository(ref.watch(annotationDataSourceProvider));
});

/// Fetches all annotations for a given GroundTruth ID.
final annotationsByGroundTruthProvider =
    FutureProvider.family.autoDispose<List<AnnotationModel>, String>(
        (ref, groundTruthId) {
  return ref.watch(annotationRepositoryProvider).getByGroundTruth(groundTruthId);
});

/// Fetches a single annotation by its ID.
final annotationDetailProvider =
    FutureProvider.family.autoDispose<AnnotationModel, String>((ref, id) {
  return ref.watch(annotationRepositoryProvider).getById(id);
});

/// Fetches active/draft annotations for a Participant in a Training Session.
final participantAnnotationProvider =
    FutureProvider.family.autoDispose<List<AnnotationModel>, String>(
        (ref, sessionId) {
  return ref.watch(annotationRepositoryProvider).getBySessionParticipant(sessionId);
});
