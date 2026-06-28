import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;
import 'student_auth_model.dart';
class StudentAuthRepository {
  final String _baseUrl = 'http://localhost:5132/api/auth/student';

  Future<StudentAuthModel> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return StudentAuthModel.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      throw Exception('Invalid Username or Password'.tr());
    } else {
      throw Exception('Server error. Please try again.'.tr());
    }
  }
}