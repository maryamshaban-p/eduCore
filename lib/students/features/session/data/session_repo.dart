import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:edulink_app/platform/Admin1/core/services/storage_service.dart';
import 'package:edulink_app/students/features/session/data/session_model.dart';
import 'package:edulink_app/students/features/session_details/data/session_details_model.dart';
import 'package:http/http.dart' as http;

// ✅ ADD THIS CLASS (ViewRecordResponse)
class ViewRecordResponse {
  final int views;
  final int maxViews;

  ViewRecordResponse({
    required this.views,
    required this.maxViews,
  });

  factory ViewRecordResponse.fromJson(Map<String, dynamic> json) {
    return ViewRecordResponse(
      views: json['views'] ?? 0,
      maxViews: json['maxViews'] ?? 0,
    );
  }
}

class SessionRepository {
  final StorageService _storage = StorageService();
  final String _studentBaseUrl = 'http://localhost:5132/api/student';

  Future<Map<String, String>> _headers() async {
    final token = await _storage.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // ✅ ADD THIS NEW METHOD - recordView
  Future<ViewRecordResponse> recordView(int sessionId) async {
    try {
      final response = await http.post(
        Uri.parse('$_studentBaseUrl/lesson/$sessionId/view'),
        headers: await _headers(),
      );

      if (response.statusCode == 200) {
        return ViewRecordResponse.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 423) {
        throw Exception(
          'This session is locked. Complete the previous session first.'.tr(),
        );
      } else if (response.statusCode == 400) {
        throw Exception('Max views reached for this lesson.'.tr());
      } else {
        throw Exception('Failed to record view.'.tr());
      }
    } catch (e) {
      throw Exception('Error recording view: ${e.toString()}');
    }
  }

  // ✅ UPDATED - Changed parameter from int to double
  Future<int> updateLessonProgress(int sessionId, double progressPercent) async {
    try {
      // Clamp progress between 0 and 100
      final clampedProgress = progressPercent.clamp(0.0, 100.0);

      final response = await http.post(
        Uri.parse('$_studentBaseUrl/lesson/$sessionId/progress'),
        headers: await _headers(),
        body: jsonEncode({'progressPercent': clampedProgress}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data['progressPercent'] as num?)?.toInt() ?? progressPercent.toInt();
      } else {
        throw Exception('Failed to update progress.'.tr());
      }
    } catch (e) {
      // Progress updates should be silent - don't throw
      print('Progress update error (silent): $e');
      return progressPercent.toInt();
    }
  }

  Future<HomeworkSubmissionModel?> getHomeworkSubmission(int sessionId) async {
    final response = await http.get(
      Uri.parse('$_studentBaseUrl/homework/$sessionId'),
      headers: await _headers(),
    );

    if (response.statusCode == 200) {
      return HomeworkSubmissionModel.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Failed to load homework.'.tr());
    }
  }

  /// Submits (or re-submits) a homework file for a session, after the
  /// file has already been uploaded to Firebase Storage and a download
  /// URL obtained. This just registers the submission with the backend.
  ///
  /// NOTE: verify the exact endpoint path/payload shape with the backend
  /// team — this follows the same pattern as the other student endpoints
  /// (`POST /api/student/homework/{sessionId}`) but hasn't been confirmed
  /// against a real backend route yet.
  Future<HomeworkSubmissionModel> submitHomework({
    required int sessionId,
    required String fileName,
    required String fileUrl,
    required int fileSizeBytes,
  }) async {
    final response = await http.post(
      Uri.parse('$_studentBaseUrl/homework/$sessionId'),
      headers: await _headers(),
      body: jsonEncode({
        'fileName': fileName,
        'fileUrl': fileUrl,
        'fileSize': fileSizeBytes,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return HomeworkSubmissionModel.fromJson(jsonDecode(response.body));
    } else {
      final body = _tryDecode(response.body);
      throw Exception(
          (body != null ? body['message'] as String? : null) ??
              'Failed to submit homework.'.tr());
    }
  }

  Map<String, dynamic>? _tryDecode(String body) {
    try {
      return jsonDecode(body) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  /// Fetches the FULL lesson payload — including the `files` array
  /// (which contains the actual video) — from
  /// GET /api/student/lesson/{sessionId}/details.
  ///
  /// The lightweight /course/{courseId}/sessions endpoint used to list
  /// sessions does NOT include `files`, so this must be called
  /// separately when the student opens a specific session.
  Future<LessonDetailsModel> getLessonDetails(int sessionId) async {
    final response = await http.get(
      Uri.parse('$_studentBaseUrl/lesson/$sessionId/details'),
      headers: await _headers(),
    );

    if (response.statusCode == 200) {
      return LessonDetailsModel.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized. Please login again.'.tr());
    } else if (response.statusCode == 403) {
      throw Exception('You do not have access to this session.'.tr());
    } else if (response.statusCode == 404) {
      throw Exception('Session not found.'.tr());
    } else {
      throw Exception('Failed to load session details.'.tr());
    }
  }
}