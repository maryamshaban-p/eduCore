import 'dart:convert';
import 'package:edulink_app/platform/Admin1/core/services/storage_service.dart';
import 'package:edulink_app/platform/Admin1/features/overview/data/models/adminOverview_model.dart';
import 'package:edulink_app/platform/Admin1/features/overview/widgets/chart/enrollment_chart_builder.dart';
import 'package:http/http.dart' as http;

class OverviewRepository {
  final StorageService _storageService = StorageService();

  Future<Map<String, dynamic>> _fetchOverview() async {
    final token = await _storageService.getToken();
    final response = await http.get(
      Uri.parse('http://localhost:5132/api/admin/overview'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception(data is Map ? (data['message'] ?? 'Failed to load overview') : 'Failed to load overview');
    }

    return data as Map<String, dynamic>;
  }

  Future<AdminOverviewModel> getStats() async {
    final data = await _fetchOverview();
    return AdminOverviewModel.fromJson(data);
  }

  Future<List<ActivityItem>> getRecentActivity() async {
    final data = await _fetchOverview();
    final activities = data['recentActivities'] as List? ?? [];
    return activities.map((a) => ActivityItem.fromJson(a)).toList();
  }

  Future<List<EnrollmentEntry>> getEnrollmentData() async {
    final data = await _fetchOverview();
    return enrollmentFromJson(data['enrollmentByCourse'] as List? ?? []);
  }
}