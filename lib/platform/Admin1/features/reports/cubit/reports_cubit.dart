import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/reports_models.dart';
import '../data/reports_repo.dart';

part 'reports_state.dart';

class ReportsCubit extends Cubit<ReportsState> {
  final ReportsRepository _repo;

  ReportsCubit(this._repo) : super(ReportsInitial());

  Future<void> loadReports() async {
    emit(ReportsLoading());
    try {
      final result = await _repo.fetchAll();
      emit(ReportsLoaded(
        enrollmentBySubject: result.enrollment,
        studentsPerTeacher:  result.teachers,
      ));
    } catch (e) {
      emit(ReportsError('Failed to load reports: $e'));
    }
  }
}