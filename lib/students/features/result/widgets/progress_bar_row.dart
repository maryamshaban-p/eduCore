import 'package:edulink_app/utils/app_colors.dart';
import 'package:edulink_app/utils/app_styles.dart';
import 'package:flutter/material.dart';

class ProgressBarRow extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final String label;

  const ProgressBarRow({
    super.key,
    required this.progress,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Row(
      children: [
        Expanded(
          child: Container(
            height: screenHeight * 0.008,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(screenWidth * 0.02),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.meduimBlue,
                  borderRadius: BorderRadius.circular(screenWidth * 0.02),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: screenWidth * 0.02),
        Text(label, style: AppStyles.black12),
      ],
    );
  }
}