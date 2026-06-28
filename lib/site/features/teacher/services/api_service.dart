/*import 'package:dio/dio.dart';
import 'package:edulink_app/core/errors/api_exception.dart';

class ApiService {
  static const String _baseUrl = 'http://localhost:5132/api';

  // ⚠️ Temporary for testing — will be replaced by auth service later
  static const String _token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJiM2Q4YjY5Zi03OGU3LTRjNDMtYTU5Mi02MjJjMmEzMGE1ZWMiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1laWRlbnRpZmllciI6ImIzZDhiNjlmLTc4ZTctNGM0My1hNTkyLTYyMmMyYTMwYTVlYyIsImh0dHA6Ly9zY2hlbWFzLnhtbHNvYXAub3JnL3dzLzIwMDUvMDUvaWRlbnRpdHkvY2xhaW1zL2VtYWlsYWRkcmVzcyI6InNhbG1hQGdtYWlsLmNvbSIsImh0dHA6Ly9zY2hlbWFzLnhtbHNvYXAub3JnL3dzLzIwMDUvMDUvaWRlbnRpdHkvY2xhaW1zL25hbWUiOiJzYWxtYSBtb3N0YWZhIiwiaHR0cDovL3NjaGVtYXMubWljcm9zb2Z0LmNvbS93cy8yMDA4LzA2L2lkZW50aXR5L2NsYWltcy9yb2xlIjoiVGVhY2hlciIsImV4cCI6MTc4MzA1Nzc1NywiaXNzIjoiWW91ckFwcE5hbWUiLCJhdWQiOiJZb3VyQXBwQ2xpZW50In0.v2CypKxxXy7m0OJpZOGSshfFmSF2BhuKM_C5b3bM_qU';

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
      },
    ),
  );

  Future<Response> get(String endpoint, {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.get(endpoint, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (_) {
      throw const ApiException('An unexpected error occurred. Please try again.');
    }
  }

  Future<Response> post(String endpoint, Map<String, dynamic> body, {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.post(endpoint, data: body, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (_) {
      throw const ApiException('An unexpected error occurred. Please try again.');
    }
  }

  /// Multipart POST — used when the request needs to upload one or more
  /// files alongside regular fields (e.g. lessons with HomeworkFile/Files,
  /// subjects with a Picture, or the AI quiz/true-false generation
  /// endpoints which take a `pdf` file plus a `numQuestions` query param).
  ///
  /// IMPORTANT: we do NOT set a 'Content-Type' header manually here.
  /// Dio/http needs to generate it itself as
  /// `multipart/form-data; boundary=<generated-boundary>` based on the
  /// FormData instance. The BaseOptions default of 'application/json' is
  /// only overridden because we pass `contentType: null`-equivalent by
  /// simply not specifying it — Dio detects `data is FormData` and sets
  /// the correct header (with boundary) automatically. If we hardcode
  /// 'multipart/form-data' without a boundary, the server cannot parse
  /// the parts and the request fails or silently drops fields/files.
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
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (_) {
      throw const ApiException('An unexpected error occurred. Please try again.');
    }
  }

  Future<Response> put(String endpoint, Map<String, dynamic> body, {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.put(endpoint, data: body, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (_) {
      throw const ApiException('An unexpected error occurred. Please try again.');
    }
  }

  /// Multipart PUT — same purpose and same reasoning as [postMultipart]
  /// regarding NOT hardcoding the Content-Type header.
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
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (_) {
      throw const ApiException('An unexpected error occurred. Please try again.');
    }
  }

  Future<Response> delete(String endpoint, {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.delete(endpoint, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (_) {
      throw const ApiException('An unexpected error occurred. Please try again.');
    }
  }
}*/