import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/quiz_model.dart';
import '../data/quiz_repo.dart';

part 'quiz_state.dart';

class QuizCubit extends Cubit<QuizState> {
  final QuizRepository _repo;
  final int sessionId;

  QuizCubit(this._repo, this.sessionId) : super(QuizInitial());

  Future<void> loadQuiz() async {
    emit(QuizLoading());
    try {
      final quiz = await _repo.getQuiz(sessionId);
      emit(QuizLoaded(
        quiz: quiz,
        currentIndex: 0,
        answers: {},
      ));
    } catch (e) {
      emit(QuizError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  void selectAnswer(int questionId, int optionId) {
    final current = state;
    if (current is! QuizLoaded) return;
    final newAnswers = Map<int, int>.from(current.answers);
    newAnswers[questionId] = optionId;
    emit(current.copyWith(answers: newAnswers));
  }

  void nextQuestion() {
    final current = state;
    if (current is! QuizLoaded) return;
    if (current.currentIndex < current.quiz.questions.length - 1) {
      emit(current.copyWith(currentIndex: current.currentIndex + 1));
    }
  }

  void previousQuestion() {
    final current = state;
    if (current is! QuizLoaded) return;
    if (current.currentIndex > 0) {
      emit(current.copyWith(currentIndex: current.currentIndex - 1));
    }
  }

  Future<void> submitQuiz() async {
    final current = state;
    if (current is! QuizLoaded) return;
    emit(QuizSubmitting(quiz: current.quiz, answers: current.answers));
    try {
      final result = await _repo.submitQuiz(sessionId, current.answers);
      emit(QuizSubmitted(quiz: current.quiz, result: result));
    } catch (e) {
      emit(QuizError(e.toString().replaceAll('Exception: ', '')));
    }
  }
}