import 'package:easy_localization/easy_localization.dart';
import 'package:edulink_app/utils/app_colors.dart';
import 'package:edulink_app/utils/app_styles.dart';
import 'package:flutter/material.dart';

class custom_lessonItem extends StatelessWidget {
  const custom_lessonItem({
    super.key,
    required this.w,
    required this.h,
    required this.title,
    required this.teacher,
    required this.progressPercent,
    this.onTap,
  });

  final double w;
  final double h;
  final String title;
  final String teacher;
  final double progressPercent;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final progress = progressPercent.clamp(0, 100) / 100;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(w * 0.04),
      child: Container(
        margin: EdgeInsets.only(bottom: h * 0.02),
        padding: EdgeInsets.all(w * 0.04),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(w * 0.04),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: w * 0.13,
                  height: w * 0.13,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(w * 0.03),
                  ),
                  child: Icon(Icons.menu_book, color: AppColors.blueColor, size: w * 0.07),
                ),
                SizedBox(width: w * 0.04),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: TextStyle(fontSize: w * 0.043, fontWeight: FontWeight.w600)),
                      Text(teacher, style: TextStyle(fontSize: w * 0.035, color: AppColors.greyColor)),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: h * 0.015),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Progress".tr(), style: AppStyles.black12.copyWith(fontSize: 13)),
                Text("$progressPercent%", style: AppStyles.blueColor.copyWith(fontSize: w * 0.038)),
              ],
            ),
            SizedBox(height: h * 0.01),
            Container(
              height: h * 0.008,
              decoration: BoxDecoration(
                color: AppColors.greyColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(w * 0.02),
              ),
              child: FractionallySizedBox(
                widthFactor: progress.toDouble(),
                alignment: Alignment.centerLeft,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.blueColor,
                    borderRadius: BorderRadius.circular(w * 0.02),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}