import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:edulink_app/platform/Admin1/core/services/storage_service.dart';
import 'package:http/http.dart' as http;
import 'home_model.dart';

class HomeRepository {
  final StorageService _storage = StorageService();
  final String _baseUrl = 'http://localhost:5132/api/student';

  Future<StudentHomeModel> getHome() async {
    final token = await _storage.getToken();
    final response = await http.get(
      Uri.parse('$_baseUrl/home'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return StudentHomeModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to load home data'.tr());
  }
}