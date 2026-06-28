// lib/students/features/session/data/lesson_details_model.dart
//
// Maps the response of GET /api/student/lesson/{sessionId}/details
// This endpoint returns the FULL session payload including `files`
// (which contains the video), unlike /api/student/course/{id}/sessions
// which only returns lightweight summary fields per session.

import 'package:edulink_app/students/features/subject/data/subject_model.dart';

class LessonDetailsModel {
  final int id;
  final String title;
  final int maxViews;
  final int availableDays;
  final String? homeworkFileUrl;
  final String? homeworkFileName;
  final bool hasEntryTest;
  final List<SessionFile> files;

  LessonDetailsModel({
    required this.id,
    required this.title,
    required this.maxViews,
    required this.availableDays,
    this.homeworkFileUrl,
    this.homeworkFileName,
    required this.hasEntryTest,
    required this.files,
  });

  factory LessonDetailsModel.fromJson(Map<String, dynamic> json) {
    return LessonDetailsModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      maxViews: json['maxViews'] as int? ?? 5,
      availableDays: json['availableDays'] as int? ?? 0,
      homeworkFileUrl: json['homeworkFileUrl'] as String?,
      homeworkFileName: json['homeworkFileName'] as String?,
      hasEntryTest: json['hasEntryTest'] as bool? ?? false,
      files: (json['files'] as List? ?? [])
          .map((e) => SessionFile.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}