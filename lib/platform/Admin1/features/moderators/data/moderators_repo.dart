import 'dart:convert';
import 'package:edulink_app/platform/Admin1/core/services/storage_service.dart';
import 'package:http/http.dart' as http;
import 'moderator_model.dart';
import '../../teachers/data/teacher_model.dart';

class ModeratorsRepository {
  final StorageService _storageService = StorageService();
  final String _baseUrl = 'http://localhost:5132/api/admin';

  Future<Map<String, String>> _headers() async {
    final token = await _storageService.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<List<ModeratorModel>> getModerators() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/AllModerators'),
      headers: await _headers(),
    );
    final data = jsonDecode(response.body) as List;
    return data.map((e) => ModeratorModel.fromJson(e)).toList();
  }

  Future<List<TeacherModel>> getTeachers() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/AllTeachers'),
      headers: await _headers(),
    );
    final data = jsonDecode(response.body) as List;
    return data.map((e) => TeacherModel.fromJson(e)).toList();
  }

  Future<void> addModerator({
    required String firstname,
    required String lastname,
    required String email,
    required String password,
    required List<String> assignedTeacherIds,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/AddModerators'),
      headers: await _headers(),
      body: jsonEncode({
        'firstname': firstname,
        'lastname': lastname,
        'email': email,
        'password': password,
        'assigned_teacher_ids': assignedTeacherIds,
      }),
    );
    if (response.statusCode != 200) throw Exception(response.body);
  }

  Future<void> updateModerator({
    required String id,
    required String firstname,
    required String lastname,
    required List<String> assignedTeacherIds,
  }) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/UpdateModerators/$id'),
      headers: await _headers(),
      body: jsonEncode({
        'firstname': firstname,
        'lastname': lastname,
        'assigned_teacher_ids': assignedTeacherIds,
      }),
    );
    if (response.statusCode != 200) throw Exception(response.body);
  }

  Future<void> deleteModerator(String id) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/DeleteModerators/$id'),
      headers: await _headers(),
    );
    if (response.statusCode != 200) throw Exception(response.body);
  }
}