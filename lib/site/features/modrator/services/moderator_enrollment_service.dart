
import '../../../../core/services/api_service.dart';

class EnrollmentRecord {
  final String studentName;
  final String teacherName;
  final String subject;
  final String dateEnrolled;

  EnrollmentRecord({
    required this.studentName,
    required this.teacherName,
    required this.subject,
    required this.dateEnrolled,
  });

  factory EnrollmentRecord.fromJson(Map<String, dynamic> json) {
    return EnrollmentRecord(
      studentName: json['studentName'] ?? '',
      teacherName: json['teacherName'] ?? '',
      subject: json['courseName'] ?? '',
      dateEnrolled: json['dateEnrolled'] ?? '',
    );
  }
}

class ModeratorEnrollmentService {
  final ApiService _api = ApiService();

  Future<List<EnrollmentRecord>> getEnrollments() async {
    final response = await _api.get('/moderator/enrollment-records');
    return (response.data as List)
        .map((item) => EnrollmentRecord.fromJson(item))
        .toList();
  }
}