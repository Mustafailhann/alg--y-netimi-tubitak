import '../models/library_item.dart';

abstract class TrainingLibraryRepository {
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
  });

  Future<LibraryItem> getLibraryItemById(String id);
}
