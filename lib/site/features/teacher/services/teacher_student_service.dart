import '../../../../core/services/api_service.dart';

// ── Models ────────────────────────────────────────────────────────────────────

class TeacherStudent {
  final String studentId;
  final String studentName;
  final double averageScore;
  final int completedLessons;
  final String educationLevel;
  final String lastActive;

  TeacherStudent({
    required this.studentId,
    required this.studentName,
    required this.averageScore,
    required this.completedLessons,
    required this.educationLevel,
    required this.lastActive,
  });

  factory TeacherStudent.fromJson(Map<String, dynamic> json) {
    return TeacherStudent(
      studentId:        json['studentId'] ?? '',
      studentName:      json['studentName'] ?? '',
      averageScore:     (json['avgScore'] ?? 0).toDouble(),
      completedLessons: json['lessonsCompleted'] ?? 0,
      educationLevel:   json['educationLevel'] ?? '',
      lastActive:       json['lastActive'] ?? '',
    );
  }
}

class StudentLesson {
  final int lessonId;
  final String lessonTitle;
  final double watchPercent;
  final int viewsUsed;
  final int totalViews;
  final String entryTest;  // "-" or score string
  final String result;

  StudentLesson({
    required this.lessonId,
    required this.lessonTitle,
    required this.watchPercent,
    required this.viewsUsed,
    required this.totalViews,
    required this.entryTest,
    required this.result,
  });

  factory StudentLesson.fromJson(Map<String, dynamic> json) {
    // parse "0/5" → viewsUsed=0, totalViews=5
    int viewsUsed = 0;
    int totalViews = 5;
    final viewsRaw = json['viewsUsed']?.toString() ?? '0/5';
    final parts = viewsRaw.split('/');
    viewsUsed  = int.tryParse(parts[0]) ?? 0;
    totalViews = parts.length > 1 ? (int.tryParse(parts[1]) ?? 5) : 5;

    return StudentLesson(
      lessonId:    json['lessonId'] ?? 0,
      lessonTitle: json['lesson'] ?? '',
      watchPercent: (json['watchPercent'] ?? 0).toDouble(),
      viewsUsed:   viewsUsed,
      totalViews:  totalViews,
      entryTest:   json['entryTest']?.toString() ?? '-',
      result:      json['result'] ?? 'Locked',
    );
  }
}

class StudentDetail {
  final String studentId;
  final String studentName;
  final double grade;
  final double averageScore;
  final double completionRate;
  final List<StudentLesson> lessons;

  StudentDetail({
    required this.studentId,
    required this.studentName,
    required this.grade,
    required this.averageScore,
    required this.completionRate,
    required this.lessons,
  });

  factory StudentDetail.fromJson(Map<String, dynamic> json) {
    return StudentDetail(
      studentId:      json['studentId'] ?? '',
      studentName:    json['studentName'] ?? '',
      grade:          (json['grade'] ?? 0).toDouble(),
      averageScore:   (json['averageScore'] ?? 0).toDouble(),
      completionRate: (json['completionRate'] ?? 0).toDouble(),
      lessons:        (json['lessons'] as List? ?? [])
                        .map((l) => StudentLesson.fromJson(l))
                        .toList(),
    );
  }
}

// ── Service ───────────────────────────────────────────────────────────────────

class TeacherStudentService {
  final ApiService _api = ApiService();

  Future<List<TeacherStudent>> getStudents() async {
    final response = await _api.get('/teacher/students');
    return (response.data as List)
        .map((item) => TeacherStudent.fromJson(item))
        .toList();
  }

  Future<StudentDetail> getStudentDetail(String studentId) async {
    final response = await _api.get('/teacher/students/$studentId');
    return StudentDetail.fromJson(response.data);
  }

  Future<List<Map<String, dynamic>>> getGrades() async {
    final response = await _api.get('/teacher/grades');
    return List<Map<String, dynamic>>.from(response.data);
  }
}