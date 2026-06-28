part of 'reports_cubit.dart';

abstract class ReportsState {
  const ReportsState();
}

class ReportsInitial extends ReportsState {}

class ReportsLoading extends ReportsState {}

class ReportsLoaded extends ReportsState {
  final List<EnrollmentItem> enrollmentBySubject;
  final List<TeacherShare>   studentsPerTeacher;

  const ReportsLoaded({
    required this.enrollmentBySubject,
    required this.studentsPerTeacher,
  });
}

class ReportsError extends ReportsState {
  final String message;
  const ReportsError(this.message);
}