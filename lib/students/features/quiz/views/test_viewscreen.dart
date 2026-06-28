// lib/students/features/quiz/views/test_viewscreen.dart

import 'package:easy_localization/easy_localization.dart';
import 'package:edulink_app/students/features/lesson/widgets/custom_lesson_or_test_name.dart';
import 'package:edulink_app/students/features/quiz/cubit/quiz_cubit.dart';
import 'package:edulink_app/students/features/quiz/data/quiz_model.dart';
import 'package:edulink_app/students/features/quiz/data/quiz_repo.dart';
import 'package:edulink_app/students/features/quiz/views/quiz_screen.dart';
import 'package:edulink_app/students/features/result/views/result_view_screen.dart';
import 'package:edulink_app/students/shared_widgets/custom_course_tabsBar.dart';
import 'package:edulink_app/students/shared_widgets/custom_elevated_button.dart';
import 'package:edulink_app/students/shared_widgets/request_reason_dialog.dart';
import 'package:edulink_app/utils/app_Asset.dart';
import 'package:edulink_app/utils/app_colors.dart';
import 'package:edulink_app/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TestsScreen extends StatelessWidget {
  final int sessionId;
  final String courseTitle;
  final String teacherSubject;

  const TestsScreen({
    super.key,
    required this.sessionId,
    required this.courseTitle,
    required this.teacherSubject,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => QuizCubit(QuizRepository(), sessionId)..loadQuiz(),
      child: _TestsView(
          courseTitle: courseTitle,
          teacherSubject: teacherSubject,
          sessionId: sessionId),
    );
  }
}

class _TestsView extends StatelessWidget {
  final int sessionId;
  final String courseTitle;
  final String teacherSubject;

  const _TestsView(
      {required this.courseTitle,
      required this.teacherSubject,
      required this.sessionId});

  void _openReview(BuildContext context, QuizModel quiz) {
    if (quiz.lastBreakdown == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Review is not available for this attempt yet.'.tr()),
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
  }

  Future<void> _requestRetake(BuildContext context) async {
    final submitted = await showRequestReasonDialog(
      context: context,
      sessionId: sessionId,
      type: RequestReasonType.retake,
    );
    if (submitted == true && context.mounted) {
      showRequestSubmittedSnackbar(context);
      // Refresh quiz state in case the request affects display (e.g. a
      // teacher had already approved a previous request).
      context.read<QuizCubit>().loadQuiz();
    }
  }

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.02),
                Custom_Lesson_orTest_name(
                    screenWidth: screenWidth, name: teacherSubject),
                SizedBox(height: screenHeight * 0.02),
                Center(
                    child: Text(courseTitle,
                        style: AppStyles.primary30.copyWith(fontSize: 26))),
                SizedBox(height: screenHeight * 0.06),
                CoursesTabsBar(
                    screenWidth: screenWidth,
                    selectedTab: LessonTab.tests,
                    colorname: AppColors.whiteColor),
                SizedBox(height: screenHeight * 0.06),

