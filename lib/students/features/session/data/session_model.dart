class HomeworkSubmissionModel {
  final int submissionId;
  final String fileName;
  final String fileUrl;
  final String submittedAt;
  final bool isReviewed;
  final double? grade;
  final String? teacherComment;

  HomeworkSubmissionModel({
    required this.submissionId,
    required this.fileName,
    required this.fileUrl,
    required this.submittedAt,
    required this.isReviewed,
    this.grade,
    this.teacherComment,
  });

  factory HomeworkSubmissionModel.fromJson(Map<String, dynamic> json) {
    return HomeworkSubmissionModel(
      submissionId: json['submissionId'] as int? ?? 0,
      fileName: json['fileName'] as String? ?? '',
      fileUrl: json['fileUrl'] as String? ?? '',
      submittedAt: json['submittedAt'] as String? ?? '',
      isReviewed: json['isReviewed'] as bool? ?? false,
      grade: (json['grade'] as num?)?.toDouble(),
      teacherComment: json['teacherComment'] as String?,
    );
  }
}