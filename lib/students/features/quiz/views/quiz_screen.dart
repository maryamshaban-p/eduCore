import 'package:easy_localization/easy_localization.dart';
import 'package:edulink_app/students/features/quiz/cubit/quiz_cubit.dart';
import 'package:edulink_app/students/features/quiz/data/quiz_model.dart';
import 'package:edulink_app/students/features/quiz/data/quiz_repo.dart';
import 'package:edulink_app/students/features/quiz/widgets/custom_answer_item.dart';
import 'package:edulink_app/students/features/result/widgets/progress_bar_row.dart';
import 'package:edulink_app/students/features/result/views/pre_result_screen.dart';
import 'package:edulink_app/students/shared_widgets/custom_elevated_button.dart';
import 'package:edulink_app/utils/app_colors.dart';
import 'package:edulink_app/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuizScreen extends StatelessWidget {
  final int sessionId;
  final QuizModel quiz;

  const QuizScreen({super.key, required this.sessionId, required this.quiz});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => QuizCubit(QuizRepository(), sessionId)
        ..emit(QuizLoaded(quiz: quiz, currentIndex: 0, answers: {})),
      child: _QuizView(sessionId: sessionId),
    );
  }
}

class _QuizView extends StatelessWidget {
  final int sessionId;

  const _QuizView({required this.sessionId});

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return BlocConsumer<QuizCubit, QuizState>(
      listener: (context, state) {
        if (state is QuizSubmitted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => PreResultScreen(
                result: state.result,
                quiz: state.quiz,
                sessionId: sessionId,
              ),
            ),
          );
        }
        if (state is QuizError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        // While submitting (or before the quiz has loaded), show a simple
        // spinner — there's nothing useful to render from QuizSubmitting,
        // so we don't try to extract data out of it.
        if (state is! QuizLoaded) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final loaded = state;
        final question = loaded.quiz.questions[loaded.currentIndex];
        final total = loaded.quiz.questions.length;
        final progress = (loaded.currentIndex + 1) / total;
        final selectedOptionId = loaded.answers[question.questionId];
        final isLastQuestion = loaded.isLastQuestion;

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

                    Text(loaded.quiz.title,
                        style: TextStyle(fontSize: screenWidth * 0.06, fontWeight: FontWeight.bold)),

                    SizedBox(height: screenHeight * 0.02),

                    ProgressBarRow(
                      progress: progress,
                      label: '${((progress) * 100).toStringAsFixed(0)}%',
                    ),

                    SizedBox(height: screenHeight * 0.03),

                    Text('Question ${loaded.currentIndex + 1}/$total:', style: AppStyles.black15),

                    SizedBox(height: screenHeight * 0.015),

                    Text(question.text,
                        style: AppStyles.black12.copyWith(fontWeight: FontWeight.w400, fontSize: 15)),

                    SizedBox(height: screenHeight * 0.03),
                    ...question.options.map((option) {
                      return GestureDetector(
                        onTap: () => context.read<QuizCubit>().selectAnswer(question.questionId, option.optionId),
                        child: AnswerItem(
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                          text: option.text,
                          isSelected: selectedOptionId == option.optionId,
                        ),
                      );
                    }),

                    SizedBox(height: screenHeight * 0.06),
                    CustomElevatedButton(
                      borderRadius: 16,
                      buttonHeight: screenHeight * 0.06,
                      buttonWidth: screenWidth * 0.9,
                      label: isLastQuestion ? 'Submit'.tr() : 'Next'.tr(),
                      bgColor: AppColors.primaryColor,
                      textColor: AppColors.whiteColor,
                      textStyle: AppStyles.whiteColor16,
                      onPressed: () {
                        if (isLastQuestion) {
                          context.read<QuizCubit>().submitQuiz();
                        } else {
                          context.read<QuizCubit>().nextQuestion();
                        }
                      },
                    ),

                    SizedBox(height: screenHeight * 0.015),

                    if (loaded.currentIndex > 0)
                      SizedBox(
                        width: double.infinity,
                        height: screenHeight * 0.06,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: AppColors.lightGray),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(screenWidth * 0.04)),
                          ),
                          onPressed: () => context.read<QuizCubit>().previousQuestion(),
                          child: Text('Previous',
                              style: TextStyle(fontSize: screenWidth * 0.04, color: Colors.black87)),
                        ),
                      ),

                    SizedBox(height: screenHeight * 0.06),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}