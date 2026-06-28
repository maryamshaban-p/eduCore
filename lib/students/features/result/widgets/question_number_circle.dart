import 'package:edulink_app/utils/app_colors.dart';
import 'package:edulink_app/utils/app_styles.dart';
import 'package:flutter/material.dart';

class QuestionNumberCircle extends StatelessWidget {
  final int number;
  final QuestionStatus status;

  const QuestionNumberCircle({
    super.key,
    required this.number,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    Color? bgColor;
    Border? border;
    Color textColor = Colors.white;

    switch (status) {
      case QuestionStatus.correct:
        bgColor = AppColors.deepGreen;
        break;
      case QuestionStatus.wrong:
        bgColor = AppColors.deepRed;
        break;
      case QuestionStatus.current:
        bgColor = null;
        border = Border.all(color: AppColors.deepRed, width: 2);
        textColor = AppColors.deepRed;
        break;
    }

    return Container(
      width: screenWidth * 0.10,
      height: screenWidth * 0.10,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bgColor,
        border: border,
        shape: BoxShape.circle,
      ),
      child: Text(
        '$number',
        style: AppStyles.whiteColor13.copyWith(
          color: textColor,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

enum QuestionStatus { correct, wrong, current }