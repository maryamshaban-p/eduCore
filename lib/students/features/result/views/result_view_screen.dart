import 'package:easy_localization/easy_localization.dart';
import 'package:edulink_app/students/features/quiz/data/quiz_model.dart';
import 'package:edulink_app/students/features/quiz/widgets/custom_answer_item.dart';
import 'package:edulink_app/students/features/result/widgets/progress_bar_row.dart';
import 'package:edulink_app/students/features/result/widgets/question_number_circle.dart';
import 'package:edulink_app/students/features/result/widgets/questions_grid_row.dart';
import 'package:edulink_app/utils/app_styles.dart';
import 'package:flutter/material.dart';

class ResultViewScreen extends StatefulWidget {
  final QuizModel quiz;
  final QuizResultModel result;

  const ResultViewScreen({super.key, required this.quiz, required this.result});

  @override
  State<ResultViewScreen> createState() => _ResultViewScreenState();
}

class _ResultViewScreenState extends State<ResultViewScreen> {
  int _currentQuestionIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final questions = widget.quiz.questions;
    final breakdown = widget.result.breakdown;
    final total = questions.length;

    final question = questions[_currentQuestionIndex];
    final breakdownItem = breakdown.firstWhere(
      (b) => b.questionId == question.questionId,
      orElse: () => QuizBreakdownItem(questionId: question.questionId, isCorrect: false),
    );

    final progress = (_currentQuestionIndex + 1) / total;

    List<QuestionStatus> _buildStatuses(int startIndex, int count) {
      return List.generate(count, (i) {
        final idx = startIndex + i;
        if (idx >= total) return QuestionStatus.correct;
        final q = questions[idx];
        final b = breakdown.firstWhere((b) => b.questionId == q.questionId,
            orElse: () => QuizBreakdownItem(questionId: q.questionId, isCorrect: false));
        if (idx == _currentQuestionIndex) return QuestionStatus.current;
        return b.isCorrect ? QuestionStatus.correct : QuestionStatus.wrong;
      });
    }

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
                Row(children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_rounded),
                  ),
                  Text(widget.quiz.title,
                      style: TextStyle(fontSize: screenWidth * 0.055, fontWeight: FontWeight.bold)),
                ]),

                SizedBox(height: screenHeight * 0.02),

                ProgressBarRow(
                  progress: progress,
                  label: '${(progress * 100).toStringAsFixed(0)}%',
                ),

                SizedBox(height: screenHeight * 0.03),

                Text('Question ${_currentQuestionIndex + 1}/$total:', style: AppStyles.black15),

                SizedBox(height: screenHeight * 0.015),

                Text(question.text,
                    style: AppStyles.black12.copyWith(fontWeight: FontWeight.w400, fontSize: 15)),

                SizedBox(height: screenHeight * 0.03),

                ...question.options.map((option) {
                  final isCorrect = option.optionId == breakdownItem.correctOptionId;
                  final isSelected = option.optionId == breakdownItem.selectedOptionId;
                  final isWrongSelected = isSelected && !isCorrect;

                  Color? color;
                  if (isCorrect) color = const Color.fromARGB(255, 186, 219, 201);
                  if (isWrongSelected) color = const Color.fromARGB(255, 240, 202, 202);

                  return AnswerItem(
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                    text: option.text,
                    isSelected: isSelected,
                    colorname: color,
                    showCheck: isCorrect,
                  );
                }),

                SizedBox(height: screenHeight * 0.06),

                Row(
                  children: [
                    if (_currentQuestionIndex > 0)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => setState(() => _currentQuestionIndex--),
                          child:  Text('Previous'.tr()),
                        ),
                      ),
                    if (_currentQuestionIndex > 0) SizedBox(width: screenWidth * 0.03),
                    if (_currentQuestionIndex < total - 1)
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => setState(() => _currentQuestionIndex++),
                          child:  Text('Next'.tr()),
                        ),
                      ),
                  ],
                ),

                SizedBox(height: screenHeight * 0.04),

                if (total <= 10)
                  QuestionsGridRow(startIndex: 1, statuses: _buildStatuses(0, total))
                else ...[
                  QuestionsGridRow(startIndex: 1, statuses: _buildStatuses(0, 5)),
                  SizedBox(height: screenHeight * 0.02),
                  QuestionsGridRow(startIndex: 6, statuses: _buildStatuses(5, total - 5)),
                ],

                SizedBox(height: screenHeight * 0.04),
              ],
            ),
          ),
        ),
      ),
    );
  }
}