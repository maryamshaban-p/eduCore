import 'package:edulink_app/platform/Admin1/features/overview/widgets/chart/enrollment_chart_builder.dart';

class AdminOverviewModel {
  final int totalTeachers;
  final int totalModerators;
  final int totalStudents;
  final int activeCourses;
  final List<dynamic> enrollmentBySubject;
  final List<dynamic> recentActivities;
  const AdminOverviewModel({
    required this.totalTeachers,
    required this.totalModerators,
    required this.totalStudents,
    required this.activeCourses,
    required this.enrollmentBySubject,
    required this.recentActivities,
  });

  factory AdminOverviewModel.fromJson(Map<String, dynamic> json) {
    return AdminOverviewModel(
      totalTeachers: json['totalTeachers'] ?? 0,
      totalModerators: json['totalModerators'] ?? 0,
      totalStudents: json['totalStudents'] ?? 0,
      activeCourses: json['totalCourses'] ?? 0,
      enrollmentBySubject: json['enrollmentByCourse'] as List? ?? [],
      recentActivities: json['recentActivities'] as List? ?? [],
    );
  }
}

class ActivityItem {
  final String text;
  final String time;

  const ActivityItem({required this.text, required this.time});

  factory ActivityItem.fromJson(Map<String, dynamic> json) {
    return ActivityItem(
      text: json['text'] as String? ?? '',
      time: json['time'] as String? ?? '',
    );
  }
}

List<EnrollmentEntry> enrollmentFromJson(List<dynamic> json) {
  return json.map((e) => (
    subject: e['courseTitle'] as String? ?? '',
    value: (e['students'] as num?)?.toDouble() ?? 0.0,
  )).toList();
}

    // "totalTeachers": 7,
    // "totalModerators": 3,
    // "totalStudents": 4,
    // "totalCourses": 11,
    // "enrollmentByCourse": [
    //   { "courseId": 1, "courseTitle": "math", "students": 1 },
    //   { "courseId": 3, "courseTitle": "science", "students": 2 }
    // ],
    // "recentActivities": [
    //   { "id": 18, "text": "Moderator ahmed mohamed created", "time": "2026-06-24T00:40:51.682726Z" }
    // ]