import 'package:dio/dio.dart';
import 'package:edulink_app/core/errors/api_exception.dart';
import 'user_session.dart';

/// Shared HTTP client for all feature services.
///
/// The bearer token is NOT baked in at construction time — it is
/// read from [UserSession.instance] on every request so it is always
/// current, whether the user just logged in or refreshed their token.
class ApiService {
  static const String _baseUrl = 'http://localhost:5132/api';

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      headers: {'Content-Type': 'application/json'},
    ),
  );

  /// Adds `Authorization: Bearer <token>` from the active session.
  /// Throws [ApiException] if the user is not authenticated.
  Map<String, dynamic> get _authHeaders {
    final token = UserSession.token;
    if (token == null || token.isEmpty) {
      throw const ApiException('Not authenticated. Please log in.');
    }
    return {'Authorization': 'Bearer $token'};
  }

  Future<Response> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: Options(headers: _authHeaders),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw const ApiException('An unexpected error occurred. Please try again.');
    }
  }

  Future<Response> post(
    String endpoint,
    Map<String, dynamic> body, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.post(
        endpoint,
        data: body,
        queryParameters: queryParameters,
        options: Options(headers: _authHeaders),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw const ApiException('An unexpected error occurred. Please try again.');
    }
  }

  Future<Response> postMultipart(
    String endpoint,
    FormData formData, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.post(
        endpoint,
        data: formData,
        queryParameters: queryParameters,
        options: Options(headers: _authHeaders),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw const ApiException('An unexpected error occurred. Please try again.');
    }
  }

  Future<Response> put(
    String endpoint,
    Map<String, dynamic> body, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.put(
        endpoint,
        data: body,
        queryParameters: queryParameters,
        options: Options(headers: _authHeaders),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw const ApiException('An unexpected error occurred. Please try again.');
    }
  }

  Future<Response> putMultipart(
    String endpoint,
    FormData formData, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.put(
        endpoint,
        data: formData,
        queryParameters: queryParameters,
        options: Options(headers: _authHeaders),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw const ApiException('An unexpected error occurred. Please try again.');
    }
  }

  Future<Response> delete(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.delete(
        endpoint,
        queryParameters: queryParameters,
        options: Options(headers: _authHeaders),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw const ApiException('An unexpected error occurred. Please try again.');
    }
  }
}