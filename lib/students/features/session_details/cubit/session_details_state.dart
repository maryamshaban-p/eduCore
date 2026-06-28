part of 'session_details_cubit.dart';

abstract class SessionDetailsState {
  const SessionDetailsState();
}

class SessionInitial extends SessionDetailsState {}

class SessionLoading extends SessionDetailsState {}

class SessionLoaded extends SessionDetailsState {
  final HomeworkSubmissionModel? homework;
  const SessionLoaded(this.homework);
}

class SessionError extends SessionDetailsState {
  final String message;
  const SessionError(this.message);
}