import 'package:edulink_app/students/features/session/data/session_model.dart';
import 'package:edulink_app/students/features/session/data/session_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


part 'session_details_state.dart';

class SessionDetailsCubit extends Cubit<SessionDetailsState> {
  final SessionRepository _repo;
  final int sessionId;

  SessionDetailsCubit(this._repo, this.sessionId) : super(SessionInitial());

  Future<void> loadHomework() async {
    emit(SessionLoading());
    try {
      final homework = await _repo.getHomeworkSubmission(sessionId);
      emit(SessionLoaded(homework as HomeworkSubmissionModel?));
    } catch (e) {
      emit(SessionError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> updateProgress(int progressPercent) async {
    try {
      await _repo.updateLessonProgress(sessionId, progressPercent as double);
    } catch (_) {}
  }
}