import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers.dart';
import 'student_session_state.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../domain/jwt_decoder.dart';
import '../../domain/participant_token.dart';

class StudentSessionNotifier extends StateNotifier<StudentSessionState> {
  final Ref _ref;
  Timer? _pollingTimer;
  String? _sessionId;
  
  // Track consecutive errors to implement capped retry logic before failing
  int _consecutiveErrors = 0;
  static const int _maxConsecutiveErrors = 3;

  StudentSessionNotifier(this._ref) : super(const StudentSessionState());

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  Future<void> joinSession(String joinCode, String nickname) async {
    state = state.copyWith(isLoading: true, error: null, phase: StudentSessionPhase.joining);
    try {
      final repository = _ref.read(studentSessionRepositoryProvider);
      final token = await repository.joinSession(joinCode, nickname);
      
      _ref.read(currentParticipantTokenProvider.notifier).state = token;
      
      final storage = _ref.read(secureStorageServiceProvider);
      await storage.saveParticipantToken(
        participantId: token.participantId, 
        token: token.token,
      );

      final decoded = JwtDecoder.decode(token.token);
      final sessionId = decoded['SessionId'] as String;
      
      startPolling(sessionId);
    } catch (e) {
      String errorMessage = 'Failed to join session.';
      if (e is DioException) {
        if (e.response?.statusCode == 404) {
          errorMessage = 'Oturum bulunamadı. Kodu kontrol edip tekrar deneyin.';
        } else {
          errorMessage = 'Bağlantı hatası: ${e.message}';
        }
      } else {
        errorMessage = 'Bilinmeyen bir hata oluştu.';
      }
      state = state.copyWith(isLoading: false, error: errorMessage, phase: StudentSessionPhase.idle);
    }
  }

  Future<void> restoreSession() async {
    final storage = _ref.read(secureStorageServiceProvider);
    final savedData = await storage.getParticipantToken();
    if (savedData != null) {
      final token = ParticipantToken(
        participantId: savedData['participantId']!,
        token: savedData['token']!,
      );
      _ref.read(currentParticipantTokenProvider.notifier).state = token;
      
      final decoded = JwtDecoder.decode(token.token);
      final sessionId = decoded['SessionId'] as String;
      
      startPolling(sessionId);
    }
  }

  void startPolling(String sessionId) {
    _sessionId = sessionId;
    _pollingTimer?.cancel();
    _consecutiveErrors = 0;
    
    // Initial fetch immediately
    _pollState();
    
    // Fixed interval 3 seconds
    _pollingTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      _pollState();
    });
  }

  void stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  Future<void> _pollState() async {
    if (_sessionId == null) return;
    final token = _ref.read(currentParticipantTokenProvider);
    if (token == null) {
      stopPolling();
      return;
    }

    try {
      final repository = _ref.read(studentSessionRepositoryProvider);
      final sessionState = await repository.getStudentState(_sessionId!, token.participantId);
      
      _consecutiveErrors = 0;

      // Handle Session Finished
      if (sessionState.status == 'Finished') {
        stopPolling();
        await _fetchResults();
        return;
      }

      // State transitions based on current question
      if (sessionState.status == 'Active' && sessionState.currentQuestionIndex != null) {
        // If we were waiting, or if the question index changed, we should fetch the new question
        if (state.sessionData?.currentQuestionIndex != sessionState.currentQuestionIndex || 
            state.phase == StudentSessionPhase.waiting ||
            state.phase == StudentSessionPhase.waitingNext) {
          
          await _fetchCurrentQuestion();
          state = state.copyWith(
            phase: StudentSessionPhase.question,
            sessionData: sessionState,
            error: null, // Clear error when successfully transitioning
          );
        } else {
          // Just update session data
          state = state.copyWith(sessionData: sessionState);
        }
      } else {
        // Waiting in lobby
        if (state.phase != StudentSessionPhase.waiting) {
          state = state.copyWith(phase: StudentSessionPhase.waiting, sessionData: sessionState, error: null);
        } else {
          state = state.copyWith(sessionData: sessionState, error: null); // Keep error cleared
        }
      }
    } catch (e) {
      _consecutiveErrors++;
      if (_consecutiveErrors >= _maxConsecutiveErrors) {
        stopPolling();
        state = state.copyWith(error: 'Connection lost after multiple retries.');
      }
    }
  }

  Future<void> _fetchCurrentQuestion() async {
    if (_sessionId == null) return;
    try {
      final repository = _ref.read(studentSessionRepositoryProvider);
      final question = await repository.getCurrentQuestion(_sessionId!);
      state = state.copyWith(currentQuestion: question);
    } catch (e) {
      // Error fetching question
      state = state.copyWith(error: 'Failed to fetch question: $e');
    }
  }

  Future<void> _fetchResults() async {
    if (_sessionId == null) return;
    final token = _ref.read(currentParticipantTokenProvider);
    if (token == null) return;

    try {
      state = state.copyWith(isLoading: true, phase: StudentSessionPhase.finished);
      final repository = _ref.read(studentSessionRepositoryProvider);
      
      final results = await repository.getResults(_sessionId!, token.participantId);
      final history = await repository.getQuestionHistory(_sessionId!);
      
      state = state.copyWith(
        isLoading: false,
        results: results,
        history: history,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Failed to load results: $e');
    }
  }

  void selectManipulated() {
    state = state.copyWith(phase: StudentSessionPhase.drawing);
  }

  Future<void> submitAnswer(String judgment, int timeTakenMs, {String? annotationId}) async {
    if (_sessionId == null) return;
    final token = _ref.read(currentParticipantTokenProvider);
    if (token == null) return;

    try {
      state = state.copyWith(isLoading: true);
      final repository = _ref.read(studentSessionRepositoryProvider);
      await repository.submitAnswer(
        sessionId: _sessionId!,
        participantId: token.participantId,
        judgment: judgment,
        timeTakenMilliseconds: timeTakenMs,
        annotationId: annotationId,
      );
      
      state = state.copyWith(
        isLoading: false,
        phase: StudentSessionPhase.submitted, // or waitingNext
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Failed to submit answer: $e');
    }
  }

  Future<void> leaveSession() async {
    stopPolling();
    if (_sessionId != null) {
      final token = _ref.read(currentParticipantTokenProvider);
      if (token != null) {
        try {
          final repository = _ref.read(studentSessionRepositoryProvider);
          await repository.leaveSession(_sessionId!, token.participantId);
        } catch (_) {
          // Ignore errors on leave
        }
      }
    }
    
    // Clear token and reset
    final storage = _ref.read(secureStorageServiceProvider);
    await storage.clearParticipantToken();
    _ref.read(currentParticipantTokenProvider.notifier).state = null;
    state = const StudentSessionState();
  }
}

final studentSessionNotifierProvider = StateNotifierProvider<StudentSessionNotifier, StudentSessionState>((ref) {
  return StudentSessionNotifier(ref);
});
