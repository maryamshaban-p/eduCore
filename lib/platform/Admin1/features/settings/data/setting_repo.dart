import 'dart:convert';
import 'package:http/http.dart' as http;
import 'settings_models.dart';
import 'package:edulink_app/platform/Admin1/core/services/storage_service.dart';

class SettingsRepository {
  final StorageService _storage = StorageService();
  final String _baseUrl = 'http://localhost:5132/api/admin';

  Future<Map<String, String>> _headers() async {
    final token = await _storage.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<InstitutionProfile> getProfile() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/settings'),
      headers: await _headers(),
    );
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return InstitutionProfile.fromJson(data);
  }

  Future<SubscriptionInfo> getSubscription() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/settings'),
      headers: await _headers(),
    );
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return SubscriptionInfo.fromJson(data);
  }

  Future<void> saveProfile(InstitutionProfile profile) async {
    final parts     = profile.name.trim().split(' ');
    final firstname = parts.first;
    final lastname  = parts.length > 1 ? parts.sublist(1).join(' ') : '';

    final response = await http.put(
      Uri.parse('$_baseUrl/settings'),
      headers: await _headers(),
      body: jsonEncode({
        'firstname':    firstname,
        'lastname':     lastname,
        'contactEmail': profile.email,
        'address':      profile.address,
        'phone':        profile.phone,
      }),
    );
    if (response.statusCode != 200) throw Exception(response.body);
  }
}