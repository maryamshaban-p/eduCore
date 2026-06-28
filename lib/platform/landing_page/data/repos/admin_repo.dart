import 'package:dartz/dartz.dart';
import '../models/admin_model.dart';
import '../data_sources/admin_data_source.dart';

class AdminRepo {
  final AdminDataSource dataSource;
  AdminRepo(this.dataSource);

  Future<Either<String, AdminModel>> login(String email, String password) async {
    try {
      final data = await dataSource.login(email, password);
      return Right(AdminModel.fromJson(data));
    } catch (e) {
      print('REPO ERROR: $e');
      return Left('Something went wrong');
    }
  }

}