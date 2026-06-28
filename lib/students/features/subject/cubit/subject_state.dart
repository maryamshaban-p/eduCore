part of 'subject_cubit.dart';

abstract class SubjectState {
  const SubjectState();
}

class SubjectInitial extends SubjectState {}

class SubjectLoading extends SubjectState {}

class SubjectLoaded extends SubjectState {
  final List<SubjectModel> subjects;
  const SubjectLoaded(this.subjects);
}

class SubjectError extends SubjectState {
  final String message;
  const SubjectError(this.message);
}