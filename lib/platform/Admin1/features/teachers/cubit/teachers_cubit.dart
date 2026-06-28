import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/teacher_model.dart';
import '../data/teachers_repo.dart';

part 'teachers_state.dart';

class TeachersCubit extends Cubit<TeachersState> {
  final TeachersRepository _repo;
  List<TeacherModel> _teachers = [];

  TeachersCubit(this._repo) : super(TeachersInitial());

  Future<void> loadTeachers() async {
    emit(TeachersLoading());
    try {
      _teachers = await _repo.getTeachers();
      emit(TeachersLoaded(teachers: _teachers));
    } catch (e) {
      emit(TeachersError('Failed to load teachers: $e'));
    }
  }

  void openAdd() => _requireLoaded((s) =>
      emit(s.copyWith(panelOpen: true, clearSelected: true)));

  void openEdit(TeacherModel teacher) => _requireLoaded((s) =>
      emit(s.copyWith(panelOpen: true, selectedTeacher: teacher)));

  void closePanel() => _requireLoaded((s) =>
      emit(s.copyWith(panelOpen: false, clearSelected: true)));

  Future<void> addTeacher({
    required String firstname,
    required String lastname,
    required String email,
    required String password,
    required String passwordConfirm,
    required String subject,
  }) async {
    _requireLoaded((s) async {
      emit(s.copyWith(isSubmitting: true));
      try {
        await _repo.addTeacher(
          firstname: firstname,
          lastname: lastname,
          email: email,
          password: password,
          passwordConfirm: passwordConfirm,
          subject: subject,
        );
        emit(const TeachersSuccess('Teacher added successfully'));
        await loadTeachers();
      } catch (e) {
        emit(TeachersError('Failed to add teacher: $e'));
        await loadTeachers();
      }
    });
  }

  Future<void> updateTeacher({
    required String teacherId,
    required String firstname,
    required String lastname,
    required String email,
    required String subject,
  }) async {
    _requireLoaded((s) async {
      emit(s.copyWith(isSubmitting: true));
      try {
        await _repo.updateTeacher(
          teacherId: teacherId,
          firstname: firstname,
          lastname: lastname,
          email: email,
          subject: subject,
        );
        emit(const TeachersSuccess('Teacher updated successfully'));
        await loadTeachers();
      } catch (e) {
        emit(TeachersError('Failed to update teacher: $e'));
        await loadTeachers();
      }
    });
  }

  Future<void> deleteTeacher(String teacherId) async {
    _requireLoaded((s) async {
      emit(s.copyWith(isSubmitting: true));
      try {
        await _repo.deleteTeacher(teacherId);
        emit(const TeachersSuccess('Teacher deleted successfully'));
        await loadTeachers();
      } catch (e) {
        emit(TeachersError('Failed to delete teacher: $e'));
        await loadTeachers();
      }
    });
  }

  void _requireLoaded(Function(TeachersLoaded) action) {
    if (state is TeachersLoaded) action(state as TeachersLoaded);
  }
}