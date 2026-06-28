import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/subject_model.dart';
import '../data/subject_repo.dart';

part 'subject_sessions_state.dart';

class SubjectSessionsCubit extends Cubit<SubjectSessionsState> {
  final SubjectRepository _repo;
  final int courseId;

  SubjectSessionsCubit(this._repo, this.courseId) : super(SubjectSessionsInitial());

  Future<void> loadSessions() async {
    emit(SubjectSessionsLoading());
    try {
      final data = await _repo.getCourseSessions(courseId);
      emit(SubjectSessionsLoaded(data));
    } catch (e) {
      emit(SubjectSessionsError(e.toString().replaceAll('Exception: ', '')));
    }
  }
}