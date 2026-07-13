import '../../domain/models/library_item.dart';
import '../../domain/repositories/training_library_repository.dart';
import '../datasources/training_library_remote_datasource.dart';
import '../mappers/library_item_mapper.dart';

class TrainingLibraryRepositoryImpl implements TrainingLibraryRepository {
  final TrainingLibraryRemoteDataSource remoteDataSource;

  TrainingLibraryRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<LibraryItem>> searchLibraryItems({
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
    final dtos = await remoteDataSource.searchLibraryItems(
      keyword: keyword,
      difficulty: difficulty,
      manipulationType: manipulationType,
      mediaType: mediaType,
      tags: tags,
      publishedAfter: publishedAfter,
      publishedBefore: publishedBefore,
      page: page,
      pageSize: pageSize,
    );
    return dtos.map((dto) => LibraryItemMapper.fromSummaryDto(dto)).toList();
  }

  @override
  Future<LibraryItem> getLibraryItemById(String id) async {
    final dto = await remoteDataSource.getLibraryItemById(id);
    return LibraryItemMapper.fromDetailDto(dto);
  }
}
