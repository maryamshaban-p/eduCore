import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/moderator_model.dart';
import '../data/moderators_repo.dart';
import '../../teachers/data/teacher_model.dart';

part 'moderators_state.dart';

class ModeratorsCubit extends Cubit<ModeratorsState> {
  final ModeratorsRepository _repo;

  ModeratorsCubit(this._repo) : super(ModeratorsInitial());

  Future<void> loadModerators() async {
    emit(ModeratorsLoading());
    try {
      final moderators = await _repo.getModerators();
      final teachers   = await _repo.getTeachers();
      emit(ModeratorsLoaded(moderators: moderators, availableTeachers: teachers));
    } catch (e) {
      emit(ModeratorsError('Failed to load: $e'));
    }
  }

  void openAdd() => _requireLoaded((s) =>
      emit(s.copyWith(panelOpen: true, clearSelected: true)));

  void openEdit(ModeratorModel moderator) => _requireLoaded((s) =>
      emit(s.copyWith(panelOpen: true, selectedModerator: moderator)));

  void closePanel() => _requireLoaded((s) =>
      emit(s.copyWith(panelOpen: false, clearSelected: true)));

  Future<void> addModerator({
    required String firstname,
    required String lastname,
    required String email,
    required String password,
    required List<String> assignedTeacherIds,
  }) async {
    _requireLoaded((s) async {
      emit(s.copyWith(isSubmitting: true));
      try {
        await _repo.addModerator(
          firstname: firstname,
          lastname: lastname,
          email: email,
          password: password,
          assignedTeacherIds: assignedTeacherIds,
        );
        emit(const ModeratorsSuccess('Moderator added successfully'));
        await loadModerators();
      } catch (e) {
        emit(ModeratorsError('Failed to add: $e'));
        await loadModerators();
      }
    });
  }

  Future<void> updateModerator({
    required String id,
    required String firstname,
    required String lastname,
    required List<String> assignedTeacherIds,
  }) async {
    _requireLoaded((s) async {
      emit(s.copyWith(isSubmitting: true));
      try {
        await _repo.updateModerator(
          id: id,
          firstname: firstname,
          lastname: lastname,
          assignedTeacherIds: assignedTeacherIds,
        );
        emit(const ModeratorsSuccess('Moderator updated successfully'));
        await loadModerators();
      } catch (e) {
        emit(ModeratorsError('Failed to update: $e'));
        await loadModerators();
      }
    });
  }

  Future<void> deleteModerator(String id) async {
    _requireLoaded((s) async {
      emit(s.copyWith(isSubmitting: true));
      try {
        await _repo.deleteModerator(id);
        emit(const ModeratorsSuccess('Moderator deleted successfully'));
        await loadModerators();
      } catch (e) {
        emit(ModeratorsError('Failed to delete: $e'));
        await loadModerators();
      }
    });
  }

  void _requireLoaded(Function(ModeratorsLoaded) action) {
    if (state is ModeratorsLoaded) action(state as ModeratorsLoaded);
  }
}