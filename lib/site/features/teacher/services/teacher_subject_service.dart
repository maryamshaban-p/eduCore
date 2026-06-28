import 'package:dio/dio.dart';
import '../../../../core/services/api_service.dart';

import 'package:file_picker/file_picker.dart';

class TeacherSubject {
  final int id;
  final String title;
  final String academicLevel;
  final int academicYear;
  final int sessionsCount;
  final int studentsCount;
  final String? introduction;
  final String? pictureUrl;

  TeacherSubject({
    required this.id,
    required this.title,
    required this.academicLevel,
    required this.academicYear,
    required this.sessionsCount,
    required this.studentsCount,
    this.introduction,
    this.pictureUrl,
  });

  factory TeacherSubject.fromJson(Map<String, dynamic> json) {
    return TeacherSubject(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      academicLevel: json['academicLevel'] ?? '',
      academicYear: json['academicYear'] ?? 0,
      sessionsCount: json['sessionsCount'] ?? 0,
      studentsCount: json['studentsCount'] ?? 0,
      introduction: json['introduction'],
      pictureUrl: json['pictureUrl'],
    );
  }
}

/// Result of an entry test for a single student on a single lesson.
class EntryTestResult {
  final String status; // "Passed" | "Failed" | "Pending"
  final int? score;

  EntryTestResult({required this.status, this.score});

  factory EntryTestResult.fromJson(Map<String, dynamic>? json) {
    if (json == null) return EntryTestResult(status: 'N/A', score: null);
    return EntryTestResult(
      status: (json['status'] ?? 'N/A').toString(),
      score: json['score'] is int
          ? json['score'] as int
          : int.tryParse('${json['score']}'),
    );
  }
}

/// A single student's row in a lesson's stats table.
class StudentLessonStat {
  final int studentId;
  final String studentName;
  final String views; // comes pre-formatted from the API, e.g. "4/5"
  final int progress; // 0-100
  final DateTime? lastWatched;
  final EntryTestResult entryTest;

  StudentLessonStat({
    required this.studentId,
    required this.studentName,
    required this.views,
    required this.progress,
    required this.lastWatched,
    required this.entryTest,
  });

  factory StudentLessonStat.fromJson(Map<String, dynamic> json) {
    return StudentLessonStat(
      studentId: json['studentId'] is int
          ? json['studentId'] as int
          : int.tryParse('${json['studentId']}') ?? 0,
      studentName: (json['studentName'] ?? '').toString(),
      views: (json['views'] ?? '0/0').toString(),
      progress: json['progress'] is int
          ? json['progress'] as int
          : int.tryParse('${json['progress']}') ?? 0,
      lastWatched: DateTime.tryParse((json['lastWatched'] ?? '').toString()),
      entryTest: EntryTestResult.fromJson(
        json['entryTest'] as Map<String, dynamic>?,
      ),
    );
  }
}

/// Full response of GET /teacher/lessons/{lessonId}/stats.
class LessonStats {
  final String lessonTitle;
  final List<StudentLessonStat> data;

  LessonStats({required this.lessonTitle, required this.data});

