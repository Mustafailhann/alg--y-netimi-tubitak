import '../../data/models/student_dto.dart';

enum StudentSessionPhase {
  idle,
  joining,
  waiting,
  question,
  drawing,
  submitted,
  waitingNext,
  finished,
}

class StudentSessionState {
  final StudentSessionPhase phase;
  final StudentSessionStateDto? sessionData;
  final StudentQuestionDto? currentQuestion;
  final StudentSessionResultDto? results;
  final List<QuestionHistoryDto>? history;
  final bool isLoading;
  final String? error;

  const StudentSessionState({
    this.phase = StudentSessionPhase.idle,
    this.sessionData,
    this.currentQuestion,
    this.results,
    this.history,
    this.isLoading = false,
    this.error,
  });

  StudentSessionState copyWith({
    StudentSessionPhase? phase,
    StudentSessionStateDto? sessionData,
    StudentQuestionDto? currentQuestion,
    StudentSessionResultDto? results,
    List<QuestionHistoryDto>? history,
    bool? isLoading,
    String? error,
  }) {
    return StudentSessionState(
      phase: phase ?? this.phase,
      sessionData: sessionData ?? this.sessionData,
      currentQuestion: currentQuestion ?? this.currentQuestion,
      results: results ?? this.results,
      history: history ?? this.history,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
