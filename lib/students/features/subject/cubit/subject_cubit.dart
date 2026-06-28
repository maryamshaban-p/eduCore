import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/subject_model.dart';
import '../data/subject_repo.dart';

part 'subject_state.dart';

class SubjectCubit extends Cubit<SubjectState> {
  final SubjectRepository _repo;

  SubjectCubit(this._repo) : super(SubjectInitial());

  Future<void> loadSubjects() async {
    emit(SubjectLoading());
    try {
      final subjects = await _repo.getMySubjects();
      emit(SubjectLoaded(subjects));
    } catch (e) {
      emit(SubjectError(e.toString().replaceAll('Exception: ', '')));
    }
  }
}