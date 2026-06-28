// lib/students/features/lesson/views/lesson_view_screen.dart

import 'package:easy_localization/easy_localization.dart';
import 'package:edulink_app/students/features/quiz/data/quiz_model.dart';
import 'package:edulink_app/students/features/quiz/data/quiz_repo.dart';
import 'package:edulink_app/students/features/quiz/views/quiz_screen.dart';
import 'package:edulink_app/students/features/quiz/views/request_screen.dart';
import 'package:edulink_app/students/features/result/views/result_view_screen.dart';
import 'package:edulink_app/students/features/session/data/session_repo.dart';
import 'package:edulink_app/students/features/session_details/views/session_details_view_screen.dart';
import 'package:edulink_app/students/features/subject/cubit/subject_sessions_cubit.dart';
import 'package:edulink_app/students/features/subject/data/subject_repo.dart';
import 'package:edulink_app/students/shared_widgets/custom_course_tabsBar.dart';
import 'package:edulink_app/students/shared_widgets/request_reason_dialog.dart';
import 'package:edulink_app/utils/app_colors.dart';
import 'package:edulink_app/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LessonViewScreen extends StatelessWidget {
  final int courseId;
  final String courseTitle;
  final String teacherSubject;

  const LessonViewScreen({
    super.key,
    required this.courseId,
    required this.courseTitle,
    required this.teacherSubject,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          SubjectSessionsCubit(SubjectRepository(), courseId)..loadSessions(),
      child: _LessonView(
          courseTitle: courseTitle,
          teacherSubject: teacherSubject,
          courseId: courseId),
    );
  }
}

class _LessonView extends StatefulWidget {
  final String courseTitle;
  final String teacherSubject;
  final int courseId;

  const _LessonView(
      {required this.courseTitle,
      required this.teacherSubject,
      required this.courseId});

  @override
  State<_LessonView> createState() => _LessonViewState();
}

class _LessonViewState extends State<_LessonView> {
  LessonTab _selectedTab = LessonTab.lesson;
  final SessionRepository _sessionRepo = SessionRepository();

