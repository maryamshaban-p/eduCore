part of 'admin_cubit.dart';


abstract class AdminState {}

class AdminInitial extends AdminState {}

class AdminLoading extends AdminState {}

class AdminLoginSuccess extends AdminState {
  final AdminModel admin;
  AdminLoginSuccess(this.admin);
}
class AdminError extends AdminState {
  final String message;
  AdminError(this.message);
}
