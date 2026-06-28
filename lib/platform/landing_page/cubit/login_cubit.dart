import 'package:edulink_app/core/services/auth_service.dart';
import 'package:edulink_app/platform/landing_page/cubit/admin_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_state.dart';
class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginState());

  final AuthService _auth = AuthService();

  void selectRole(int index) => emit(state.copyWith(selectedRole: index));

  void hoverRole(int index) => emit(state.copyWith(hoveredRole: index));

  void clearHover() => emit(state.copyWith(clearHover: true));

  void togglePassword() =>
      emit(state.copyWith(obscurePassword: !state.obscurePassword));

  Future<void> loginAdmin(
      String email,
      String password,
      BuildContext context,
  ) async {
    await context.read<AdminCubit>().login(email, password);
  }

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    switch (state.selectedRole) {
      case 1:
        await _auth.loginModerator(email: email, password: password);
        break;

      case 2:
        await _auth.loginTeacher(email: email, password: password);
        break;
    }
  }

  Future<void> submit({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    emit(state.copyWith(isLoading: true));

    try {
      if (state.selectedRole == 0) {
        await loginAdmin(email, password, context);
      } else {
        await loginUser(email: email, password: password);
      }

      emit(state.copyWith(
  isLoading: false,
  loginSuccess: true,
  loggedInRole: state.selectedRole == 0 
      ? 'Admin' 
      : state.selectedRole == 1 
          ? 'Moderator' 
          : 'Teacher',
));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }
}