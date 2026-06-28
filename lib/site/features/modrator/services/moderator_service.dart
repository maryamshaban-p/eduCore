import '../../../../core/services/api_service.dart';

class ModeratorDashboard {
  final String moderatorName;
  final int totalStudents;
  final int activeEnrollments;
  final int pendingRequests;
  final int newThisMonth;
  final List<Map<String, dynamic>> assignedTeachers;
  final List<Map<String, dynamic>> recentlyAddedStudents;
  final List<Map<String, dynamic>> chartData;

  ModeratorDashboard({
    required this.moderatorName,
    required this.totalStudents,
    required this.activeEnrollments,
    required this.pendingRequests,
    required this.newThisMonth,
    required this.assignedTeachers,
    required this.recentlyAddedStudents,
    required this.chartData,
  });

  factory ModeratorDashboard.fromJson(Map<String, dynamic> json) {
    // Real /moderator/dashboard response uses `assignedTeachersList`, with
    // each item shaped as { teacher_id, fullName, subjects, initials }.
    final teachers = (json['assignedTeachersList'] as List? ?? [])
        .map((t) => {
              'teacherId': (t['teacher_id'] ?? '').toString(),
              'teacherName': (t['fullName'] ?? '').toString(),
              'subject': t['subjects'] is List
                  ? (t['subjects'] as List).join(', ')
                  : (t['subjects'] ?? '').toString(),
            })
        .toList();

    // Real response uses `recentStudents`, not `recentlyAddedStudents`.
    final students = (json['recentStudents'] as List? ?? [])
        .map((s) => {
              'name': (s['name'] ?? '').toString(),
              'joinedDate': (s['joinedDate'] ?? '').toString(),
            })
        .toList();

    final chart = (json['chartData'] as List? ?? [])
        .map((c) => {
              'teacherName': (c['teacherName'] ?? '').toString(),
              'studentCount': (c['studentCount'] ?? 0) as int,
            })
        .toList();

    return ModeratorDashboard(
      // The dashboard endpoint doesn't actually return a moderator name
      // field (no `moderatorName`, no `firstname`/`lastname`), so this
      // will always come back empty from this response. Pull the
      // moderator's display name from UserSession instead if you need it
      // in the UI.
      moderatorName: json['moderatorName'] ??
          '${json['firstname'] ?? ''} ${json['lastname'] ?? ''}'.trim(),
      totalStudents: json['totalStudents'] ?? 0,
      activeEnrollments: json['totalEnrollments'] ?? 0,
      pendingRequests: json['pendingRequests'] ?? 0,
      newThisMonth: json['newThisMonth'] ?? 0,
      assignedTeachers: teachers,
      recentlyAddedStudents: students,
      chartData: chart,
    );
  }
}

class ModeratorService {
  final ApiService _api = ApiService();

  Future<ModeratorDashboard> getDashboard() async {
    final response = await _api.get('/moderator/dashboard');
    return ModeratorDashboard.fromJson(response.data);
  }

  /// Returns the teachers belonging to this moderator only.
  ///
  /// Real endpoint is `/moderator/my-teachers` (NOT `/moderator/teachers`),
  /// and each item is shaped as:
  ///   { teacherId, userId, fullName, email, subjects, isApproved, studentCount }
  ///
  /// Previously this read `t['teacher_id']` (snake_case, doesn't exist) and
  /// `t['name']` (doesn't exist — real key is `fullName`), so every teacher
  /// came back with an empty id and an empty name, breaking teacher
  /// assignment and course filtering everywhere this list is consumed.
  Future<List<Map<String, dynamic>>> getTeachers() async {
    final response = await _api.get('/moderator/my-teachers');
    return (response.data as List)
        .map((t) => {
              'teacherId': (t['teacherId'] ?? '').toString(),
              'teacherName': (t['fullName'] ?? '').toString(),
              'subject': t['subjects'] is List
                  ? (t['subjects'] as List).join(', ')
                  : (t['subjects'] ?? '').toString(),
            })
        .toList();
  }

  Future<List<Map<String, dynamic>>> getActivityTimeline() async {
    final response = await _api.get('/moderator/activity-timeline');
    return (response.data as List)
        .map((a) => {
              'description': (a['text'] ?? '').toString(),
              'timeAgo': (a['timeDisplay'] ?? '').toString(),
            })
        .toList();
  }
}