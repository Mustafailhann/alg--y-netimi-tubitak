import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/library_item.dart';
import '../../domain/repositories/training_library_repository.dart';
import 'providers.dart';

enum LibraryLoadingState {
  initial,
  refreshing,
  paginating,
  idle,
}

class TrainingLibraryState {
  final List<LibraryItem> items;
  final LibraryLoadingState loadingState;
  final String? error;
  final bool hasReachedMax;
  final int currentPage;
  
  // Filters
  final String? keyword;
  final String? difficulty;
  final String? manipulationType;
  final String? mediaType;

  TrainingLibraryState({
    this.items = const [],
    this.loadingState = LibraryLoadingState.initial,
    this.error,
    this.hasReachedMax = false,
    this.currentPage = 1,
    this.keyword,
    this.difficulty,
    this.manipulationType,
    this.mediaType,
  });

  TrainingLibraryState copyWith({
    List<LibraryItem>? items,
    LibraryLoadingState? loadingState,
    String? error,
    bool? hasReachedMax,
    int? currentPage,
    String? keyword,
    String? difficulty,
    String? manipulationType,
    String? mediaType,
  }) {
    return TrainingLibraryState(
      items: items ?? this.items,
      loadingState: loadingState ?? this.loadingState,
      error: error,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      keyword: keyword ?? this.keyword,
      difficulty: difficulty ?? this.difficulty,
      manipulationType: manipulationType ?? this.manipulationType,
      mediaType: mediaType ?? this.mediaType,
    );
  }
}

class TrainingLibraryNotifier extends StateNotifier<TrainingLibraryState> {
  final TrainingLibraryRepository _repository;

  TrainingLibraryNotifier(this._repository) : super(TrainingLibraryState()) {
    loadInitial();
  }

  Future<void> loadInitial() async {
    state = state.copyWith(loadingState: LibraryLoadingState.initial, error: null);
    await _fetchData(page: 1);
  }

  Future<void> refresh() async {
    state = state.copyWith(loadingState: LibraryLoadingState.refreshing, error: null);
    await _fetchData(page: 1);
  }

  Future<void> loadNextPage() async {
    if (state.loadingState == LibraryLoadingState.paginating || state.hasReachedMax) return;
    
    state = state.copyWith(loadingState: LibraryLoadingState.paginating, error: null);
    await _fetchData(page: state.currentPage + 1, append: true);
  }

  void updateFilters({String? keyword, String? difficulty, String? manipulationType, String? mediaType}) {
    state = state.copyWith(
      keyword: keyword,
      difficulty: difficulty,
      manipulationType: manipulationType,
      mediaType: mediaType,
    );
    loadInitial();
  }

  Future<void> _fetchData({required int page, bool append = false}) async {
    try {
      final items = await _repository.searchLibraryItems(
        keyword: state.keyword,
        difficulty: state.difficulty,
        manipulationType: state.manipulationType,
        mediaType: state.mediaType,
        page: page,
        pageSize: 20,
      );

      state = state.copyWith(
        items: append ? [...state.items, ...items] : items,
        currentPage: page,
        hasReachedMax: items.length < 20,
        loadingState: LibraryLoadingState.idle,
      );
    } catch (e) {
      state = state.copyWith(
        loadingState: LibraryLoadingState.idle,
        error: _parseError(e),
      );
    }
  }

  String _parseError(dynamic e) {
    // Basic network error handling here, can be expanded
    if (e.toString().contains('DioException')) {
      return 'Network Error. Please try again.';
    }
    return e.toString();
  }
}

final trainingLibraryNotifierProvider = StateNotifierProvider.autoDispose<TrainingLibraryNotifier, TrainingLibraryState>((ref) {
  return TrainingLibraryNotifier(ref.watch(trainingLibraryRepositoryProvider));
});
