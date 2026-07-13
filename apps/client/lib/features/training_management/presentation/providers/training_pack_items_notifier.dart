import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/training_item.dart';
import '../../domain/repositories/training_pack_repository.dart';
import 'providers.dart';
import '../../../../core/storage/secure_storage_service.dart';

enum ItemsLoadingState {
  initial,
  loading,
  submitting,
  idle,
}

class TrainingPackItemsState {
  final List<TrainingItem> items;
  final ItemsLoadingState loadingState;
  final String? error;

  TrainingPackItemsState({
    this.items = const [],
    this.loadingState = ItemsLoadingState.initial,
    this.error,
  });

  TrainingPackItemsState copyWith({
    List<TrainingItem>? items,
    ItemsLoadingState? loadingState,
    String? error,
  }) {
    return TrainingPackItemsState(
      items: items ?? this.items,
      loadingState: loadingState ?? this.loadingState,
      error: error,
    );
  }
}

class TrainingPackItemsNotifier extends StateNotifier<TrainingPackItemsState> {
  final TrainingPackRepository _repository;
  final SecureStorageService _secureStorageService;

  TrainingPackItemsNotifier(this._repository, this._secureStorageService) : super(TrainingPackItemsState());

  Future<void> loadItems(String packId) async {
    state = state.copyWith(loadingState: ItemsLoadingState.loading, error: null);
    try {
      final teacherId = await _secureStorageService.getUserId() ?? "";
      final items = await _repository.getPackItems(packId, teacherId);
      state = state.copyWith(items: items, loadingState: ItemsLoadingState.idle);
    } catch (e) {
      state = state.copyWith(loadingState: ItemsLoadingState.idle, error: e.toString());
    }
  }

  Future<void> addItem(String packId, String libraryItemId, String packVersion) async {
    state = state.copyWith(loadingState: ItemsLoadingState.submitting, error: null);
    try {
      final teacherId = await _secureStorageService.getUserId() ?? "";
      final orderIndex = state.items.length;
      await _repository.addItem(packId, teacherId, libraryItemId, orderIndex, packVersion);
      await loadItems(packId);
    } catch (e) {
      state = state.copyWith(loadingState: ItemsLoadingState.idle, error: e.toString());
    }
  }

  Future<void> removeItem(String packId, String itemId, String packVersion) async {
    state = state.copyWith(loadingState: ItemsLoadingState.submitting, error: null);
    try {
      final teacherId = await _secureStorageService.getUserId() ?? "";
      await _repository.removeItem(packId, teacherId, itemId, packVersion);
      await loadItems(packId);
    } catch (e) {
      state = state.copyWith(loadingState: ItemsLoadingState.idle, error: e.toString());
    }
  }

  Future<void> reorderItems(String packId, int oldIndex, int newIndex, String packVersion) async {
    if (oldIndex < newIndex) newIndex -= 1;
    final items = List<TrainingItem>.from(state.items);
    final item = items.removeAt(oldIndex);
    items.insert(newIndex, item);
    
    // Optimistic UI update
    state = state.copyWith(items: items, loadingState: ItemsLoadingState.submitting, error: null);
    
    try {
      final teacherId = await _secureStorageService.getUserId() ?? "";
      final orderedIds = items.map((i) => i.id).toList();
      await _repository.reorderItems(packId, teacherId, orderedIds, packVersion);
      await loadItems(packId);
    } catch (e) {
      // Revert on error by reloading
      await loadItems(packId);
      state = state.copyWith(loadingState: ItemsLoadingState.idle, error: e.toString());
    }
  }
}

// Note: Using family to keep track of items per packId if needed, but standard is single active pack editor
final trainingPackItemsNotifierProvider = StateNotifierProvider.autoDispose<TrainingPackItemsNotifier, TrainingPackItemsState>((ref) {
  return TrainingPackItemsNotifier(
    ref.watch(trainingPackRepositoryProvider),
    ref.watch(secureStorageServiceProvider),
  );
});
