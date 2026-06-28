import 'package:dio/dio.dart';
import 'package:edulink_app/core/errors/api_exception.dart';
import 'package:edulink_app/core/services/user_session.dart';

class AuthService {
  static const String _baseUrl = 'http://localhost:5132/api';

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      headers: {'Content-Type': 'application/json'},
    ),
  );

  // ── Login ────────────────────────────────────────────────────────────

  Future<void> loginModerator({
    required String email,
    required String password,
  }) async {
    await _login('/auth/moderator/login', email: email, password: password);
  }

  Future<void> loginTeacher({
    required String email,
    required String password,
  }) async {
    await _login('/auth/teacher/login', email: email, password: password);
  }

  Future<void> _login(
    String endpoint, {
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(endpoint, data: {
        'email': email.trim(),
        'password': password,
      });
      UserSession.save(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (_) {
      throw const ApiException('An unexpected error occurred. Please try again.');
    }
  }

  // ── GET /auth/me ─────────────────────────────────────────────────────
  /// Fetches the current user's profile and updates [UserSession].
  /// Called by dashboard screens on init to ensure the session is fresh.
  /// Response shape: { id, firstname, lastname, email, role? }
  Future<void> getMe() async {
    final token = UserSession.token;
    if (token.isEmpty) {
      throw const ApiException('Not authenticated. Please log in.');
    }
    try {
      final response = await _dio.get(
        '/auth/me',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final data = Map<String, dynamic>.from(response.data as Map);

      // /auth/me doesn't return a `token` or `role` field, so we keep
      // the values already stored in the session from login and only
      // update the profile fields.
      data['token'] = UserSession.token;
      data['role']  = UserSession.role;
      data['userId'] = data['id'] ?? UserSession.userId;

      UserSession.save(data);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw const ApiException('An unexpected error occurred. Please try again.');
    }
  }

  // ── Logout ───────────────────────────────────────────────────────────
  void logout() => UserSession.clear();
}