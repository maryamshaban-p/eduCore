part of 'quiz_cubit.dart';

abstract class QuizState {
  const QuizState();
}

class QuizInitial extends QuizState {}

class QuizLoading extends QuizState {}

class QuizLoaded extends QuizState {
  final QuizModel quiz;
  final int currentIndex;
  final Map<int, int> answers;

  const QuizLoaded({
    required this.quiz,
    required this.currentIndex,
    required this.answers,
  });

  bool get isLastQuestion => currentIndex == quiz.questions.length - 1;

  QuizLoaded copyWith({
    int? currentIndex,
    Map<int, int>? answers,
  }) {
    return QuizLoaded(
      quiz: quiz,
      currentIndex: currentIndex ?? this.currentIndex,
      answers: answers ?? this.answers,
    );
  }
}

class QuizSubmitting extends QuizState {
  final QuizModel quiz;
  final Map<int, int> answers;
  const QuizSubmitting({required this.quiz, required this.answers});
}

class QuizSubmitted extends QuizState {
  final QuizModel quiz;
  final QuizResultModel result;
  const QuizSubmitted({required this.quiz, required this.result});
}

class QuizError extends QuizState {
  final String message;
  const QuizError(this.message);
}