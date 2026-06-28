part of 'student_login_cubit.dart';

abstract class StudentLoginState {
  const StudentLoginState();
}

class StudentLoginInitial extends StudentLoginState {}

class StudentLoginLoading extends StudentLoginState {}

class StudentLoginSuccess extends StudentLoginState {
  final StudentAuthModel student;
  const StudentLoginSuccess(this.student);
}

class StudentLoginError extends StudentLoginState {
  final String message;
  const StudentLoginError(this.message);
}