import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/student_auth_model.dart';
import '../data/student_auth_repo.dart';
import 'package:edulink_app/platform/Admin1/core/services/storage_service.dart';
part 'student_login_state.dart';

class StudentLoginCubit extends Cubit<StudentLoginState> {
  final StudentAuthRepository _repo;
  final StorageService _storage = StorageService();

  StudentLoginCubit(this._repo) : super(StudentLoginInitial());

  Future<void> login(String username, String password) async {
    emit(StudentLoginLoading());
    try {
      final student = await _repo.login(username, password);
      await _storage.saveToken(student.token);
      emit(StudentLoginSuccess(student));
    } catch (e) {
      emit(StudentLoginError(e.toString().replaceAll('Exception: ', '')));
    }
  }
}