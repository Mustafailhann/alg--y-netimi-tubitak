import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../data/datasources/training_library_remote_datasource.dart';
import '../../data/datasources/training_pack_remote_datasource.dart';
import '../../data/datasources/training_session_remote_datasource.dart';
import '../../data/repositories/training_library_repository_impl.dart';
import '../../data/repositories/training_pack_repository_impl.dart';
import '../../data/repositories/training_session_repository_impl.dart';
import '../../domain/repositories/training_library_repository.dart';
import '../../domain/repositories/training_pack_repository.dart';
import '../../domain/repositories/training_session_repository.dart';

// Datasources
final trainingLibraryRemoteDataSourceProvider = Provider<TrainingLibraryRemoteDataSource>((ref) {
  return TrainingLibraryRemoteDataSourceImpl(ref.watch(dioProvider));
});

final trainingPackRemoteDataSourceProvider = Provider<TrainingPackRemoteDataSource>((ref) {
  return TrainingPackRemoteDataSourceImpl(ref.watch(dioProvider));
});

final trainingSessionRemoteDataSourceProvider = Provider<TrainingSessionRemoteDataSource>((ref) {
  return TrainingSessionRemoteDataSourceImpl(ref.watch(dioProvider));
});

// Repositories
final trainingLibraryRepositoryProvider = Provider<TrainingLibraryRepository>((ref) {
  return TrainingLibraryRepositoryImpl(ref.watch(trainingLibraryRemoteDataSourceProvider));
});

final trainingPackRepositoryProvider = Provider<TrainingPackRepository>((ref) {
  return TrainingPackRepositoryImpl(ref.watch(trainingPackRemoteDataSourceProvider));
});

final trainingSessionRepositoryProvider = Provider<TrainingSessionRepository>((ref) {
  return TrainingSessionRepositoryImpl(ref.watch(trainingSessionRemoteDataSourceProvider));
});
