import 'package:edulink_app/utils/app_styles.dart';
import 'package:flutter/material.dart';

enum LessonTab { lesson, tests, /*discuss*/ }

class CoursesTabsBar extends StatelessWidget {
  const CoursesTabsBar({
    super.key,
    required this.screenWidth,
    required this.selectedTab,
    required this.colorname,
    this.onTabChanged, 
  });

  final double screenWidth;
  final LessonTab selectedTab;
  final Color? colorname;
  final void Function(LessonTab tab)? onTabChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.02),
      decoration: BoxDecoration(
        color: colorname,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () => onTabChanged?.call(LessonTab.lesson),
            child: Text(
              'LESSON',
              style: selectedTab == LessonTab.lesson
                  ? AppStyles.primary20.copyWith(fontWeight: FontWeight.w600, fontSize: 16)
                  : AppStyles.lightGray16.copyWith(fontFamily: 'poppins', fontWeight: FontWeight.w400),
            ),
          ),
          GestureDetector(
            onTap: () => onTabChanged?.call(LessonTab.tests),
            child: Text(
              'TESTS',
              style: selectedTab == LessonTab.tests
                  ? AppStyles.primary20.copyWith(fontWeight: FontWeight.w600, fontSize: 16)
                  : AppStyles.lightGray16.copyWith(fontFamily: 'poppins', fontWeight: FontWeight.w400),
            ),
          ),
         /* GestureDetector(
            onTap: () => onTabChanged?.call(LessonTab.discuss),
            child: Text(
              'DISCUSS',
              style: selectedTab == LessonTab.discuss
                  ? AppStyles.primary16.copyWith(fontWeight: FontWeight.w600, fontSize: 16)
                  : AppStyles.lightGray16.copyWith(fontFamily: 'poppins', fontWeight: FontWeight.w400),
            ),
          ),*/
        ],
      ),
    );
  }
}