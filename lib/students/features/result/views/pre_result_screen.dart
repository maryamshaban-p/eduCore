import 'package:easy_localization/easy_localization.dart';
import 'package:edulink_app/students/features/home/views/home_view_screen.dart';
import 'package:edulink_app/students/features/quiz/data/quiz_model.dart';
import 'package:edulink_app/students/features/result/views/result_view_screen.dart';
import 'package:edulink_app/students/shared_widgets/custom_elevated_button.dart';
import 'package:edulink_app/students/shared_widgets/request_reason_dialog.dart';
import 'package:edulink_app/utils/app_Asset.dart';
import 'package:edulink_app/utils/app_colors.dart';
import 'package:edulink_app/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class PreResultScreen extends StatelessWidget {
  final QuizResultModel result;
  final QuizModel quiz;
  final int sessionId;

  const PreResultScreen({
    super.key,
    required this.result,
    required this.quiz,
    required this.sessionId,
  });

  void _goHome(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const HomeViewScreen()),
      (route) => false,
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
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    final double confettiSize = screenWidth * 0.28;
    final double stackHeight = screenHeight * 0.30;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.02),

                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    onPressed: () => _goHome(context),
                    icon: const Icon(Icons.close_rounded),
                    tooltip: 'Home'.tr(),
                  ),
                ),

                SizedBox(height: screenHeight * 0.03),
                Center(
                  child: Column(
                    children: [
                      Image.asset(AppImages.graduate_cap_icon, width: screenWidth * 0.2),
                      SizedBox(height: screenHeight * 0.01),
                      Text('Quiz Result'.tr(), style: AppStyles.primary30.copyWith(fontSize: 26)),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),

                SizedBox(
                  height: stackHeight,
                  width: double.infinity,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      if (result.passed) ...[
                        Positioned(top: 0, left: 0,
                          child: Transform.rotate(angle: -math.pi / 4,
                            child: Image.asset(AppImages.pass_exam_celeberate, width: confettiSize, fit: BoxFit.contain))),
                        Positioned(top: 0, right: 0,
                          child: Transform.rotate(angle: math.pi / 4,
                            child: Image.asset(AppImages.pass_exam_celeberate, width: confettiSize, fit: BoxFit.contain))),
                        Positioned(bottom: 0, left: 0,
                          child: Transform.rotate(angle: math.pi / 3,
                            child: Image.asset(AppImages.pass_exam_celeberate, width: confettiSize, fit: BoxFit.contain))),
                        Positioned(bottom: 0, right: 0,
                          child: Transform.rotate(angle: -math.pi / 3,
                            child: Image.asset(AppImages.pass_exam_celeberate, width: confettiSize, fit: BoxFit.contain))),
                      ],

                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${result.percentage.toStringAsFixed(0)}%',
                              style: AppStyles.primary30.copyWith(fontSize: 52),
                            ),
                            SizedBox(height: screenHeight * 0.008),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(screenWidth * 0.015),
                                  decoration: BoxDecoration(

                                    color: result.passed ? AppColors.deepGreen : AppColors.deepRed,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    result.passed ? Icons.check : Icons.close,
                                    color: Colors.white,
                                    size: screenWidth * 0.05,
                                  ),
                                ),
                                SizedBox(width: screenWidth * 0.02),
                                Text(
                                  result.passed ? 'PASSED'.tr() : 'FAILED'.tr(),
                                  style: AppStyles.primary30.copyWith(
                                    color: result.passed ? AppColors.deepGreen : AppColors.deepRed,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: screenHeight * 0.06),
                Text(
                  'You got ${result.score} out of ${result.totalQuestions} correct answers'.tr(),
                  style: AppStyles.coalGray12.copyWith(fontSize: 17),
                ),
                SizedBox(height: screenHeight * 0.025),

                // ── No self-service retry: failing always requires a
                // teacher-approved retake request. ───────────────────────
                if (!result.passed)
                  Padding(
                    padding: EdgeInsets.only(bottom: screenHeight * 0.015),
                    child: Text(
                      'You can submit a request to retake this test.'.tr(),
                      style: TextStyle(color: AppColors.greyColor, fontSize: 13),
                      textAlign: TextAlign.center,
                    ),
                  ),

                if (result.passed)
                  CustomElevatedButton(
                    borderRadius: 16,
                    buttonHeight: screenHeight * 0.06,
                    buttonWidth: screenWidth * 0.9,
                    label: 'Show Result'.tr(),
                    bgColor: AppColors.primaryColor,
                    textColor: AppColors.whiteColor,
                    textStyle: AppStyles.whiteColor16,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ResultViewScreen(quiz: quiz, result: result),
                        ),
                      );
                    },
                  )
                else
                  CustomElevatedButton(
                    borderRadius: 16,
                    buttonHeight: screenHeight * 0.06,
                    buttonWidth: screenWidth * 0.9,
                    label: 'Request Retake'.tr(),
                    bgColor: Colors.orange.shade700,
                    textColor: AppColors.whiteColor,
                    textStyle: AppStyles.whiteColor16,
                    onPressed: () => _requestRetake(context),
                  ),

                SizedBox(height: screenHeight * 0.015),

                SizedBox(
                  width: screenWidth * 0.9,
                  height: screenHeight * 0.06,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.lightGray),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: () => _goHome(context),
                    child: Text('Home'.tr(),
                        style: TextStyle(fontSize: screenWidth * 0.04, color: Colors.black87)),
                  ),
                ),

                SizedBox(height: screenHeight * 0.15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}