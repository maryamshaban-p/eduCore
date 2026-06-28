import 'package:edulink_app/students/features/result/widgets/question_number_circle.dart';
import 'package:flutter/material.dart';

class QuestionsGridRow extends StatelessWidget {
  final List<QuestionStatus> statuses;
  final int startIndex;

  const QuestionsGridRow({
    super.key,
    required this.statuses,
    required this.startIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        statuses.length,
        (i) => QuestionNumberCircle(
          number: startIndex + i,
          status: statuses[i],
        ),
      ),
    );
  }
}