import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:edulink_app/platform/Admin1/core/services/storage_service.dart';
import 'package:edulink_app/students/features/session/data/session_model.dart';
import 'package:http/http.dart' as http;

class SessionRepository {
  final StorageService _storage = StorageService();
  final String _studentBaseUrl = 'http://localhost:5132/api/student';

  Future<Map<String, String>> _headers() async {
    final token = await _storage.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<int> updateLessonProgress(int sessionId, int progressPercent) async {
    final response = await http.post(
      Uri.parse('$_studentBaseUrl/lesson/$sessionId/progress'),
      headers: await _headers(),
      body: jsonEncode({'progressPercent': progressPercent}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['progressPercent'] as int? ?? progressPercent;
    } else {
      throw Exception('Failed to update progress.'.tr());
    }
  }

  Future<HomeworkSubmissionModel?> getHomeworkSubmission(int sessionId) async {
    final response = await http.get(
      Uri.parse('$_studentBaseUrl/homework/$sessionId'),
      headers: await _headers(),
    );

    if (response.statusCode == 200) {
      return HomeworkSubmissionModel.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Failed to load homework.'.tr());
    }
  }
}