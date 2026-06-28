class StudentHomeModel {
  final String studentName;
  final String academicLevel;
  final int unreadNotifications;
  final HomeStatistics statistics;
  final List<RecentCourse> recentCourses;

  StudentHomeModel({
    required this.studentName,
    required this.academicLevel,
    required this.unreadNotifications,
    required this.statistics,
    required this.recentCourses,
  });

  factory StudentHomeModel.fromJson(Map<String, dynamic> json) {
    return StudentHomeModel(
      studentName: json['studentName'] as String? ?? '',
      academicLevel: json['academicLevel'] as String? ?? '',
      unreadNotifications: json['unreadNotifications'] as int? ?? 0,
      statistics: HomeStatistics.fromJson(
          json['statistics'] as Map<String, dynamic>? ?? {}),
      recentCourses: (json['recentCourses'] as List? ?? [])
          .map((e) => RecentCourse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class HomeStatistics {
  final int absence;
 // final int tasksSubmitted;
  final int quizzesTaken;
  final double overallProgress;

  HomeStatistics({
    required this.absence,
   // required this.tasksSubmitted,
    required this.quizzesTaken,
    required this.overallProgress,
  });

  factory HomeStatistics.fromJson(Map<String, dynamic> json) {
    return HomeStatistics(
      absence: json['absence'] as int? ?? 0,
      //tasksSubmitted: json['tasksSubmitted'] as int? ?? 0,
      quizzesTaken: json['quizzesTaken'] as int? ?? 0,
      overallProgress:
          (json['overallProgress'] as num?)?.toDouble() ?? 0,
    );
  }
}

class RecentCourse {
  final int courseId;
  final String title;
  final String introduction;
  final String? pictureUrl;
  final String teacherName;
  final int progressPercent;
  final int totalSessions;
  final int completedSessions;

  RecentCourse({
    required this.courseId,
    required this.title,
    required this.introduction,
    this.pictureUrl,
    required this.teacherName,
    required this.progressPercent,
    required this.totalSessions,
    required this.completedSessions,
  });

  factory RecentCourse.fromJson(Map<String, dynamic> json) {
    return RecentCourse(
      courseId: json['courseId'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      introduction: json['introduction'] as String? ?? '',
      pictureUrl: json['pictureUrl'] as String?,
      teacherName: json['teacherName'] as String? ?? '',
      progressPercent: json['progressPercent'] as int? ?? 0,
      totalSessions: json['totalSessions'] as int? ?? 0,
      completedSessions: json['completedSessions'] as int? ?? 0,
    );
  }
}