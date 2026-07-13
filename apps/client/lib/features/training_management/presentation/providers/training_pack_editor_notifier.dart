import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/training_pack.dart';
import '../../domain/repositories/training_pack_repository.dart';
import 'providers.dart';
import '../../../../core/storage/secure_storage_service.dart';

enum EditorLoadingState {
  initial,
  loading,
  submitting,
  idle,
}

class TrainingPackEditorState {
  final TrainingPack? pack;
  final EditorLoadingState loadingState;
  final String? error;
  final bool isSaved;

  TrainingPackEditorState({
    this.pack,
    this.loadingState = EditorLoadingState.initial,
    this.error,
    this.isSaved = false,
  });

  TrainingPackEditorState copyWith({
    TrainingPack? pack,
    EditorLoadingState? loadingState,
    String? error,
    bool? isSaved,
  }) {
    return TrainingPackEditorState(
      pack: pack ?? this.pack,
      loadingState: loadingState ?? this.loadingState,
      error: error,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}

class TrainingPackEditorNotifier extends StateNotifier<TrainingPackEditorState> {
  final TrainingPackRepository _repository;
  final SecureStorageService _secureStorageService;

  TrainingPackEditorNotifier(this._repository, this._secureStorageService) : super(TrainingPackEditorState());

  Future<void> loadPack(String packId) async {
    state = state.copyWith(loadingState: EditorLoadingState.loading, error: null);
    try {
      final teacherId = await _secureStorageService.getUserId() ?? "";
      final pack = await _repository.getById(packId, teacherId);
      state = state.copyWith(pack: pack, loadingState: EditorLoadingState.idle);
    } catch (e) {
      state = state.copyWith(loadingState: EditorLoadingState.idle, error: e.toString());
    }
  }

  Future<void> savePack(String title, int? estimatedDuration) async {
    state = state.copyWith(loadingState: EditorLoadingState.submitting, error: null, isSaved: false);
    try {
      final teacherId = await _secureStorageService.getUserId() ?? "";
      if (state.pack == null) {
        // Create
        final newId = await _repository.createPack(teacherId, title, estimatedDuration);
        await loadPack(newId);
      } else {
        // Update
        await _repository.updatePack(state.pack!.id, teacherId, title, estimatedDuration, state.pack!.version);
        await loadPack(state.pack!.id);
      }
      state = state.copyWith(isSaved: true, loadingState: EditorLoadingState.idle);
    } catch (e) {
      state = state.copyWith(loadingState: EditorLoadingState.idle, error: e.toString());
    }
  }

  Future<void> publishPack() async {
    if (state.pack == null) return;
    state = state.copyWith(loadingState: EditorLoadingState.submitting, error: null);
    try {
      // Fetch fresh version to prevent concurrency conflict
      await loadPack(state.pack!.id);
      if (state.pack == null) return;

      final teacherId = await _secureStorageService.getUserId() ?? "";
      await _repository.publishPack(state.pack!.id, teacherId, state.pack!.version);
      await loadPack(state.pack!.id);
    } catch (e) {
      state = state.copyWith(loadingState: EditorLoadingState.idle, error: e.toString());
    }
  }
}

final trainingPackEditorNotifierProvider = StateNotifierProvider.autoDispose<TrainingPackEditorNotifier, TrainingPackEditorState>((ref) {
  return TrainingPackEditorNotifier(
    ref.watch(trainingPackRepositoryProvider),
    ref.watch(secureStorageServiceProvider),
  );
});
