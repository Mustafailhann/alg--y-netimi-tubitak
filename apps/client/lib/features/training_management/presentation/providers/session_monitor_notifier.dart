import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/training_session.dart';
import '../../domain/models/participant.dart';
import '../../domain/repositories/training_session_repository.dart';
import 'providers.dart';
import '../../../../core/storage/secure_storage_service.dart';

enum MonitorLoadingState {
  initial,
  refreshing,
  idle,
}

class SessionMonitorState {
  final TrainingSession? session;
  final List<Participant> participants;
  final MonitorLoadingState loadingState;
  final String? error;

  SessionMonitorState({
    this.session,
    this.participants = const [],
    this.loadingState = MonitorLoadingState.initial,
    this.error,
  });

  SessionMonitorState copyWith({
    TrainingSession? session,
    List<Participant>? participants,
    MonitorLoadingState? loadingState,
    String? error,
  }) {
    return SessionMonitorState(
      session: session ?? this.session,
      participants: participants ?? this.participants,
      loadingState: loadingState ?? this.loadingState,
      error: error,
    );
  }
}

class SessionMonitorNotifier extends StateNotifier<SessionMonitorState> {
  final TrainingSessionRepository _repository;
  final SecureStorageService _secureStorageService;
  Timer? _pollingTimer;

  SessionMonitorNotifier(this._repository, this._secureStorageService) : super(SessionMonitorState());

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  Future<void> loadSession(String sessionId) async {
    state = state.copyWith(loadingState: MonitorLoadingState.initial, error: null);
    try {
      final teacherId = await _secureStorageService.getUserId() ?? "";
      final session = await _repository.getById(sessionId, teacherId);
      final participants = await _repository.getParticipants(sessionId, teacherId);
      state = state.copyWith(
        session: session,
        participants: participants,
        loadingState: MonitorLoadingState.idle,
      );
      
      _startPolling(sessionId, teacherId);
    } catch (e) {
      state = state.copyWith(loadingState: MonitorLoadingState.idle, error: e.toString());
    }
  }

  void _startPolling(String sessionId, String teacherId) {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      // Don't change loading state during background polling to avoid UI jitter
      try {
        final participants = await _repository.getParticipants(sessionId, teacherId);
        final session = await _repository.getById(sessionId, teacherId);
        
        if (mounted) {
          state = state.copyWith(
            participants: participants,
            session: session,
            error: null,
          );
        }
      } catch (e) {
        if (mounted) {
          state = state.copyWith(error: 'Polling error: ${e.toString()}');
        }
      }
    });
  }

  Future<void> startSession() async {
    if (state.session == null) return;
    try {
      final teacherId = await _secureStorageService.getUserId() ?? "";
      await _repository.startSession(state.session!.id, teacherId, state.session!.version);
      await loadSession(state.session!.id);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> completeSession() async {
    if (state.session == null) return;
    try {
      final teacherId = await _secureStorageService.getUserId() ?? "";
      await _repository.completeSession(state.session!.id, teacherId, state.session!.version);
      _pollingTimer?.cancel();
      await loadSession(state.session!.id);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> cancelSession() async {
    if (state.session == null) return;
    try {
      final teacherId = await _secureStorageService.getUserId() ?? "";
      await _repository.cancelSession(state.session!.id, teacherId, state.session!.version);
      _pollingTimer?.cancel();
      await loadSession(state.session!.id);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> nextQuestion() async {
    if (state.session == null) return;
    try {
      final teacherId = await _secureStorageService.getUserId() ?? "";
      await _repository.nextQuestion(state.session!.id, teacherId);
      await loadSession(state.session!.id);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}

final sessionMonitorNotifierProvider = StateNotifierProvider.autoDispose<SessionMonitorNotifier, SessionMonitorState>((ref) {
  return SessionMonitorNotifier(
    ref.watch(trainingSessionRepositoryProvider),
    ref.watch(secureStorageServiceProvider),
  );
});
