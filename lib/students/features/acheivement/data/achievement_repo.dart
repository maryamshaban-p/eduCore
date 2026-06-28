import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:edulink_app/platform/Admin1/core/services/storage_service.dart';
import 'package:http/http.dart' as http;
import 'achievement_model.dart';

class AchievementRepository {
  final StorageService _storage = StorageService();
  final String _baseUrl = 'http://localhost:5132/api/student';

  Future<Map<String, String>> _headers() async {
    final token = await _storage.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<AchievementModel> getAchievement() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/achievement'),
      headers: await _headers(),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return AchievementModel.fromJson(data);
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized. Please login again.'.tr());
    } else {
      throw Exception('Failed to load achievement data.'.tr());
    }
  }
}