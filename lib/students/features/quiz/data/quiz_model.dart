class QuizModel {
  final int quizId;
  final String title;
  final double passingScore;
  final int retakeIntervalHours;
  final bool alreadyPassed;
  final double? lastScore;
  final DateTime? canRetakeAt;
  final List<QuizQuestion> questions;
  final List<QuizBreakdownItem>? lastBreakdown;

  QuizModel({
    required this.quizId,
    required this.title,
    required this.passingScore,
    required this.retakeIntervalHours,
    required this.alreadyPassed,
    this.lastScore,
    this.canRetakeAt,
    required this.questions,
    this.lastBreakdown,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      quizId: json['quizId'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      passingScore: (json['passingScore'] as num?)?.toDouble() ?? 50,
      retakeIntervalHours: json['retakeIntervalHours'] as int? ?? 0,
      alreadyPassed: json['alreadyPassed'] as bool? ?? false,
      lastScore: (json['lastScore'] as num?)?.toDouble(),
      canRetakeAt: json['canRetakeAt'] != null
          ? DateTime.tryParse(json['canRetakeAt'] as String)
          : null,
      questions: (json['questions'] as List? ?? [])
          .map((e) => QuizQuestion.fromJson(e as Map<String, dynamic>))
          .toList(),
      // Optional: only present once the backend includes the previous
      // successful attempt's breakdown in the getQuiz response.
      lastBreakdown: json['lastBreakdown'] != null
          ? (json['lastBreakdown'] as List)
              .map((e) => QuizBreakdownItem.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
    );
  }
}

class QuizQuestion {
  final int questionId;
  final String text;
  final List<QuizOption> options;

  QuizQuestion({
    required this.questionId,
    required this.text,
    required this.options,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      questionId: json['questionId'] as int? ?? 0,
      text: json['text'] as String? ?? '',
      options: (json['options'] as List? ?? [])
          .map((e) => QuizOption.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class QuizOption {
  final int optionId;
  final String text;

  QuizOption({required this.optionId, required this.text});

  factory QuizOption.fromJson(Map<String, dynamic> json) {
    return QuizOption(
      optionId: json['optionId'] as int? ?? 0,
      text: json['text'] as String? ?? '',
    );
  }
}

class QuizResultModel {
  final int score;
  final int totalQuestions;
  final double percentage;
  final bool passed;
  final List<QuizBreakdownItem> breakdown;

  QuizResultModel({
    required this.score,
    required this.totalQuestions,
    required this.percentage,
    required this.passed,
    required this.breakdown,
  });

  factory QuizResultModel.fromJson(Map<String, dynamic> json) {
    return QuizResultModel(
      score: json['score'] as int? ?? 0,
      totalQuestions: json['totalQuestions'] as int? ?? 0,
      percentage: (json['percentage'] as num?)?.toDouble() ?? 0,
      passed: json['passed'] as bool? ?? false,
      breakdown: (json['breakdown'] as List? ?? [])
          .map((e) => QuizBreakdownItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class QuizBreakdownItem {
  final int questionId;
  final int? selectedOptionId;
  final int? correctOptionId;
  final bool isCorrect;

  QuizBreakdownItem({
    required this.questionId,
    this.selectedOptionId,
    this.correctOptionId,
    required this.isCorrect,
  });

  factory QuizBreakdownItem.fromJson(Map<String, dynamic> json) {
    return QuizBreakdownItem(
      questionId: json['questionId'] as int? ?? 0,
      selectedOptionId: json['selectedOptionId'] as int?,
      correctOptionId: json['correctOptionId'] as int?,
      isCorrect: json['isCorrect'] as bool? ?? false,
    );
  }
}