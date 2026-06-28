import 'package:edulink_app/platform/Admin1/core/services/storage_service.dart';
import 'package:edulink_app/platform/landing_page/data/models/admin_model.dart';
import 'package:edulink_app/platform/landing_page/data/repos/admin_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'admin_state.dart';

class AdminCubit extends Cubit<AdminState> {
  final AdminRepo repo;
  final StorageService storageService;

  AdminCubit(this.repo, this.storageService) : super(AdminInitial());

  Future<void> login(String email, String password) async {
    emit(AdminLoading());
    final result = await repo.login(email, password);
    result.fold(
      (error) => emit(AdminError(error)),
      (admin) async {
        await storageService.saveToken(admin.token);
        emit(AdminLoginSuccess(admin));
      },
    );
  }
 

  Future<void> logout() async {
    await storageService.deleteToken();
    emit(AdminInitial());
  }
}

 