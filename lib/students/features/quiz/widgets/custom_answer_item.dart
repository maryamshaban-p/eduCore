import 'package:edulink_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:edulink_app/utils/app_styles.dart';

class AnswerItem extends StatelessWidget {
  const AnswerItem({
    super.key,
    required this.text,
    required this.screenWidth,
    required this.screenHeight,
    this.isSelected = false,
    this.colorname,
    this.showCheck = false, 
  });

  final String text;
  final double screenWidth;
  final double screenHeight;
  final bool isSelected;
  final bool showCheck;
  final Color? colorname;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: screenHeight * 0.014),
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: colorname ?? const Color.fromARGB(255, 225, 234, 251),
        borderRadius: BorderRadius.circular(screenWidth * 0.03),
        border: Border.all(
          color: isSelected ? AppColors.mediumBlueColor : Colors.grey.shade300,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: AppStyles.black12.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ),
          ),

          if (showCheck)
            Container(
              width: screenWidth * 0.03,
              height: screenWidth * 0.03,
              decoration: BoxDecoration(
                color: AppColors.deepGreen,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.check,
                color: Colors.white,
                size: screenWidth * 0.03,
              ),
            ),

         
        ],
      ),
    );
  }
}