                BlocBuilder<QuizCubit, QuizState>(
                  builder: (context, state) {
                    if (state is QuizLoading || state is QuizInitial) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is QuizError) {
                      if (state.message.contains('No quiz') ||
                          state.message.contains('No test')) {
                        return Column(
                          children: [
                            Image.asset(AppImages.empty_image,
                                width: screenWidth),
                            SizedBox(height: screenHeight * 0.02),
                            Text('No test available'.tr(),
                                style:
                                    AppStyles.coalGray.copyWith(fontSize: 22)),
                          ],
                        );
                      }
                      // Session locked
                      if (state.message.contains('locked')) {
                        return _LockedTestWidget(
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                        );
                      }
                      return Center(
                          child: Text(state.message,
                              style: const TextStyle(color: Colors.red),
                              textAlign: TextAlign.center));
                    }

                    if (state is QuizLoaded) {
                      final quiz = state.quiz;

                      // ── Determine button state ──────────────────────────
                      // Policy: only a PASSED attempt unlocks REVIEW. Any
                      // failed attempt (no matter how long ago, no matter
                      // whether canRetakeAt has elapsed) requires a teacher-
                      // approved "Request Retake" before the student can
                      // attempt the quiz again. Only a true first attempt
                      // (never taken) gets a free BEGIN.
                      final bool canReview = quiz.alreadyPassed;
                      final bool hasPreviousAttempt = quiz.lastScore != null;
                      final bool hasFailed =
                          hasPreviousAttempt && !quiz.alreadyPassed;
                      final bool isBlocked = quiz.canRetakeAt != null &&
                          quiz.canRetakeAt!.isAfter(DateTime.now());

                      String buttonLabel;
                      Color buttonColor;
                      VoidCallback? buttonAction;

                      if (canReview) {
                        buttonLabel = 'REVIEW'.tr();
                        buttonColor = AppColors.deepBlue;
                        buttonAction = () => _openReview(context, quiz);
                      } else if (hasFailed) {
                        // No self-service retry after a failure — always
                        // go through a retake request, whether or not the
                        // cool-down window has passed.
                        buttonLabel = 'Request Retake'.tr();
                        buttonColor = Colors.orange.shade700;
                        buttonAction = () => _requestRetake(context);
                      } else {
                        // True first attempt
                        buttonLabel = 'BEGIN'.tr();
                        buttonColor = AppColors.deepBlue;
                        buttonAction = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => QuizScreen(
                                sessionId: sessionId,
                                quiz: quiz,
                              ),
                            ),
                          ).then((_) {
                            if (context.mounted) {
                              context.read<QuizCubit>().loadQuiz();
                            }
                          });
                        };
                      }

                      return Container(
                        padding: EdgeInsets.all(screenWidth * 0.05),
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CircleAvatar(
                              radius: 35,
                              backgroundImage:
                                  AssetImage('assets/images/quiz_logo.jpg'),
                            ),
                            SizedBox(width: screenWidth * 0.04),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(quiz.title,
                                      style: AppStyles.coalGray12.copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16)),
                                  SizedBox(height: screenHeight * 0.008),
                                  Text(
                                      '${quiz.questions.length} ${'Questions'.tr()}',
                                      style: AppStyles.black12.copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15)),
                                  SizedBox(height: screenHeight * 0.005),
                                  Text(
                                      '${'Passing score'.tr()}: ${quiz.passingScore.toStringAsFixed(0)}%',
                                      style: AppStyles.coalGray
                                          .copyWith(fontSize: 13)),

                                  // ── Score / status row ─────────────────
                                  if (quiz.alreadyPassed) ...[
                                    SizedBox(height: screenHeight * 0.008),
                                    Row(
                                      children: [
                                        Icon(Icons.check_circle,
                                            color: AppColors.deepGreen,
                                            size: screenWidth * 0.045),
                                        SizedBox(width: screenWidth * 0.01),
                                        Text(
                                            '${'Passed'.tr()} • ${quiz.lastScore?.toStringAsFixed(0)}%',
                                            style: TextStyle(
                                                color: AppColors.deepGreen,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600)),
                                      ],
                                    ),
                                  ] else if (hasFailed) ...[
                                    SizedBox(height: screenHeight * 0.008),
                                    Row(
                                      children: [
                                        Icon(Icons.cancel_outlined,
                                            color: AppColors.deepRed,
                                            size: screenWidth * 0.045),
                                        SizedBox(width: screenWidth * 0.01),
                                        Text(
                                            '${'Last score'.tr()}: ${quiz.lastScore?.toStringAsFixed(0)}%',
                                            style: TextStyle(
                                                color: AppColors.deepRed,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600)),
                                      ],
                                    ),
                                    // Review NOT available for failed attempts
                                    SizedBox(height: screenHeight * 0.005),
                                    Text(
                                      'Review is only available after passing.'
                                          .tr(),
                                      style: TextStyle(
                                          color: AppColors.greyColor,
                                          fontSize: 12),
                                    ),

                                    // Informational note about the cool-down
                                    // window, if any — but it's just text now,
                                    // never a path to a free retry.
                                    if (isBlocked) ...[
                                      SizedBox(height: screenHeight * 0.008),
                                      Row(
                                        children: [
                                          Icon(Icons.timer_outlined,
                                              size: 14,
                                              color: Colors.orange.shade700),
                                          const SizedBox(width: 4),
                                          Text(
                                              '${'Retake requests open at'.tr()}: ${_formatTime(quiz.canRetakeAt!)}',
                                              style: TextStyle(
                                                  color: Colors.orange.shade700,
                                                  fontSize: 12)),
                                        ],
                                      ),
                                    ],
                                  ],

                                  SizedBox(height: screenHeight * 0.015),

                                  // ── Action row ─────────────────────────
                                  CustomElevatedButton(
                                    buttonHeight: screenHeight * 0.05,
                                    buttonWidth: screenWidth * 0.4,
                                    label: buttonLabel,
                                    bgColor: buttonColor,
                                    textColor: AppColors.whiteColor,
                                    textStyle: AppStyles.whiteColor13,
                                    onPressed: buttonAction ?? () {},
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return const SizedBox();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final local = dt.toLocal();
    return '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')} - ${local.day}/${local.month}';
  }
}

// ── Locked Session Widget ────────────────────────────────────────────────────
class _LockedTestWidget extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;

  const _LockedTestWidget(
      {required this.screenWidth, required this.screenHeight});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.lock_outline, size: 64, color: AppColors.greyColor),
          SizedBox(height: screenHeight * 0.02),
          Text(
            'Session Locked'.tr(),
            style: AppStyles.coalGray.copyWith(
                fontSize: 20, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: screenHeight * 0.01),
          Text(
            'Complete the previous session and pass its test to unlock this one.'
                .tr(),
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.greyColor, fontSize: 14),
          ),
        ],
      ),
    );
  }
}