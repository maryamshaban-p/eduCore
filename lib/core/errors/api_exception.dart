import 'package:dio/dio.dart';

/// Unified exception type for every API call in the app.
///
/// Always carries a short, ready-to-show-to-the-user [message] (English,
/// no technical jargon / no raw Dio text), plus the original [statusCode]
/// and the raw [cause] in case a developer needs to log/debug it.
///
/// `ApiService` is the only place that creates these (via
/// [ApiException.fromDioException]), so every screen/service that calls
/// it can just do:
///
/// ```dart
/// try {
///   await _service.doSomething();
/// } catch (e) {
///   showErrorSnackBar(context, friendlyErrorMessage(e));
/// }
/// ```
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final Object? cause;

  const ApiException(this.message, {this.statusCode, this.cause});

  /// Builds a friendly [ApiException] from a [DioException], reading the
  /// backend's error body first (message / error / ASP.NET-style
  /// `errors` map) and falling back to a sensible message per status code
  /// or connection problem when the backend gave nothing useful.
  factory ApiException.fromDioException(DioException e) {
    final data = e.response?.data;

    if (data is Map) {
      final fromMessage = data['message'];
      if (fromMessage != null && fromMessage.toString().trim().isNotEmpty) {
        return ApiException(fromMessage.toString(), statusCode: e.response?.statusCode, cause: e);
      }
      final fromError = data['error'];
      if (fromError != null && fromError.toString().trim().isNotEmpty) {
        return ApiException(fromError.toString(), statusCode: e.response?.statusCode, cause: e);
      }
      // ASP.NET-style validation errors: { "errors": { "Email": ["..."] } }
      final errors = data['errors'];
      if (errors is Map && errors.isNotEmpty) {
        final firstValue = errors.values.first;
        if (firstValue is List && firstValue.isNotEmpty) {
          return ApiException(firstValue.first.toString(), statusCode: e.response?.statusCode, cause: e);
        }
        if (firstValue != null) {
          return ApiException(firstValue.toString(), statusCode: e.response?.statusCode, cause: e);
        }
      }
    } else if (data is String && data.trim().isNotEmpty) {
      return ApiException(data, statusCode: e.response?.statusCode, cause: e);
    }

    return ApiException(_fallbackMessage(e), statusCode: e.response?.statusCode, cause: e);
  }

  static String _fallbackMessage(DioException e) {
    switch (e.response?.statusCode) {
      case 400:
        return 'The data entered is invalid. Please check the fields.';
      case 401:
        return 'Your session has expired. Please log in again.';
      case 403:
        return "You don't have permission to perform this action.";
      case 404:
        return 'The requested item was not found.';
      case 409:
        return 'This item already exists.';
      case 422:
        return 'Some fields are invalid. Please review the data.';
      case 500:
      case 502:
      case 503:
        return 'A server error occurred. Please try again later.';
      default:
        switch (e.type) {
          case DioExceptionType.connectionTimeout:
          case DioExceptionType.receiveTimeout:
          case DioExceptionType.sendTimeout:
            return 'The request timed out. Please check your internet connection and try again.';
          case DioExceptionType.connectionError:
            return 'Could not connect to the server. Please check your internet connection.';
          case DioExceptionType.cancel:
            return 'The request was cancelled.';
          default:
            return 'An unexpected error occurred. Please try again.';
        }
    }
  }

  @override
  String toString() => message;
}

/// Extracts a friendly, user-facing message from *any* error caught in a
/// UI layer — whether it's the [ApiException] thrown by [ApiService], or
/// something else entirely (parsing error, null check, etc.). Use this
/// everywhere instead of `e.toString()` so the user never sees a raw
/// Dio/stack-trace style message.
String friendlyErrorMessage(Object error) {
  if (error is ApiException) return error.message;
  return 'An unexpected error occurred. Please try again.';
}