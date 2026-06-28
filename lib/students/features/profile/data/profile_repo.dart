import 'dart:convert';
import 'dart:typed_data';
import 'package:easy_localization/easy_localization.dart';
import 'package:edulink_app/platform/Admin1/core/services/storage_service.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'profile_model.dart';

class ProfileRepository {
  final StorageService _storage = StorageService();
  final String _baseUrl = 'http://localhost:5132/api/student';

  Future<Map<String, String>> _headers() async {
    final token = await _storage.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<String?> _token() async => await _storage.getToken();

  Future<ProfileModel> getProfile() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/profile'),
      headers: await _headers(),
    );

    if (response.statusCode == 200) {
      return ProfileModel.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized. Please login again.'.tr());
    } else {
      throw Exception('Failed to load profile.'.tr());
    }
  }

  Future<void> updateProfile({
    required String firstName,
    required String lastName,
    required String phone,
    required String languagePref,
  }) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/profile'),
      headers: await _headers(),
      body: jsonEncode({
        'firstName': firstName,
        'lastName': lastName,
        'phone': phone,
        'languagePref': languagePref,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update profile.'.tr());
    }
  }


  Future<String> uploadPhoto(Uint8List bytes, String fileName) async {
    final token = await _token();
    final uri = Uri.parse('$_baseUrl/profile/photo');

    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..files.add(
        http.MultipartFile.fromBytes(
          'File',
          bytes,
          filename: fileName,
          contentType: MediaType('image', _getExtension(fileName)),
        ),
      );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['imageUrl'] as String;
    } else {
      throw Exception('Failed to upload photo.'.tr());
    }
  }

  Future<void> deletePhoto() async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/profile/deletephoto'),
      headers: await _headers(),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete photo.'.tr());
    }
  }

  Future<void> logout() async {
    await _storage.deleteToken();
  }

  String _getExtension(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    switch (ext) {
      case 'jpg':
      case 'jpeg': return 'jpeg';
      case 'png': return 'png';
      case 'gif': return 'gif';
      default: return 'jpeg';
    }
  }
}