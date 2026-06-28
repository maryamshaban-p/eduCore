import '../../../../core/services/api_service.dart';

class TeacherDashboard {
  final String teacherName;
  final int totalSubjects;
  final int totalStudents;
  final int totalSessions;
  final int pendingRequests;
  final List<Map<String, dynamic>> studentActivityLast30Days;

  TeacherDashboard({
    required this.teacherName,
    required this.totalSubjects,
    required this.totalStudents,
    required this.totalSessions,
    required this.pendingRequests,
    required this.studentActivityLast30Days,
  });

  factory TeacherDashboard.fromJson(Map<String, dynamic> json) {
    return TeacherDashboard(
      teacherName: json['teacherName'] ?? '',
      totalSubjects: json['totalSubjects'] ?? 0,
      totalStudents: json['totalStudents'] ?? 0,
      totalSessions: json['totalSessions'] ?? 0,
      pendingRequests: json['pendingRequests'] ?? 0,
      studentActivityLast30Days: List<Map<String, dynamic>>.from(
          json['studentActivityLast30Days'] ?? []),
    );
  }
}

class TeacherService {
  final ApiService _api = ApiService();

  Future<TeacherDashboard> getDashboard() async {
    final response = await _api.get('/teacher/dashboard');
    return TeacherDashboard.fromJson(response.data);
  }
}