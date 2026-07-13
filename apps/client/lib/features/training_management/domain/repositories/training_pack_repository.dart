import '../models/training_pack.dart';
import '../models/training_item.dart';

abstract class TrainingPackRepository {
  Future<List<TrainingPack>> getMyPacks(String teacherId, {
    int? page,
    int? pageSize,
    String? sortField,
    String? sortOrder,
    String? statusFilter,
  });
  Future<TrainingPack> getById(String packId, String teacherId);
  Future<List<TrainingItem>> getPackItems(String packId, String teacherId);
  Future<String> createPack(String teacherId, String title, int? estimatedDuration);
  Future<void> updatePack(String packId, String teacherId, String title, int? estimatedDuration, String version);
  Future<void> archivePack(String packId, String teacherId, String version);
  Future<void> publishPack(String packId, String teacherId, String version);
  Future<String> addItem(String packId, String teacherId, String libraryItemId, int orderIndex, String version);
  Future<void> removeItem(String packId, String teacherId, String itemId, String version);
  Future<void> reorderItems(String packId, String teacherId, List<String> orderedItemIds, String version);
}
