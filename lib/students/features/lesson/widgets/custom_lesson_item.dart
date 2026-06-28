import 'package:edulink_app/utils/app_colors.dart';
import 'package:edulink_app/utils/app_styles.dart';
import 'package:flutter/material.dart';

class CustomLessonItem extends StatelessWidget {
  const CustomLessonItem({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.sessionName,
    required this.sessionDescription,
    this.onTap,
  });

  final double screenWidth;
  final double screenHeight;
  final String sessionName;
  final String sessionDescription;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.005),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.video_library, color: AppColors.primaryColor),
            SizedBox(width: screenWidth * 0.02),
            Column(
              children: [
                Text(sessionName, style: AppStyles.coalGray12.copyWith(fontWeight: FontWeight.w600, fontSize: 14)),
                SizedBox(height: screenHeight * 0.01),
                Text(sessionDescription, style: AppStyles.primary16.copyWith(fontWeight: FontWeight.w600, fontSize: 16)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}