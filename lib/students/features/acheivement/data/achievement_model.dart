class AchievementModel {
  final int totalEnrolled;
  final int completedCourses;
  final double averageQuizScore;
  final int totalAbsences;
  final int totalHomeworkSubmitted;
  final int totalQuizzesTaken;
  final List<CourseActivity> coursesActivity;

  AchievementModel({
    required this.totalEnrolled,
    required this.completedCourses,
    required this.averageQuizScore,
    required this.totalAbsences,
    required this.totalHomeworkSubmitted,
    required this.totalQuizzesTaken,
    required this.coursesActivity,
  });

  factory AchievementModel.fromJson(Map<String, dynamic> json) {
    return AchievementModel(
      totalEnrolled: json['totalEnrolled'] as int? ?? 0,
      completedCourses: json['completedCourses'] as int? ?? 0,
      averageQuizScore: (json['averageQuizScore'] as num?)?.toDouble() ?? 0,
      totalAbsences: json['totalAbsences'] as int? ?? 0,
      totalHomeworkSubmitted: json['totalHomeworkSubmitted'] as int? ?? 0,
      totalQuizzesTaken: json['totalQuizzesTaken'] as int? ?? 0,
      coursesActivity: (json['coursesActivity'] as List? ?? [])
          .map((e) => CourseActivity.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class CourseActivity {
  final int courseId;
  final String title;
  final String teacherName;
  final int progressPercent;
  final String enrolledAt;

  CourseActivity({
    required this.courseId,
    required this.title,
    required this.teacherName,
    required this.progressPercent,
    required this.enrolledAt,
  });

  factory CourseActivity.fromJson(Map<String, dynamic> json) {
    return CourseActivity(
      courseId: json['courseId'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      teacherName: json['teacherName'] as String? ?? '',
      progressPercent: json['progressPercent'] as int? ?? 0,
      enrolledAt: json['enrolledAt'] as String? ?? '',
    );
  }
}