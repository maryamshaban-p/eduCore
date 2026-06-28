// lib/students/features/subject/data/subject_model.dart

class SubjectModel {
  final int courseId;
  final String title;
  final String introduction;
  final String? pictureUrl;
  final String academicLevel;
  final int academicYear;
  final String teacherName;
  final String teacherSubject;
  final double progressPercent;
  final int totalSessions;
  final int completedSessions;
  final String enrolledAt;

  SubjectModel({
    required this.courseId,
    required this.title,
    required this.introduction,
    this.pictureUrl,
    required this.academicLevel,
    required this.academicYear,
    required this.teacherName,
    required this.teacherSubject,
    required this.progressPercent,
    required this.totalSessions,
    required this.completedSessions,
    required this.enrolledAt,
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      courseId: json['courseId'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      introduction: json['introduction'] as String? ?? '',
      pictureUrl: json['pictureUrl'] as String?,
      academicLevel: json['academicLevel'] as String? ?? '',
      academicYear: json['academicYear'] as int? ?? 0,
      teacherName: json['teacherName'] as String? ?? '',
      teacherSubject: json['teacherSubject'] as String? ?? '',
      progressPercent: (json['progressPercent'] as num?)?.toDouble() ?? 0,
      totalSessions: json['totalSessions'] as int? ?? 0,
      completedSessions: json['completedSessions'] as int? ?? 0,
      enrolledAt: json['enrolledAt'] as String? ?? '',
    );
  }
}

class SubjectSessionsModel {
  final int courseId;
  final String courseTitle;
  final String introduction;
  final String? pictureUrl;
  final String academicLevel;
  final int academicYear;
  final String teacherName;
  final String teacherSubject;
  final int progressPercent;
  final int totalSessions;
  final int completedSessions;
  final List<SessionModel> sessions;

  SubjectSessionsModel({
    required this.courseId,
    required this.courseTitle,
    required this.introduction,
    this.pictureUrl,
    required this.academicLevel,
    required this.academicYear,
    required this.teacherName,
    required this.teacherSubject,
    required this.progressPercent,
    required this.totalSessions,
    required this.completedSessions,
    required this.sessions,
  });

  factory SubjectSessionsModel.fromJson(Map<String, dynamic> json) {
    return SubjectSessionsModel(
      courseId: json['courseId'] as int? ?? 0,
      courseTitle: json['courseTitle'] as String? ?? '',
      introduction: json['introduction'] as String? ?? '',
      pictureUrl: json['pictureUrl'] as String?,
      academicLevel: json['academicLevel'] as String? ?? '',
      academicYear: json['academicYear'] as int? ?? 0,
      teacherName: json['teacherName'] as String? ?? '',
      teacherSubject: json['teacherSubject'] as String? ?? '',
      progressPercent: json['progressPercent'] as int? ?? 0,
      totalSessions: json['totalSessions'] as int? ?? 0,
      completedSessions: json['completedSessions'] as int? ?? 0,
      sessions: (json['sessions'] as List? ?? [])
          .map((e) => SessionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class SessionModel {
  final int sessionId;
  final String title;
  final int availableDays;
  final int maxViews;
  final int viewsUsed;
  final int viewsRemaining;
  final bool isWatched;
  final double watchProgressPercent;
  final bool hasAttachments;
  final List<SessionFile> files;
  final bool hasHomework;
  final String? homeworkFileUrl;
  final String? homeworkFileName;
  final String? homeworkFileType;
  final int? homeworkFileSize;
  final bool hasEntryTest;
  final bool? entryTestPassed;
  final double? entryTestBestScore;
  final bool homeworkSubmitted;
  final double? homeworkGrade;

  // ── New fields from /api/student/course/{id}/sessions ──
  final bool isLocked;
  final int views;
  final bool testPassed;

  // Computed
  bool get hasViewsRemaining => views < maxViews;

  SessionModel({
    required this.sessionId,
    required this.title,
    required this.availableDays,
    required this.maxViews,
    required this.viewsUsed,
    required this.viewsRemaining,
    required this.isWatched,
    required this.watchProgressPercent,
    required this.hasAttachments,
    required this.files,
    required this.hasHomework,
    this.homeworkFileUrl,
    this.homeworkFileName,
    this.homeworkFileType,
    this.homeworkFileSize,
    required this.hasEntryTest,
    this.entryTestPassed,
    this.entryTestBestScore,
    required this.homeworkSubmitted,
    this.homeworkGrade,
    this.isLocked = false,
    this.views = 0,
    this.testPassed = false,
  });

  factory SessionModel.fromJson(Map<String, dynamic> json) {
    return SessionModel(
      sessionId: json['sessionId'] as int? ?? json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      availableDays: json['availableDays'] as int? ?? 0,
      maxViews: json['maxViews'] as int? ?? 5,
      viewsUsed: json['viewsUsed'] as int? ?? json['views'] as int? ?? 0,
      viewsRemaining: json['viewsRemaining'] as int? ??
          ((json['maxViews'] as int? ?? 5) - (json['views'] as int? ?? 0)),
      isWatched: json['isWatched'] as bool? ?? false,
      watchProgressPercent:
          (json['watchProgressPercent'] as num?)?.toDouble() ??
          (json['progressPercent'] as num?)?.toDouble() ?? 0,
      hasAttachments: json['hasAttachments'] as bool? ?? false,
      files: (json['files'] as List? ?? [])
          .map((e) => SessionFile.fromJson(e as Map<String, dynamic>))
          .toList(),
      hasHomework: json['hasHomework'] as bool? ?? false,
      homeworkFileUrl: json['homeworkFileUrl'] as String?,
      homeworkFileName: json['homeworkFileName'] as String?,
      homeworkFileType: json['homeworkFileType'] as String?,
      homeworkFileSize: json['homeworkFileSize'] as int?,
      hasEntryTest: json['hasEntryTest'] as bool? ?? false,
      entryTestPassed: json['entryTestPassed'] as bool?,
      entryTestBestScore: (json['entryTestBestScore'] as num?)?.toDouble(),
      homeworkSubmitted: json['homeworkSubmitted'] as bool? ?? false,
      homeworkGrade: (json['homeworkGrade'] as num?)?.toDouble(),
      // New fields
      isLocked: json['isLocked'] as bool? ?? false,
      views: json['views'] as int? ?? 0,
      testPassed: json['testPassed'] as bool? ?? false,
    );
  }
}

class SessionFile {
  final int id;
  final String fileName;
  final String fileType;
  final int fileSize;
  final String fileUrl;

  SessionFile({
    required this.id,
    required this.fileName,
    required this.fileType,
    required this.fileSize,
    required this.fileUrl,
  });

  factory SessionFile.fromJson(Map<String, dynamic> json) {
    return SessionFile(
      id: json['id'] as int? ?? 0,
      fileName: json['fileName'] as String? ?? '',
      fileType: json['fileType'] as String? ?? '',
      fileSize: json['fileSize'] as int? ?? 0,
      fileUrl: json['fileUrl'] as String? ?? '',
    );
  }
}