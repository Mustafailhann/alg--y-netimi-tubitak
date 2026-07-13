import 'package:dio/dio.dart';
import '../models/training_pack_dto.dart';

abstract class TrainingPackRemoteDataSource {
  Future<List<TrainingPackDto>> getMyPacks(String teacherId, {
    int? page,
    int? pageSize,
    String? sortField,
    String? sortOrder,
    String? statusFilter,
  });
  Future<TrainingPackDetailDto> getById(String packId, String teacherId);
  Future<List<TrainingItemDto>> getPackItems(String packId, String teacherId);
  Future<String> createPack(String teacherId, String title, int? estimatedDuration);
  Future<void> updatePack(String packId, String teacherId, String title, int? estimatedDuration, String version);
  Future<void> archivePack(String packId, String teacherId, String version);
  Future<void> publishPack(String packId, String teacherId, String version);
  Future<String> addItem(String packId, String teacherId, String libraryItemId, int orderIndex, String version);
  Future<void> removeItem(String packId, String teacherId, String itemId, String version);
  Future<void> reorderItems(String packId, String teacherId, List<String> orderedItemIds, String version);
}

class TrainingPackRemoteDataSourceImpl implements TrainingPackRemoteDataSource {
  final Dio dio;

  TrainingPackRemoteDataSourceImpl(this.dio);

  @override
  Future<List<TrainingPackDto>> getMyPacks(String teacherId, {
    int? page,
    int? pageSize,
    String? sortField,
    String? sortOrder,
    String? statusFilter,
  }) async {
    final queryParams = <String, dynamic>{'teacherId': teacherId};
    if (page != null) queryParams['page'] = page;
    if (pageSize != null) queryParams['pageSize'] = pageSize;
    if (sortField != null) queryParams['sortField'] = sortField;
    if (sortOrder != null) queryParams['sortOrder'] = sortOrder;
    if (statusFilter != null) queryParams['statusFilter'] = statusFilter;

    final response = await dio.get('/v1/training-packs', queryParameters: queryParams);
    final data = response.data as List;
    return data.map((json) => TrainingPackDto.fromJson(json)).toList();
  }

  @override
  Future<TrainingPackDetailDto> getById(String packId, String teacherId) async {
    final response = await dio.get('/v1/training-packs/$packId', queryParameters: {'teacherId': teacherId});
    return TrainingPackDetailDto.fromJson(response.data);
  }

  @override
  Future<List<TrainingItemDto>> getPackItems(String packId, String teacherId) async {
    final response = await dio.get('/v1/training-packs/$packId/items', queryParameters: {'teacherId': teacherId});
    final data = response.data as List;
    return data.map((json) => TrainingItemDto.fromJson(json)).toList();
  }

  @override
  Future<String> createPack(String teacherId, String title, int? estimatedDuration) async {
    final response = await dio.post('/v1/training-packs', data: {
      'teacherId': teacherId,
      'title': title,
      'estimatedDuration': estimatedDuration,
    });
    return response.data['id'];
  }

  @override
  Future<void> updatePack(String packId, String teacherId, String title, int? estimatedDuration, String version) async {
    await dio.put('/v1/training-packs/$packId', data: {
      'teacherId': teacherId,
      'title': title,
      'estimatedDuration': estimatedDuration,
      'version': version,
    });
  }

  @override
  Future<void> archivePack(String packId, String teacherId, String version) async {
    await dio.post('/v1/training-packs/$packId/archive', data: {
      'teacherId': teacherId,
      'version': version,
    });
  }

  @override
  Future<void> publishPack(String packId, String teacherId, String version) async {
    await dio.post('/v1/training-packs/$packId/publish', data: {
      'teacherId': teacherId,
      'version': version,
    });
  }

  @override
  Future<String> addItem(String packId, String teacherId, String libraryItemId, int orderIndex, String version) async {
    final response = await dio.post('/v1/training-packs/$packId/items', data: {
      'teacherId': teacherId,
      'libraryItemId': libraryItemId,
      'orderIndex': orderIndex,
      'version': version,
    });
    return response.data['id'];
  }

  @override
  Future<void> removeItem(String packId, String teacherId, String itemId, String version) async {
    // DIO uses data field for DELETE body if configured correctly, but it's simpler to send as query param or generic data
    await dio.delete('/v1/training-packs/$packId/items/$itemId', data: {
      'teacherId': teacherId,
      'version': version,
    });
  }

  @override
  Future<void> reorderItems(String packId, String teacherId, List<String> orderedItemIds, String version) async {
    await dio.post('/v1/training-packs/$packId/items/reorder', data: {
      'teacherId': teacherId,
      'orderedItemIds': orderedItemIds,
      'version': version,
    });
  }
}
