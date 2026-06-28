part of 'subject_sessions_cubit.dart';

abstract class SubjectSessionsState {
  const SubjectSessionsState();
}

class SubjectSessionsInitial extends SubjectSessionsState {}

class SubjectSessionsLoading extends SubjectSessionsState {}

class SubjectSessionsLoaded extends SubjectSessionsState {
  final SubjectSessionsModel data;
  const SubjectSessionsLoaded(this.data);
}

class SubjectSessionsError extends SubjectSessionsState {
  final String message;
  const SubjectSessionsError(this.message);
}