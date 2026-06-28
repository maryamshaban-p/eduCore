import '../../../../core/services/api_service.dart';

class ModeratorStudent {
  final String userId;
  final String studentId;
  final String name;
  final String initials;
  final String academicLevel;
  final String teachers;
  final String subjects;
  final double avgScore;
  final int missingDays;
  final String joinedDate;

  ModeratorStudent({
    required this.userId,
    required this.studentId,
    required this.name,
    required this.initials,
    required this.academicLevel,
    required this.teachers,
    required this.subjects,
    required this.avgScore,
    required this.missingDays,
    required this.joinedDate,
  });

  factory ModeratorStudent.fromJson(Map<String, dynamic> json) {
    final name = (json['fullName'] ?? '').toString();
    final parts = name.trim().split(' ');
    String initials = '??';
    if (parts.isNotEmpty && parts[0].isNotEmpty) {
      if (parts.length >= 2 && parts[1].isNotEmpty) {
        initials = '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      } else {
        initials = parts[0][0].toUpperCase();
      }
    }

    final assignedTeachers = json['assignedTeachers'];
    final subjects = json['subjects'];

    return ModeratorStudent(
      // `userId` is the Users-table id — required by the messaging
      // endpoints (/moderator/messages/{userId}), which are keyed
      // differently from the rest of the moderator student endpoints
      // (which use the Students-table `studentId`). The two are NOT
      // interchangeable — passing studentId into a messages/* call
      // returns "student not found".
      userId: (json['userId'] ?? '').toString(),
      studentId: (json['studentId'] ?? '').toString(),
      name: name,
      initials: initials,
      academicLevel: (json['educationLevel'] ?? '').toString(),
      teachers: assignedTeachers is List
          ? assignedTeachers.map((t) => t.toString()).join(', ')
          : (assignedTeachers ?? '').toString(),
      subjects: subjects is List
          ? subjects.map((s) => s.toString()).join(', ')
          : (subjects ?? '').toString(),
      avgScore: (json['avgScore'] ?? 0).toDouble(),
      missingDays: json['missingDays'] ?? 0,
      joinedDate: (json['joined'] ?? '').toString(),
    );
  }
}

class ModeratorStudentService {
  final ApiService _api = ApiService();

  Future<List<ModeratorStudent>> getStudents() async {
    final response = await _api.get('/moderator/students');
    return (response.data as List)
        .map((item) => ModeratorStudent.fromJson(item))
        .toList();
  }

  Future<Map<String, dynamic>> getStudentDetail(String studentId) async {
    final response = await _api.get('/moderator/students/$studentId');
    return Map<String, dynamic>.from(response.data ?? {});
  }

  Future<Map<String, dynamic>> getStudentStats(String studentId) async {
    final response = await _api.get('/moderator/student-stats/$studentId');
    return Map<String, dynamic>.from(response.data ?? {});
  }

    Future<Map<String, dynamic>> createStudent({
    required String firstName,
    required String lastName,
    required String email,
    String? phoneNumber,
    String? parentPhoneNumber,     // ← مهم: parentPhoneNumber
    String? academicLevel,
    int? academicYear,
    List<String>? teacherIds,
  }) async {
    final response = await _api.post('/moderator/students', {
      'firstName': firstName.trim(),
      'lastName': lastName.trim(),
      'email': email.trim(),
      if (phoneNumber != null && phoneNumber.isNotEmpty)
        'phoneNumber': phoneNumber.trim(),
      if (parentPhoneNumber != null && parentPhoneNumber.isNotEmpty)
        'parentPhoneNumber': parentPhoneNumber.trim(),
      if (academicLevel != null && academicLevel.isNotEmpty)
        'academicLevel': academicLevel,
      if (academicYear != null) 'academicYear': academicYear,
      if (teacherIds != null && teacherIds.isNotEmpty)
        'teacherIds': teacherIds,
    });

    return Map<String, dynamic>.from(response.data ?? {});
  }

  // ✅ بيبعت array من الـ IDs
  Future<void> assignTeachers({
    required String studentId,
    required List<String> teacherIds,
  }) async {
    await _api.post('/moderator/students/$studentId/teachers', {
      'teacherIds': teacherIds,
    });
  }

  // ✅ للتوافق مع الكود القديم — بيبعت واحد بس كـ array
  Future<void> assignTeacher({
    required String studentId,
    required String teacherId,
  }) async {
    await assignTeachers(studentId: studentId, teacherIds: [teacherId]);
  }

  Future<void> removeTeacher({
    required String studentId,
    required String teacherId,
  }) async {
    await _api.delete('/moderator/students/$studentId/teachers/$teacherId');
  }

  Future<void> enrollStudent({
    required String studentId,
    required int courseId,
  }) async {
    await _api.post('/moderator/students/$studentId/enroll', {
      'CourseId': courseId,
    });
  }

  Future<void> deleteStudent(String studentId) async {
    await _api.delete('/moderator/students/$studentId');
  }

  Future<List<Map<String, dynamic>>> getCourses() async {
    final response = await _api.get('/moderator/courses');
    return (response.data as List)
        .map((c) => {
              'courseId': c['id'].toString(),
              'title': (c['title'] ?? '').toString(),
              'teacherName': (c['teacherName'] ?? '').toString(),
            })
        .toList();
  }

  Future<void> removeEnrollment({
    required String studentId,
    required String courseId,
  }) async {
    await _api.delete('/moderator/students/$studentId/enroll/$courseId');
  }
}