  // Guards against double taps triggering multiple detail fetches /
  // multiple loading dialogs at once.
  bool _isOpeningSession = false;

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: BlocBuilder<SubjectSessionsCubit, SubjectSessionsState>(
              builder: (context, state) {
                if (state is SubjectSessionsLoading ||
                    state is SubjectSessionsInitial) {
                  return SizedBox(
                    height: screenHeight * 0.5,
                    child: const Center(child: CircularProgressIndicator()),
                  );
                }

                if (state is SubjectSessionsError) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: Text(state.message,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red)),
                    ),
                  );
                }

                if (state is SubjectSessionsLoaded) {
                  final data = state.data;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: screenHeight * 0.02),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(Icons.arrow_back_outlined,
                                color: AppColors.lightBlueGray),
                          ),
                          /*SizedBox(width: screenWidth * 0.15),
                          Text(widget.teacherSubject,
                              style: AppStyles.lightBlueGray35
                                  .copyWith(fontSize: 22)),*/
                          const Spacer(),
                          // My Requests button
                          IconButton(
                            tooltip: 'My Requests'.tr(),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const RequestsScreen(),
                                ),
                              );
                            },
                            icon: Icon(Icons.inbox_outlined,
                                color: AppColors.lightBlueGray),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Center(
                          child: Text(widget.courseTitle,
                              style:
                                  AppStyles.primary30.copyWith(fontSize: 24))),
                      SizedBox(height: screenHeight * 0.04),

                      CoursesTabsBar(
                        screenWidth: screenWidth,
                        selectedTab: _selectedTab,
                        colorname: AppColors.whiteColor,
                        onTabChanged: (tab) =>
                            setState(() => _selectedTab = tab),
                      ),

                      SizedBox(height: screenHeight * 0.04),

                      if (_selectedTab == LessonTab.lesson) ...[
                        if (data.sessions.isEmpty)
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.05),
                            child: Center(
                              child: Text('No sessions yet'.tr(),
                                  style: TextStyle(
                                      color: AppColors.greyColor,
                                      fontSize: screenWidth * 0.04)),
                            ),
                          )
                        else
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.lightGray),
                            ),
                            child: Column(
                              children: [
                                SizedBox(height: screenHeight * 0.02),
                                for (int i = 0;
                                    i < data.sessions.length;
                                    i++) ...[
                                  _buildSessionLessonItem(
                                    context: context,
                                    data: data,
                                    index: i,
                                    screenWidth: screenWidth,
                                    screenHeight: screenHeight,
                                  ),
                                  if (i != data.sessions.length - 1) ...[
                                    Divider(color: AppColors.lightGrayBlue),
                                    SizedBox(height: screenHeight * 0.02),
                                  ] else
                                    SizedBox(height: screenHeight * 0.02),
                                ],
                              ],
                            ),
                          ),
                      ] else ...[
                        Builder(builder: (_) {
                          final testSessions = data.sessions
                              .where((s) => s.hasEntryTest)
                              .toList();
                          if (testSessions.isEmpty) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: screenHeight * 0.05),
                              child: Center(
                                child: Text('No tests available'.tr(),
                                    style: TextStyle(
                                        color: AppColors.greyColor,
                                        fontSize: screenWidth * 0.04)),
                              ),
                            );
                          }
                          return Column(
                            children: testSessions
                                .map((s) => _TestCard(
                                      session: s,
                                      courseId: widget.courseId,
                                      courseTitle: widget.courseTitle,
                                      teacherSubject: widget.teacherSubject,
                                      screenWidth: screenWidth,
                                      screenHeight: screenHeight,
                                    ))
                                .toList(),
                          );
                        }),
                      ],
                    ],
                  );
                }

                return const SizedBox();
              },
            ),
          ),
        ),
      ),
    );
  }

  // ── Open a session ────────────────────────────────────────────────────
  // The /course/{courseId}/sessions list endpoint only returns lightweight
  // summary fields (id, title, isLocked, views, testPassed...) and does
  // NOT include `files`. So before opening SessionDetailsViewScreen we
  // fetch the full lesson payload from /lesson/{id}/details, which does
  // include `files` (and therefore the actual video).
  Future<void> _openSession(
    BuildContext context,
    int sessionId,
    String courseIntroduction,
    String? coursePictureUrl,
  ) async {
    if (_isOpeningSession) return;
    setState(() => _isOpeningSession = true);

    // Small loading indicator while we fetch the details.
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final details = await _sessionRepo.getLessonDetails(sessionId);

      if (!context.mounted) return;
      Navigator.pop(context); // close loading dialog

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SessionDetailsViewScreen(
            sessionId: sessionId,
            courseTitle: widget.courseTitle,
            lessonTitle: details.title,
            courseIntroduction: courseIntroduction,
            coursePictureUrl: coursePictureUrl,
            sessionFiles: details.files,
            hasHomework: details.homeworkFileUrl != null ||
                details.homeworkFileName != null,
            homeworkFileUrl: details.homeworkFileUrl,
            homeworkFileName: details.homeworkFileName,
            hasEntryTest: details.hasEntryTest,
          ),
        ),
      );

      if (context.mounted) {
        context.read<SubjectSessionsCubit>().loadSessions();
      }
    } catch (e) {
      if (!context.mounted) return;
      Navigator.pop(context); // close loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isOpeningSession = false);
    }
  }

  // ── Build a single lesson list item, combining the two lock reasons ──
  // 1) Cross-session sequencing lock (session.isLocked, set by the backend
  //    based on the previous session's test result).
  // 2) Same-session entry-test lock: this session has an entry test
  //    (hasEntryTest) that hasn't been passed yet (testPassed == false).
  //    The lesson content stays locked until that test is passed, even
  //    though the test itself is always reachable from the TESTS tab.
  Widget _buildSessionLessonItem({
    required BuildContext context,
    required dynamic data,
    required int index,
    required double screenWidth,
    required double screenHeight,
  }) {
    final session = data.sessions[index];
    final bool crossSessionLocked = session.isLocked as bool;
    final bool entryTestRequired =
        session.hasEntryTest as bool && !(session.testPassed as bool);
    final bool locked = crossSessionLocked || entryTestRequired;

    return _SessionLessonItem(
      session: session,
      index: index,
      locked: locked,
      screenWidth: screenWidth,
      screenHeight: screenHeight,
      courseTitle: widget.courseTitle,
      introduction: data.introduction,
      pictureUrl: data.pictureUrl,
      onTap: () {
        if (locked) {
          _showSessionLockedDialog(
            context,
            // If both reasons apply, lead with the cross-session one since
            // it's the one the student needs to resolve first.
            entryTestRequired: entryTestRequired && !crossSessionLocked,
          );
          return;
        }
        if (!session.hasViewsRemaining) {
          _showNoViewsDialog(context, session.sessionId);
          return;
        }
        _openSession(
          context,
          session.sessionId,
          data.introduction,
          data.pictureUrl,
        );
      },
    );
  }

  void _showSessionLockedDialog(BuildContext context,
      {required bool entryTestRequired}) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.lock_outline, color: AppColors.greyColor, size: 22),
            const SizedBox(width: 8),
            Text('Session Locked'.tr(), style: const TextStyle(fontSize: 17)),
          ],
        ),
        content: Text(
          entryTestRequired
              ? 'Pass this session\'s test to unlock the lesson.'.tr()
              : 'Complete the previous session and pass its test to unlock this one.'
                  .tr(),
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => Navigator.pop(ctx),
            child:
                Text('OK'.tr(), style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ── Views request dialog (uses the shared widget) ────────────────────
  // The sessionId is always supplied by the caller, so the student never
  // needs to know or type it manually.
  Future<void> _showNoViewsDialog(BuildContext context, int sessionId) async {
    final submitted = await showRequestReasonDialog(
      context: context,
      sessionId: sessionId,
      type: RequestReasonType.views,
      title: 'No Views Left'.tr(),
      description:
          'You have used all your views for this session. Tell us why you need more.'
              .tr(),
    );

    if (submitted == true && context.mounted) {
      showRequestSubmittedSnackbar(context);
    }
  }
}

// ── Session Lesson Item with lock & views indicator ──────────────────────────
class _SessionLessonItem extends StatelessWidget {
  final dynamic session;
  final int index;
  final bool locked;
  final double screenWidth;
  final double screenHeight;
  final String courseTitle;
  final String introduction;
  final String? pictureUrl;
  final VoidCallback? onTap;

  const _SessionLessonItem({
    required this.session,
    required this.index,
    required this.locked,
    required this.screenWidth,
    required this.screenHeight,
    required this.courseTitle,
    required this.introduction,
    required this.pictureUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isLocked = locked;
    final int views = session.views as int;
    final int maxViews = session.maxViews as int;
    final int remaining = (maxViews - views).clamp(0, maxViews);
    final bool noViewsLeft = remaining == 0 && !isLocked;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
            vertical: screenHeight * 0.008),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon
            Icon(
              isLocked
                  ? Icons.lock_outline
                  : noViewsLeft
                      ? Icons.videocam_off_outlined
                      : Icons.video_library,
              color: isLocked
                  ? AppColors.greyColor
                  : noViewsLeft
                      ? Colors.orange.shade600
                      : AppColors.primaryColor,
            ),
            SizedBox(width: screenWidth * 0.03),

            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Session ${index + 1}'.tr(),
                    style: AppStyles.coalGray12.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: isLocked
                            ? AppColors.greyColor
                            : null),
                  ),
                  SizedBox(height: screenHeight * 0.004),
                  Text(
                    session.title as String,
                    style: AppStyles.primary16.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: isLocked ? AppColors.greyColor : null),
                  ),
                ],
              ),
            ),

            // Right side: lock icon OR views badge
            if (isLocked)
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.greyColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Locked'.tr(),
                  style: TextStyle(
                      color: AppColors.greyColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w600),
                ),
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: noViewsLeft
                      ? Colors.orange.withOpacity(0.12)
                      : AppColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.visibility_outlined,
                      size: 12,
                      color: noViewsLeft
                          ? Colors.orange.shade700
                          : AppColors.primaryColor,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      '$views/$maxViews',
                      style: TextStyle(
                          color: noViewsLeft
                              ? Colors.orange.shade700
                              : AppColors.primaryColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ── Test Card ──────────────────────────────────────────────────────────────
// Policy: there is no self-service retry after a failed attempt. Once a
// student fails, they must submit a "Request Retake" and wait for teacher
// approval before they can attempt the quiz again. Review is only ever
// available for a passed attempt.
class _TestCard extends StatelessWidget {
  final dynamic session;
  final int courseId;
  final String courseTitle;
  final String teacherSubject;
  final double screenWidth;
  final double screenHeight;

  const _TestCard({
    required this.session,
    required this.courseId,
    required this.courseTitle,
    required this.teacherSubject,
    required this.screenWidth,
    required this.screenHeight,
  });

  Future<void> _requestRetake(BuildContext context, int sessionId) async {
    final submitted = await showRequestReasonDialog(
      context: context,
      sessionId: sessionId,
      type: RequestReasonType.retake,
    );
    if (submitted == true && context.mounted) {
      showRequestSubmittedSnackbar(context);
    }
  }

  // Goes straight into the quiz/review instead of routing through the
  // intermediate "test card" screen — that screen only re-fetched the same
  // quiz and showed a single BEGIN/REVIEW button, which was a redundant
  // extra tap (and the source of stale/placeholder data showing up there).
  Future<void> _openQuizDirect(BuildContext context, int sessionId) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final quiz = await QuizRepository().getQuiz(sessionId);
      if (!context.mounted) return;
      Navigator.pop(context); // close loading dialog

      if (quiz.alreadyPassed) {
        if (quiz.lastBreakdown == null || quiz.questions.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('Review is not available for this attempt yet.'.tr()),
            ),
          );
          return;
        }
        final result = QuizResultModel(
          score: quiz.lastBreakdown!.where((b) => b.isCorrect).length,
          totalQuestions: quiz.questions.length,
          percentage: quiz.lastScore ?? 0,
          passed: quiz.alreadyPassed,
          breakdown: quiz.lastBreakdown!,
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ResultViewScreen(quiz: quiz, result: result),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => QuizScreen(sessionId: sessionId, quiz: quiz),
          ),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      Navigator.pop(context); // close loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isLocked = session.isLocked as bool;
    final bool testPassed = session.testPassed as bool;
    final double? bestScore = session.entryTestBestScore as double?;
    final bool hasFailedAttempt = !testPassed && bestScore != null;
    final int sessionId = session.sessionId as int;

    VoidCallback? onTap;
    if (isLocked) {
      onTap = () => _showLockedDialog(context);
    } else if (hasFailedAttempt) {
      // Any failed attempt always requires a retake request — no direct
      // re-entry into the quiz.
      onTap = () => _requestRetake(context, sessionId);
    } else {
      // First attempt (never taken) or already passed -> go straight to the
      // quiz / review screen, skipping the redundant middle page.
      onTap = () => _openQuizDirect(context, sessionId);
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: screenHeight * 0.015),
        padding: EdgeInsets.all(screenWidth * 0.04),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(screenWidth * 0.04),
          border: Border.all(
            color: isLocked ? AppColors.greyColor.withOpacity(0.3) : AppColors.lightGray,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isLocked
                  ? Icons.lock_outline
                  : hasFailedAttempt
                      ? Icons.replay_outlined
                      : Icons.quiz_outlined,
              color: isLocked
                  ? AppColors.greyColor
                  : hasFailedAttempt
                      ? Colors.orange.shade700
                      : AppColors.blueColor,
              size: screenWidth * 0.08,
            ),
            SizedBox(width: screenWidth * 0.03),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(session.title as String,
                      style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.w600,
                          color: isLocked ? AppColors.greyColor : null)),
                  if (testPassed)
                    Text(
                      'Passed'.tr(),
                      style: TextStyle(
                          color: AppColors.greenColor,
                          fontSize: screenWidth * 0.032),
                    )
                  else if (!isLocked && hasFailedAttempt)
                    // Failed — show score, no review, must request a retake
                    Row(
                      children: [
                        Text(
                          '${'Last'.tr()}: ${bestScore!.toStringAsFixed(0)}%',
                          style: TextStyle(
                              color: AppColors.deepRed,
                              fontSize: screenWidth * 0.032),
                        ),
                        SizedBox(width: screenWidth * 0.02),
                        Text(
                          'Tap to request a retake'.tr(),
                          style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: screenWidth * 0.03,
                              decoration: TextDecoration.underline),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            if (isLocked)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.greyColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('Locked'.tr(),
                    style: TextStyle(
                        color: AppColors.greyColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w600)),
              )
            else
              Icon(Icons.arrow_forward_ios_rounded,
                  size: screenWidth * 0.04, color: AppColors.greyColor),
          ],
        ),
      ),
    );
  }

  void _showLockedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.lock_outline, color: AppColors.greyColor, size: 22),
            const SizedBox(width: 8),
            Text('Session Locked'.tr(),
                style: const TextStyle(fontSize: 17)),
          ],
        ),
        content: Text(
          'Complete the previous session and pass its test to unlock this one.'
              .tr(),
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => Navigator.pop(ctx),
            child: Text('OK'.tr(),
                style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}