
import 'package:edulink_app/platform/landing_page/data/data_sources/admin_data_source.dart';
import 'package:edulink_app/platform/landing_page/data/repos/admin_repo.dart';
import 'package:get_it/get_it.dart';
import '../services/storage_service.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton(() => StorageService());
  getIt.registerLazySingleton(() => AdminDataSource());
  getIt.registerLazySingleton(() => AdminRepo(getIt()));
}