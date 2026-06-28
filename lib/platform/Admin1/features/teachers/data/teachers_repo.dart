import 'dart:convert';
import 'package:edulink_app/platform/Admin1/core/services/storage_service.dart';
import 'package:http/http.dart' as http;
import 'teacher_model.dart';

class TeachersRepository {
  final StorageService _storageService = StorageService();
  final String _baseUrl = 'http://localhost:5132/api/admin';

  Future<Map<String, String>> _headers() async {
    final token = await _storageService.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<List<TeacherModel>> getTeachers() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/AllTeachers'),
      headers: await _headers(),
    );
    final data = jsonDecode(response.body) as List;
    return data.map((e) => TeacherModel.fromJson(e)).toList();
  }

  Future<void> addTeacher({
    required String firstname,
    required String lastname,
    required String email,
    required String password,
    required String passwordConfirm,
    required String subject,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/AddTeachers'),
      headers: await _headers(),
      body: jsonEncode({
        'firstname': firstname,
        'lastname': lastname,
        'email': email,
        'password': password,
        'passwordConfirm': passwordConfirm,
        'subject': subject,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception(response.body);
    }
  }

  Future<void> updateTeacher({
    required String teacherId,
    required String firstname,
    required String lastname,
    required String email,
    required String subject,
  }) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/UpdateTeachers/$teacherId'),
      headers: await _headers(),
      body: jsonEncode({
        'firstname': firstname,
        'lastname': lastname,
        'email': email,
        'subject': subject,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception(response.body);
    }
  }

  Future<void> deleteTeacher(String teacherId) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/DeleteTeachers/$teacherId'),
      headers: await _headers(),
    );
    if (response.statusCode != 200) {
      throw Exception(response.body);
    }
  }
}