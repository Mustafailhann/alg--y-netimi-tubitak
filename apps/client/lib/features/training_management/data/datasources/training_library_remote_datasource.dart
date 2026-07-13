import 'package:dio/dio.dart';
import '../models/library_item_dto.dart';

abstract class TrainingLibraryRemoteDataSource {
  Future<List<LibraryItemSummaryDto>> searchLibraryItems({
    String? keyword,
    String? difficulty,
    String? manipulationType,
    String? mediaType,
    List<String>? tags,
    DateTime? publishedAfter,
    DateTime? publishedBefore,
    int? page,
    int? pageSize,
  });

  Future<LibraryItemDetailDto> getLibraryItemById(String id);
}

class TrainingLibraryRemoteDataSourceImpl implements TrainingLibraryRemoteDataSource {
  final Dio dio;

  TrainingLibraryRemoteDataSourceImpl(this.dio);

  @override
  Future<List<LibraryItemSummaryDto>> searchLibraryItems({
    String? keyword,
    String? difficulty,
    String? manipulationType,
    String? mediaType,
    List<String>? tags,
    DateTime? publishedAfter,
    DateTime? publishedBefore,
    int? page,
    int? pageSize,
  }) async {
    final queryParams = <String, dynamic>{};
    if (keyword != null) queryParams['keyword'] = keyword;
    if (difficulty != null) queryParams['difficulty'] = difficulty;
    if (manipulationType != null) queryParams['manipulationType'] = manipulationType;
    if (mediaType != null) queryParams['mediaType'] = mediaType;
    if (tags != null && tags.isNotEmpty) queryParams['tags'] = tags;
    if (publishedAfter != null) queryParams['publishedAfter'] = publishedAfter.toIso8601String();
    if (publishedBefore != null) queryParams['publishedBefore'] = publishedBefore.toIso8601String();
    if (page != null) queryParams['page'] = page;
    if (pageSize != null) queryParams['pageSize'] = pageSize;

    final response = await dio.get('/v1/training-library', queryParameters: queryParams);
    final data = response.data as List;
    return data.map((json) => LibraryItemSummaryDto.fromJson(json)).toList();
  }

  @override
  Future<LibraryItemDetailDto> getLibraryItemById(String id) async {
    final response = await dio.get('/v1/training-library/$id');
    return LibraryItemDetailDto.fromJson(response.data);
  }
}
