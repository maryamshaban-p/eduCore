import 'package:easy_localization/easy_localization.dart';
import 'package:edulink_app/students/features/session_details/widgets/course_image.dart';
import 'package:edulink_app/students/features/session_details/widgets/lesson_video_player.dart';
import 'package:edulink_app/students/features/session_details/widgets/file_card.dart';
import 'package:edulink_app/students/features/subject/data/subject_model.dart';
import 'package:edulink_app/students/features/session_details/cubit/session_details_cubit.dart';
import 'package:edulink_app/students/features/session/data/session_repo.dart';
import 'package:edulink_app/students/features/session_details/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class SessionDetailsViewScreen extends StatelessWidget {
  final int sessionId;
  final String courseTitle;
  final String lessonTitle;
  final String courseIntroduction;
  final String? coursePictureUrl;
  final List<SessionFile> sessionFiles;
  final bool hasHomework;
  final String? homeworkFileUrl;
  final String? homeworkFileName;
  final bool hasEntryTest;

  const SessionDetailsViewScreen({
    super.key,
    required this.sessionId,
    required this.courseTitle,
    required this.lessonTitle,
    required this.courseIntroduction,
    this.coursePictureUrl,
    required this.sessionFiles,
    required this.hasHomework,
    this.homeworkFileUrl,
    this.homeworkFileName,
    required this.hasEntryTest,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SessionDetailsCubit(SessionRepository(), sessionId)..loadHomework(),
      child: _SessionDetailsView(
        sessionId: sessionId,
        courseTitle: courseTitle,
        lessonTitle: lessonTitle,
        courseIntroduction: courseIntroduction,
        coursePictureUrl: coursePictureUrl,
        sessionFiles: sessionFiles,
        hasHomework: hasHomework,
        homeworkFileUrl: homeworkFileUrl,
        homeworkFileName: homeworkFileName,
        hasEntryTest: hasEntryTest,
      ),
    );
  }
}

class _SessionDetailsView extends StatelessWidget {
  final int sessionId;
  final String courseTitle;
  final String lessonTitle;
  final String courseIntroduction;
  final String? coursePictureUrl;
  final List<SessionFile> sessionFiles;
  final bool hasHomework;
  final String? homeworkFileUrl;
  final String? homeworkFileName;
  final bool hasEntryTest;

  const _SessionDetailsView({
    required this.sessionId,
    required this.courseTitle,
    required this.lessonTitle,
    required this.courseIntroduction,
    this.coursePictureUrl,
    required this.sessionFiles,
    required this.hasHomework,
    this.homeworkFileUrl,
    this.homeworkFileName,
    required this.hasEntryTest,
  });

  bool _isVideo(SessionFile file) {
    final type = file.fileType.toLowerCase();
    return type.contains('video') || type == 'mp4' || type == 'mov';
  }

  Future<void> _openFile(BuildContext context, String relativeUrl) async {
    final fullUrl = AppConfig.resolveUrl(relativeUrl);
    final uri = Uri.tryParse(fullUrl);

    if (uri == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text('Invalid file link.'.tr()), backgroundColor: Colors.red),
        );
      }
      return;
    }

    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text('Could not open the file.'.tr()), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final videoFile = sessionFiles.where(_isVideo).isNotEmpty
        ? sessionFiles.where(_isVideo).first
        : null;
    final otherFiles = sessionFiles.where((f) => !_isVideo(f)).toList();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Header(),
                const SizedBox(height: 12),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        '$courseTitle > $lessonTitle',
                        style: const TextStyle(color: Color(0xFF055092)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF055092).withOpacity(0.08),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '#$sessionId',
                        style: const TextStyle(
                          color: Color(0xFF055092),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // ✅ UPDATED: PASS sessionId to LessonVideoPlayer
                if (videoFile != null)
                  LessonVideoPlayer(
                    videoUrl: AppConfig.resolveUrl(videoFile.fileUrl),
                    sessionId: sessionId,
                  )
                else
                  CourseImageWidget(pictureUrl: coursePictureUrl),

                const SizedBox(height: 16),
                if (courseIntroduction.isNotEmpty) ...[
                   Text('Introduction'.tr(),
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(courseIntroduction,
                      style: const TextStyle(fontSize: 15, height: 1.5)),
                  const SizedBox(height: 20),
                ],

                if (otherFiles.isNotEmpty) ...[
                   Text('Lesson Files'.tr(),
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ...otherFiles.map((file) => FileCard(
                        file: file,
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                        onTap: () => _openFile(context, file.fileUrl),
                      )),
                  const SizedBox(height: 12),
                ],

                if (hasHomework && homeworkFileUrl != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      onTap: () => _openFile(context, homeworkFileUrl!),
                      child: ListTile(
                        leading: const Icon(Icons.picture_as_pdf, size: 40, color: Colors.red),
                        title:  Text('Homework'.tr(),
                            style: TextStyle(color: Color(0xFF5C5C5C), fontSize: 16)),
                        subtitle: Text(
                          homeworkFileName ?? 'Homework File'.tr(),
                          style: const TextStyle(color: Color(0xFF012D54), fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        trailing: const Icon(Icons.open_in_new_rounded, size: 22, color: Color(0xFF055092)),
                      ),
                    ),
                  ),
                ] else if (hasHomework && homeworkFileUrl == null) ...[
                  Container(
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                    child:  ListTile(
                      leading: Icon(Icons.description_outlined, size: 40, color: Color(0xFF055092)),
                      title: Text('Homework'.tr(), style: TextStyle(color: Color(0xFF5C5C5C), fontSize: 16)),
                      subtitle: Text('No homework file yet'.tr(), style: TextStyle(color: Color(0xFF012D54), fontSize: 16)),
                    ),
                  ),
                ],

                SizedBox(height: screenHeight * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }
}