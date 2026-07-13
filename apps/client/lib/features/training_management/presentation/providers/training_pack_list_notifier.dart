import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/training_pack.dart';
import '../../domain/repositories/training_pack_repository.dart';
import 'providers.dart';
import '../../../../core/storage/secure_storage_service.dart';

enum ListLoadingState {
  initial,
  refreshing,
  paginating,
  idle,
}

class TrainingPackListState {
  final List<TrainingPack> packs;
  final ListLoadingState loadingState;
  final String? error;
  final bool hasReachedMax;
  final int currentPage;

  TrainingPackListState({
    this.packs = const [],
    this.loadingState = ListLoadingState.initial,
    this.error,
    this.hasReachedMax = false,
    this.currentPage = 1,
  });

  TrainingPackListState copyWith({
    List<TrainingPack>? packs,
    ListLoadingState? loadingState,
    String? error,
    bool? hasReachedMax,
    int? currentPage,
  }) {
    return TrainingPackListState(
      packs: packs ?? this.packs,
      loadingState: loadingState ?? this.loadingState,
      error: error,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

class TrainingPackListNotifier extends StateNotifier<TrainingPackListState> {
  final TrainingPackRepository _repository;
  final SecureStorageService _secureStorageService;

  TrainingPackListNotifier(this._repository, this._secureStorageService) : super(TrainingPackListState()) {
    loadInitial();
  }

  Future<void> loadInitial() async {
    state = state.copyWith(loadingState: ListLoadingState.initial, error: null);
    await _fetchData(page: 1);
  }

  Future<void> refresh() async {
    state = state.copyWith(loadingState: ListLoadingState.refreshing, error: null);
    await _fetchData(page: 1);
  }

  Future<void> loadNextPage() async {
    if (state.loadingState == ListLoadingState.paginating || state.hasReachedMax) return;
    state = state.copyWith(loadingState: ListLoadingState.paginating, error: null);
    await _fetchData(page: state.currentPage + 1, append: true);
  }

  Future<void> _fetchData({required int page, bool append = false}) async {
    try {
      final teacherId = await _secureStorageService.getUserId() ?? "00000000-0000-0000-0000-000000000000"; // Fallback for now
      final items = await _repository.getMyPacks(
        teacherId,
        page: page,
        pageSize: 20,
      );

      state = state.copyWith(
        packs: append ? [...state.packs, ...items] : items,
        currentPage: page,
        hasReachedMax: items.length < 20,
        loadingState: ListLoadingState.idle,
      );
    } catch (e) {
      state = state.copyWith(loadingState: ListLoadingState.idle, error: e.toString());
    }
  }
}

final trainingPackListNotifierProvider = StateNotifierProvider.autoDispose<TrainingPackListNotifier, TrainingPackListState>((ref) {
  return TrainingPackListNotifier(
    ref.watch(trainingPackRepositoryProvider),
    ref.watch(secureStorageServiceProvider),
  );
});
