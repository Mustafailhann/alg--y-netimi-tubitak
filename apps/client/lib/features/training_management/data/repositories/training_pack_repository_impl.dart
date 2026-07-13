import '../../domain/models/training_pack.dart';
import '../../domain/models/training_item.dart';
import '../../domain/repositories/training_pack_repository.dart';
import '../datasources/training_pack_remote_datasource.dart';
import '../mappers/training_pack_mapper.dart';

class TrainingPackRepositoryImpl implements TrainingPackRepository {
  final TrainingPackRemoteDataSource remoteDataSource;

  TrainingPackRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<TrainingPack>> getMyPacks(String teacherId, {
    int? page,
    int? pageSize,
    String? sortField,
    String? sortOrder,
    String? statusFilter,
  }) async {
    final dtos = await remoteDataSource.getMyPacks(teacherId,
        page: page,
        pageSize: pageSize,
        sortField: sortField,
        sortOrder: sortOrder,
        statusFilter: statusFilter);
    return dtos.map((dto) => TrainingPackMapper.fromDto(dto)).toList();
  }

  @override
  Future<TrainingPack> getById(String packId, String teacherId) async {
    final dto = await remoteDataSource.getById(packId, teacherId);
    return TrainingPackMapper.fromDetailDto(dto);
  }

  @override
  Future<List<TrainingItem>> getPackItems(String packId, String teacherId) async {
    final dtos = await remoteDataSource.getPackItems(packId, teacherId);
    return dtos.map((dto) => TrainingPackMapper.itemFromDto(dto)).toList();
  }

  @override
  Future<String> createPack(String teacherId, String title, int? estimatedDuration) {
    return remoteDataSource.createPack(teacherId, title, estimatedDuration);
  }

  @override
  Future<void> updatePack(String packId, String teacherId, String title, int? estimatedDuration, String version) {
    return remoteDataSource.updatePack(packId, teacherId, title, estimatedDuration, version);
  }

  @override
  Future<void> archivePack(String packId, String teacherId, String version) {
    return remoteDataSource.archivePack(packId, teacherId, version);
  }

  @override
  Future<void> publishPack(String packId, String teacherId, String version) {
    return remoteDataSource.publishPack(packId, teacherId, version);
  }

  @override
  Future<String> addItem(String packId, String teacherId, String libraryItemId, int orderIndex, String version) {
    return remoteDataSource.addItem(packId, teacherId, libraryItemId, orderIndex, version);
  }

  @override
  Future<void> removeItem(String packId, String teacherId, String itemId, String version) {
    return remoteDataSource.removeItem(packId, teacherId, itemId, version);
  }

  @override
  Future<void> reorderItems(String packId, String teacherId, List<String> orderedItemIds, String version) {
    return remoteDataSource.reorderItems(packId, teacherId, orderedItemIds, version);
  }
}
