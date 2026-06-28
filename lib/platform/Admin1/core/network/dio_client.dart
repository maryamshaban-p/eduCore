
import 'package:dio/dio.dart';
import '../services/storage_service.dart';

class DioClient {
  static Dio createDio(StorageService storageService) {
    final dio = Dio(BaseOptions(
      baseUrl: 'http://localhost:5132/api',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await storageService.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          await storageService.deleteToken();
        }
        handler.next(error);
      },
    ));

    return dio;
  }
}