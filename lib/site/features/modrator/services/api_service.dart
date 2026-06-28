/*import 'package:dio/dio.dart';
import 'package:edulink_app/core/errors/api_exception.dart';

class ApiService {
  static const String _baseUrl = 'http://localhost:5132/api';

  // ⚠️ Temporary for testing — will be replaced by auth service later
  static const String _token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI0ZGU5YzExOS04OGRiLTQ0NWEtYmRhNS1kMTE2YTM5ZGYyMDUiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1laWRlbnRpZmllciI6IjRkZTljMTE5LTg4ZGItNDQ1YS1iZGE1LWQxMTZhMzlkZjIwNSIsImh0dHA6Ly9zY2hlbWFzLnhtbHNvYXAub3JnL3dzLzIwMDUvMDUvaWRlbnRpdHkvY2xhaW1zL2VtYWlsYWRkcmVzcyI6InNlbGltQGdtYWlsLmNvbSIsImh0dHA6Ly9zY2hlbWFzLnhtbHNvYXAub3JnL3dzLzIwMDUvMDUvaWRlbnRpdHkvY2xhaW1zL25hbWUiOiJzZWxpbSBtb2hhbWVkIiwiaHR0cDovL3NjaGVtYXMubWljcm9zb2Z0LmNvbS93cy8yMDA4LzA2L2lkZW50aXR5L2NsYWltcy9yb2xlIjoiTW9kZXJhdG9yIiwiZXhwIjoxNzgyNjkyNDY0LCJpc3MiOiJZb3VyQXBwTmFtZSIsImF1ZCI6IllvdXJBcHBDbGllbnQifQ.FROCK878KqJAo_7EhH_dvf0-7QmFlDxWhiNtuRy-Qiw';

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
      },
    ),
  );

  Future<Response> get(String endpoint) async {
    try {
      return await _dio.get(endpoint);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (_) {
      throw const ApiException('An unexpected error occurred. Please try again.');
    }
  }

  Future<Response> post(String endpoint, Map<String, dynamic> body) async {
    try {
      return await _dio.post(endpoint, data: body);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (_) {
      throw const ApiException('An unexpected error occurred. Please try again.');
    }
  }

  Future<Response> put(String endpoint, Map<String, dynamic> body) async {
    try {
      return await _dio.put(endpoint, data: body);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (_) {
      throw const ApiException('An unexpected error occurred. Please try again.');
    }
  }

  Future<Response> delete(String endpoint) async {
    try {
      return await _dio.delete(endpoint);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (_) {
      throw const ApiException('An unexpected error occurred. Please try again.');
    }
  }
}*/