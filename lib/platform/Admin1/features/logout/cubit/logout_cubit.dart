import 'package:flutter_bloc/flutter_bloc.dart';

part 'logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  LogoutCubit() : super(LogoutInitial());

  Future<void> logout() async {
    emit(LogoutLoading());
    try {
      // TODO: امسح الـ token أو الـ session هنا
      // await SharedPreferences.getInstance().then((p) => p.clear());
      await Future.delayed(const Duration(milliseconds: 300));
      emit(LogoutSuccess());
    } catch (_) {
      emit(const LogoutError('Failed to logout'));
    }
  }
}