  factory LessonStats.fromJson(Map<String, dynamic> json) {
    final rawData = (json['data'] as List? ?? []);
    return LessonStats(
      lessonTitle: (json['lesson'] ?? '').toString(),
      data: rawData
          .map((e) => StudentLessonStat.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class TeacherSubjectService {
  final ApiService _api = ApiService();

  Future<List<TeacherSubject>> getSubjects() async {
    final response = await _api.get('/teacher/subjects');
    return (response.data as List)
        .map((item) => TeacherSubject.fromJson(item))
        .toList();
  }

  Future<Map<String, dynamic>> getSubjectDetail(int courseId) async {
    final response = await _api.get('/teacher/subjects/$courseId');
    return response.data;
  }

  /// Creates a subject. Uses multipart/form-data because the API accepts
  /// an optional `Picture` file upload alongside the regular fields
  /// (Title, AcademicLevel, AcademicYear, Introduction) — same approach
  /// as [addLesson].
  Future<void> createSubject({
    required String title,
    required String academicLevel,
    required int academicYear,
    String? introduction,
    PlatformFile? picture,
  }) async {
    final formData = FormData.fromMap({
      'Title': title,
      'AcademicLevel': academicLevel,
      'AcademicYear': academicYear,
      if (introduction != null && introduction.isNotEmpty) 'Introduction': introduction,
    });

    if (picture != null) {
      formData.files.add(
        MapEntry('Picture', await _toMultipartFile(picture)),
      );
    }

    await _api.postMultipart('/teacher/subjects', formData);
  }

  /// Updates a subject. Same multipart approach as [createSubject] so a
  /// teacher can optionally replace the picture when editing.
  Future<void> updateSubject({
    required int courseId,
    required String title,
    required String academicLevel,
    required int academicYear,
    String? introduction,
    PlatformFile? picture,
  }) async {
    final formData = FormData.fromMap({
      'Title': title,
      'AcademicLevel': academicLevel,
      'AcademicYear': academicYear,
      if (introduction != null && introduction.isNotEmpty) 'Introduction': introduction,
    });

    if (picture != null) {
      formData.files.add(
        MapEntry('Picture', await _toMultipartFile(picture)),
      );
    }

    await _api.putMultipart('/teacher/subjects/$courseId', formData);
  }

  Future<void> deleteSubject(int courseId) async {
    await _api.delete('/teacher/subjects/$courseId');
  }

  /// Converts a [PlatformFile] (from file_picker) into a Dio [MultipartFile].
  ///
  /// On web, PlatformFile has no usable `path` — only in-memory `bytes` —
  /// so FilePicker must be called with `withData: true` there. On
  /// mobile/desktop, `path` is available and is preferred (avoids holding
  /// the whole file in memory).
  Future<MultipartFile> _toMultipartFile(PlatformFile file) async {
    if (file.bytes != null) {
      return MultipartFile.fromBytes(file.bytes!, filename: file.name);
    }
    if (file.path != null) {
      return MultipartFile.fromFile(file.path!, filename: file.name);
    }
    throw Exception('Selected file "${file.name}" has no readable data');
  }

  /// Creates a lesson. Uses multipart/form-data because the API accepts
  /// real file uploads for both `Files` (general attachments — an array,
  /// so multiple files can be attached) and `HomeworkFile` (a single
  /// homework document) — not URLs/paths as plain JSON.
 Future<int> addLesson({
  required int courseId,
  required String title,
  List<PlatformFile> attachmentFiles = const [],
  required int availableDays,
  required int maxViews,
  PlatformFile? homeworkFile,
  required bool hasEntryTest,
}) async {
  final formData = FormData.fromMap({
    'Title': title,
    'AvailableDays': availableDays,
    'MaxViews': maxViews,
    'HasEntryTest': hasEntryTest,
  });

  // Each attachment is added as a separate 'Files' entry — Dio/the
  // multipart encoder groups same-named fields together, which is how
  // the API's `Files: array<string>` field expects multiple files to
  // arrive (the same way HTML multipart forms send repeated `Files[]`
  // file inputs under one field name).
  for (final file in attachmentFiles) {
    formData.files.add(
      MapEntry(
        'Files',
        await _toMultipartFile(file),
      ),
    );
  }

  if (homeworkFile != null) {
    formData.files.add(
      MapEntry(
        'HomeworkFile',
        await _toMultipartFile(homeworkFile),
      ),
    );
  }

  final response = await _api.postMultipart(
    '/teacher/subjects/$courseId/lessons',
    formData,
  );

  print('Add Lesson Response: ${response.data}');

  final lessonId = response.data['lessonId'];

  if (lessonId == null) {
    throw Exception(
      'lessonId was not returned from API. Response: ${response.data}',
    );
  }

  if (lessonId is int) {
    return lessonId;
  }

  return int.parse(lessonId.toString());
}

  Future<void> addEntryTest({
    required int lessonId,
    required String title,
    required int passingScore,
    required int retakeIntervalHours,
    required List<Map<String, dynamic>> questions,
  }) async {
    await _api.post('/teacher/lessons/$lessonId/entry-test', {
      'title': title,
      'passingScore': passingScore,
      'retakeIntervalHours': retakeIntervalHours,
      'questions': questions,
    });
  }

  /// Updates a lesson. Same multipart approach as [addLesson] so a teacher
  /// can replace the homework file or attachments when editing.
  Future<void> updateLesson({
    required int lessonId,
    required String title,
    List<PlatformFile> attachmentFiles = const [],
    required int availableDays,
    required int maxViews,
    PlatformFile? homeworkFile,
    required bool hasEntryTest,
  }) async {
    final formData = FormData.fromMap({
      'Title': title,
      'AvailableDays': availableDays,
      'MaxViews': maxViews,
      'HasEntryTest': hasEntryTest,
    });

    for (final file in attachmentFiles) {
      formData.files.add(
        MapEntry('Files', await _toMultipartFile(file)),
      );
    }

    if (homeworkFile != null) {
      formData.files.add(
        MapEntry('HomeworkFile', await _toMultipartFile(homeworkFile)),
      );
    }

    await _api.putMultipart('/teacher/lessons/$lessonId', formData);
  }

  Future<void> deleteLesson(int lessonId) async {
    await _api.delete('/teacher/lessons/$lessonId');
  }

  /// Fetches per-student stats for a lesson.
  ///
  /// Real response shape (confirmed):
  ///   {
  ///     "lesson": "Introduction to Algebra",
  ///     "data": [
  ///       {
  ///         "studentId": 1,
  ///         "studentName": "Ali Mohamed",
  ///         "views": "4/5",
  ///         "progress": 87,
  ///         "lastWatched": "2026-06-18T10:00:00",
  ///         "entryTest": { "status": "Passed", "score": 82 }
  ///       },
  ///       ...
  ///     ]
  ///   }
  Future<LessonStats> getLessonStats(int lessonId) async {
    final response = await _api.get('/teacher/lessons/$lessonId/stats');
    return LessonStats.fromJson(response.data);
  }

  // ── AI-generated entry-test questions ───────────────────────────────────
  //
  // Two backend endpoints generate questions from an uploaded PDF:
  //   POST /ai/quiz?numQuestions=N        (multipart "pdf")  → multiple choice
  //   POST /ai/true-false?numQuestions=N  (multipart "pdf")  → true/false
  //
  // Actual /ai/quiz response shape (confirmed via curl):
  //   {
  //     "filename": "...",
  //     "num_questions": 5,
  //     "quiz": [
  //       {
  //         "question": "...",
  //         "options": ["opt A", "opt B", "opt C", "opt D"],
  //         "answer": "opt B"        // the TEXT of the correct option,
  //                                  // not a flag on the option itself
  //       },
  //       ...
  //     ]
  //   }
  //
  // To keep the rest of the app (addEntryTest, the manual question editor,
  // etc.) working with a single shape, every question coming back from
  // either endpoint is normalized into:
  //   { 'text': String, 'options': [ { 'text': String, 'isCorrect': bool }, ... ] }

  /// Calls /ai/quiz (multiple choice) or /ai/true-false depending on
  /// [trueFalse], uploading [pdf] as the source material, and returns the
  /// generated questions normalized to the same shape `addEntryTest` expects.
  Future<List<Map<String, dynamic>>> generateAiQuestions({
    required PlatformFile pdf,
    required int numQuestions,
    required bool trueFalse,
  }) async {
    final formData = FormData.fromMap({
      'pdf': await _toMultipartFile(pdf),
    });

    final endpoint = trueFalse ? '/ai/true-false' : '/ai/quiz';

    final response = await _api.postMultipart(
      endpoint,
      formData,
      queryParameters: {'numQuestions': numQuestions},
    );

    return _normalizeAiQuestions(response.data, trueFalse: trueFalse);
  }

  /// Normalizes shapes coming back from the AI endpoints. Accepts:
  ///   - a raw List
  ///   - { "quiz": [...] }        (confirmed real shape from /ai/quiz)
  ///   - { "questions": [...] }   (confirmed real shape from /ai/true-false)
  ///
  /// Each question item is mapped defensively:
  ///   - question text comes from `question` (fallback: `text`)
  ///   - True/False (confirmed real shape): { "question": "...", "answer": true }
  ///     — `answer` is a real boolean and there's no `options` list at all.
  ///     The two True/False options are synthesized here from that boolean.
  ///   - Multiple choice (confirmed real shape): `options` is a List<String>,
  ///     and the question's top-level `answer` is the TEXT of the correct
  ///     option (not a boolean) — correctness is decided by matching each
  ///     option's text against it (case-insensitive, trimmed).
  ///   - Also defensively supports options arriving as a List<Map> with an
  ///     explicit per-option flag (`isCorrect` / `correct` / `isAnswer`),
  ///     in case the API shape changes later.
  ///
  /// If no option ends up marked correct (e.g. the `answer` text didn't
  /// exactly match any option due to minor formatting differences), this
  /// falls back to marking the first option whose text contains the answer
  /// (or vice-versa) as correct, so a question is never silently submitted
  /// with zero correct answers.
  List<Map<String, dynamic>> _normalizeAiQuestions(
    dynamic data, {
    required bool trueFalse,
  }) {
    List<dynamic> rawList;
    if (data is List) {
      rawList = data;
    } else if (data is Map && data['quiz'] is List) {
      rawList = data['quiz'] as List;
    } else if (data is Map && data['questions'] is List) {
      rawList = data['questions'] as List;
    } else {
      throw Exception('Unexpected AI question response format: $data');
    }

    return rawList.map<Map<String, dynamic>>((raw) {
      final q = Map<String, dynamic>.from(raw as Map);

      final text = (q['question'] ?? q['text'] ?? '').toString();

      // True/False questions (confirmed real shape from /ai/true-false):
      //   { "question": "...", "answer": true }   ← `answer` is a REAL
      //   boolean here, not a string, and there's no `options` list at
      //   all. Previously this only checked for `correctAnswer` (wrong
      //   key name) as a string, so it never matched and every
      //   true/false question silently ended up with zero options.
      if (trueFalse && q['options'] == null && q.containsKey('answer')) {
        final rawAnswer = q['answer'];
        final correct = rawAnswer is bool
            ? rawAnswer
            : rawAnswer.toString().toLowerCase() == 'true';
        return {
          'text': text,
          'options': [
            {'text': 'True', 'isCorrect': correct},
            {'text': 'False', 'isCorrect': !correct},
          ],
        };
      }

      // Multiple-choice `answer` is the TEXT of the correct option (a
      // string), used below to match against the options list. Only
      // treat it as text here — the true/false boolean case above is
      // already handled and returned.
      final answerText = q['answer'] is bool ? null : q['answer']?.toString().trim();

      final rawOptions = (q['options'] as List? ?? []);

      var options = rawOptions.map((o) {
        if (o is Map) {
          // Options already carry their own correctness flag.
          return {
            'text': (o['text'] ?? o['option'] ?? '').toString(),
            'isCorrect': o['isCorrect'] == true ||
                o['correct'] == true ||
                o['isAnswer'] == true,
          };
        }

        // Plain string option — correctness comes from comparing against
        // the question's top-level `answer` field.
        final optText = o.toString();
        final isCorrect = answerText != null &&
            optText.trim().toLowerCase() == answerText.toLowerCase();
        return {'text': optText, 'isCorrect': isCorrect};
      }).toList();

      // Safety net: if the exact match above didn't mark anything correct
      // (e.g. trailing punctuation or wording drift between `answer` and
      // the matching option), try a looser containment match instead of
      // silently shipping a question with no correct option.
      final hasCorrect = options.any((o) => o['isCorrect'] == true);
      if (!hasCorrect && answerText != null && answerText.isNotEmpty) {
        final lowerAnswer = answerText.toLowerCase();
        for (final o in options) {
          final optLower = (o['text'] as String).trim().toLowerCase();
          if (optLower.isEmpty) continue;
          if (optLower.contains(lowerAnswer) || lowerAnswer.contains(optLower)) {
            o['isCorrect'] = true;
            break;
          }
        }
      }

      return {'text': text, 'options': options};
    }).toList();
  }
}