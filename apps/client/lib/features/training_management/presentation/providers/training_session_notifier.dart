import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/training_session.dart';
import '../../domain/repositories/training_session_repository.dart';
import 'providers.dart';
import '../../../../core/storage/secure_storage_service.dart';

enum SessionLoadingState {
  initial,
  loading,
  submitting,
  idle,
}

class TrainingSessionState {
  final List<TrainingSession> sessions;
  final TrainingSession? currentSession;
  final SessionLoadingState loadingState;
  final String? error;

  TrainingSessionState({
    this.sessions = const [],
    this.currentSession,
    this.loadingState = SessionLoadingState.initial,
    this.error,
  });

  TrainingSessionState copyWith({
    List<TrainingSession>? sessions,
    TrainingSession? currentSession,
    SessionLoadingState? loadingState,
    String? error,
  }) {
    return TrainingSessionState(
      sessions: sessions ?? this.sessions,
      currentSession: currentSession ?? this.currentSession,
      loadingState: loadingState ?? this.loadingState,
      error: error,
    );
  }
}

class TrainingSessionNotifier extends StateNotifier<TrainingSessionState> {
  final TrainingSessionRepository _repository;
  final SecureStorageService _secureStorageService;

  TrainingSessionNotifier(this._repository, this._secureStorageService) : super(TrainingSessionState()) {
    loadSessions();
  }

  Future<void> loadSessions() async {
    state = state.copyWith(loadingState: SessionLoadingState.loading, error: null);
    try {
      final teacherId = await _secureStorageService.getUserId() ?? "";
      final sessions = await _repository.getMySessions(teacherId);
      state = state.copyWith(sessions: sessions, loadingState: SessionLoadingState.idle);
    } catch (e) {
      state = state.copyWith(loadingState: SessionLoadingState.idle, error: e.toString());
    }
  }

  Future<void> createSession({
    required String packId,
    int? timeLimitMinutes,
    bool randomQuestionOrder = false,
    bool allowRetry = false,
    bool showImmediateFeedback = false,
    bool leaderboardEnabled = false,
    bool canvasRequired = false,
    int? maximumAttempts,
    bool autoAdvance = false,
    String? devStudentNickname,
  }) async {
    state = state.copyWith(loadingState: SessionLoadingState.submitting, error: null);
    try {
      final teacherId = await _secureStorageService.getUserId() ?? "";
      final sessionId = await _repository.createSession(
        teacherId, 
        packId, 
        timeLimitMinutes, 
        randomQuestionOrder, 
        allowRetry, 
        showImmediateFeedback, 
        leaderboardEnabled, 
        canvasRequired, 
        maximumAttempts,
        autoAdvance,
      );
      final newSession = await _repository.getById(sessionId, teacherId);
      state = state.copyWith(
        sessions: [newSession, ...state.sessions],
        currentSession: newSession,
        loadingState: SessionLoadingState.idle
      );
    } catch (e) {
      state = state.copyWith(loadingState: SessionLoadingState.idle, error: e.toString());
    }
  }
}

final trainingSessionNotifierProvider = StateNotifierProvider.autoDispose<TrainingSessionNotifier, TrainingSessionState>((ref) {
  return TrainingSessionNotifier(
    ref.watch(trainingSessionRepositoryProvider),
    ref.watch(secureStorageServiceProvider),
  );
});
