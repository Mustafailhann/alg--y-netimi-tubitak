class StudentSessionStateDto {
  final String sessionId;
  final String joinCode;
  final String status;
  final int? currentQuestionIndex;

  const StudentSessionStateDto({
    required this.sessionId,
    required this.joinCode,
    required this.status,
    this.currentQuestionIndex,
  });

  factory StudentSessionStateDto.fromJson(Map<String, dynamic> json) {
    return StudentSessionStateDto(
      sessionId: json['sessionId'] as String,
      joinCode: json['joinCode'] as String,
      status: json['status'] as String,
      currentQuestionIndex: json['currentQuestionIndex'] as int?,
    );
  }
}

class StudentQuestionDto {
  final String id;
  final String groundTruthId;
  final String title;
  final String fileUrl;
  final String mediaType;
  final int order;

  const StudentQuestionDto({
    required this.id,
    required this.groundTruthId,
    required this.title,
    required this.fileUrl,
    required this.mediaType,
    required this.order,
  });

  factory StudentQuestionDto.fromJson(Map<String, dynamic> json) {
    return StudentQuestionDto(
      id: json['id'] as String,
      groundTruthId: json['groundTruthId'] as String,
      title: json['title'] as String,
      fileUrl: json['fileUrl'] as String,
      mediaType: json['mediaType'] as String,
      order: json['order'] as int,
    );
  }
}

class StudentSessionResultDto {
  final int totalQuestions;
  final int answeredQuestions;
  final int correctCount;
  final int incorrectCount;
  final double averageResponseTimeMs;
  final int score;
  final int progressPercentage;

  const StudentSessionResultDto({
    required this.totalQuestions,
    required this.answeredQuestions,
    required this.correctCount,
    required this.incorrectCount,
    required this.averageResponseTimeMs,
    required this.score,
    required this.progressPercentage,
  });

  factory StudentSessionResultDto.fromJson(Map<String, dynamic> json) {
    return StudentSessionResultDto(
      totalQuestions: json['totalQuestions'] as int,
      answeredQuestions: json['answeredQuestions'] as int,
      correctCount: json['correctCount'] as int,
      incorrectCount: json['incorrectCount'] as int,
      averageResponseTimeMs: (json['averageResponseTimeMs'] as num).toDouble(),
      score: json['score'] as int,
      progressPercentage: json['progressPercentage'] as int,
    );
  }

  double get accuracy => totalQuestions > 0 ? correctCount / totalQuestions : 0.0;
}

class QuestionHistoryDto {
  final String trainingItemId;
  final int orderIndex;
  final int questionNumber;
  final String assessmentId;
  final String? groundTruthId;
  final String mediaUrl;
  final String? submittedJudgment;
  final String? correctJudgment;
  final String? reason;
  final String? manipulationCategoryName;
  final double? classificationScore;
  final double? localizationScore;
  final double? localizationThreshold;
  final bool? passedLocalization;
  final bool? isCorrect;
  final int timeSpentSeconds;

  const QuestionHistoryDto({
    required this.trainingItemId,
    required this.orderIndex,
    required this.questionNumber,
    required this.assessmentId,
    this.groundTruthId,
    required this.mediaUrl,
    this.submittedJudgment,
    this.correctJudgment,
    this.reason,
    this.manipulationCategoryName,
    this.classificationScore,
    this.localizationScore,
    this.localizationThreshold,
    this.passedLocalization,
    this.isCorrect,
    required this.timeSpentSeconds,
  });

  factory QuestionHistoryDto.fromJson(Map<String, dynamic> json) {
    return QuestionHistoryDto(
      trainingItemId: json['trainingItemId'] as String,
      orderIndex: json['orderIndex'] as int,
      questionNumber: json['questionNumber'] as int,
      assessmentId: json['assessmentId'] as String,
      groundTruthId: json['groundTruthId'] as String?,
      mediaUrl: json['mediaUrl'] as String,
      submittedJudgment: json['submittedJudgment'] as String?,
      correctJudgment: json['correctJudgment'] as String?,
      reason: json['reason'] as String?,
      manipulationCategoryName: json['manipulationCategoryName'] as String?,
      classificationScore: json['classificationScore'] != null ? (json['classificationScore'] as num).toDouble() : null,
      localizationScore: json['localizationScore'] != null ? (json['localizationScore'] as num).toDouble() : null,
      localizationThreshold: json['localizationThreshold'] != null ? (json['localizationThreshold'] as num).toDouble() : null,
      passedLocalization: json['passedLocalization'] as bool?,
      isCorrect: json['isCorrect'] as bool?,
      timeSpentSeconds: json['timeSpentSeconds'] as int,
    );
  }
}

class QuestionReviewDto {
  final List<dynamic> teacherAnnotations;
  final List<dynamic> studentAnnotations;
  final double mediaWidth;
  final double mediaHeight;

  const QuestionReviewDto({
    required this.teacherAnnotations,
    required this.studentAnnotations,
    required this.mediaWidth,
    required this.mediaHeight,
  });

  factory QuestionReviewDto.fromJson(Map<String, dynamic> json) {
    return QuestionReviewDto(
      teacherAnnotations: json['teacherAnnotations'] as List<dynamic>? ?? [],
      studentAnnotations: json['studentAnnotations'] as List<dynamic>? ?? [],
      mediaWidth: (json['mediaWidth'] as num?)?.toDouble() ?? 800.0,
      mediaHeight: (json['mediaHeight'] as num?)?.toDouble() ?? 600.0,
    );
  }
}
