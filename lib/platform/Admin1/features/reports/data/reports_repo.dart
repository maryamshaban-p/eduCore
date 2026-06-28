import 'dart:convert';
import 'package:edulink_app/platform/Admin1/core/services/storage_service.dart';
import 'package:http/http.dart' as http;
import 'reports_models.dart';

class ReportsRepository {
  final StorageService _storage = StorageService();
  final String _baseUrl = 'http://localhost:5132/api/admin';

  Future<Map<String, String>> _headers() async {
    final token = await _storage.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<({List<EnrollmentItem> enrollment, List<TeacherShare> teachers})> fetchAll() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/reports'),
      headers: await _headers(),
    );
    final data = jsonDecode(response.body) as Map<String, dynamic>;

    final enrollmentList = (data['monthlyEnrollments'] as List? ?? [])
        .map((e) => EnrollmentItem.fromJson(e))
        .toList();

    final teacherList = (data['studentsPerTeacher'] as List? ?? [])
        .asMap()
        .entries
        .map((e) => TeacherShare.fromJson(e.value, kChartColors[e.key % kChartColors.length]))
        .toList();

    return (enrollment: enrollmentList, teachers: teacherList);
  }
}
