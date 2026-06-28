import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:edulink_app/platform/Admin1/core/services/storage_service.dart';
import 'package:http/http.dart' as http;
import 'quiz_model.dart';

class QuizRepository {
  final StorageService _storage = StorageService();
  final String _baseUrl = 'http://localhost:5132/api/student';

  Future<Map<String, String>> _headers() async {
    final token = await _storage.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<QuizModel> getQuiz(int sessionId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/quiz/$sessionId'),
      headers: await _headers(),
    );

    if (response.statusCode == 200) {
      return QuizModel.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized. Please login again.'.tr());
    } else if (response.statusCode == 404) {
      throw Exception('No quiz found for this session.'.tr());
    } else {
      throw Exception('Failed to load quiz.'.tr());
    }
  }

  Future<QuizResultModel> submitQuiz(
      int sessionId, Map<int, int> answers) async {
    final answersJson = {
      for (final e in answers.entries) e.key.toString(): e.value
    };

    final response = await http.post(
      Uri.parse('$_baseUrl/quiz/$sessionId/submit'),
      headers: await _headers(),
      body: jsonEncode({'answers': answersJson}),
    );

    if (response.statusCode == 200) {
      return QuizResultModel.fromJson(jsonDecode(response.body));
    } else {
      final body = jsonDecode(response.body);
      throw Exception(body['message'] ?? 'Failed to submit quiz.');
    }
  }
}