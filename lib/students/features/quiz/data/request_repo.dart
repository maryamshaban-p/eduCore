// lib/students/features/requests/data/request_repo.dart

import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:edulink_app/platform/Admin1/core/services/storage_service.dart';
import 'package:http/http.dart' as http;
import 'request_model.dart';

class RequestRepository {
  final StorageService _storage = StorageService();
  final String _baseUrl = 'http://localhost:5000/api/student';

  Future<Map<String, String>> _headers() async {
    final token = await _storage.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  /// Submit a view request for a session
  Future<void> submitViewRequest(int sessionId, String reason) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/request/views'),
      headers: await _headers(),
      body: jsonEncode({'sessionId': sessionId, 'reason': reason}),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      final body = jsonDecode(response.body);
      throw Exception(body['message'] ?? 'Failed to submit view request.'.tr());
    }
  }

  /// Submit a retake request for a session test
  Future<void> submitRetakeRequest(int sessionId, String reason) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/request/retake'),
      headers: await _headers(),
      body: jsonEncode({'sessionId': sessionId, 'reason': reason}),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      final body = jsonDecode(response.body);
      throw Exception(body['message'] ?? 'Failed to submit retake request.'.tr());
    }
  }

  /// Get all requests submitted by this student
  Future<List<StudentRequest>> getMyRequests() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/request/my-requests'),
      headers: await _headers(),
    );

    if (response.statusCode == 200) {
      final list = jsonDecode(response.body) as List;
      return list.map((e) => StudentRequest.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load requests.'.tr());
    }
  }
}