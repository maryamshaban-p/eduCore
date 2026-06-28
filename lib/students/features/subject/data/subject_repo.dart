// lib/students/features/subject/data/subject_repo.dart
//
// ── TEMPORARY DEBUG BUILD ─────────────────────────────────────────────
// This version prints the raw JSON returned by the sessions endpoint
// so we can inspect whether `files` is present per-session. Remove the
// print statement (or the whole debug block) once you've confirmed the
// shape of the response.

import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:edulink_app/platform/Admin1/core/services/storage_service.dart';
import 'package:http/http.dart' as http;
import 'subject_model.dart';

class SubjectRepository {
  final StorageService _storage = StorageService();
  final String _baseUrl = 'http://localhost:5132/api/subject';
  final String _studentBaseUrl = 'http://localhost:5132/api/student';

  Future<Map<String, String>> _headers() async {
    final token = await _storage.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<List<SubjectModel>> getMySubjects() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/my-subjects'),
      headers: await _headers(),
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => SubjectModel.fromJson(e)).toList();
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized. Please login again.'.tr());
    } else {
      throw Exception('Failed to load subjects.'.tr());
    }
  }

  Future<SubjectSessionsModel> getCourseSessions(int courseId) async {
    // ── 1. Get course info from my-subjects ─────────────────────────────
    String introduction = '';
    String? pictureUrl;
    String courseTitle = '';
    String academicLevel = '';
    int academicYear = 0;
    String teacherName = '';
    String teacherSubject = '';

    try {
      final subjectsResponse = await http.get(
        Uri.parse('$_baseUrl/my-subjects'),
        headers: await _headers(),
      );
      if (subjectsResponse.statusCode == 200) {
        final List subjects = jsonDecode(subjectsResponse.body);
        final match = subjects.firstWhere(
          (s) => s['courseId'] == courseId,
          orElse: () => null,
        );
        if (match != null) {
          introduction = match['introduction'] as String? ?? '';
          pictureUrl = match['pictureUrl'] as String?;
          courseTitle = match['title'] as String? ?? '';
          academicLevel = match['academicLevel'] as String? ?? '';
          academicYear = match['academicYear'] as int? ?? 0;
          teacherName = match['teacherName'] as String? ?? '';
          teacherSubject = match['teacherSubject'] as String? ?? '';
        }
      }
    } catch (_) {
      // Non-critical — proceed without course info
    }

    // ── 2. Get sessions with isLocked, views, maxViews, testPassed ───────
    final sessionsResponse = await http.get(
      Uri.parse('$_studentBaseUrl/course/$courseId/sessions'),
      headers: await _headers(),
    );

    // ── DEBUG: print the raw response so we can see if `files` is
    // included per-session. Remove this block once confirmed. ──────────
    // ignore: avoid_print
    print('=== /course/$courseId/sessions raw response ===');
    // ignore: avoid_print
    print('status: ${sessionsResponse.statusCode}');
    // ignore: avoid_print
    print(sessionsResponse.body);
    // ignore: avoid_print
    print('=== end raw response ===');

    if (sessionsResponse.statusCode == 401) {
      throw Exception('Unauthorized. Please login again.'.tr());
    }
    if (sessionsResponse.statusCode == 403) {
      throw Exception(
          'Forbidden (403). The server rejected this request — check that the token is valid and the student is enrolled in this course.'
              .tr());
    }
    if (sessionsResponse.statusCode != 200) {
      throw Exception('Failed to load sessions.'.tr());
    }

    final List sessionsList = jsonDecode(sessionsResponse.body);
    final sessions = sessionsList
        .map((e) => SessionModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return SubjectSessionsModel(
      courseId: courseId,
      courseTitle: courseTitle,
      introduction: introduction,
      pictureUrl: pictureUrl,
      academicLevel: academicLevel,
      academicYear: academicYear,
      teacherName: teacherName,
      teacherSubject: teacherSubject,
      progressPercent: 0,
      totalSessions: sessions.length,
      completedSessions: sessions.where((s) => s.isWatched).length,
      sessions: sessions,
    );
  }
}