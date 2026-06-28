import 'package:easy_localization/easy_localization.dart';
import 'package:edulink_app/students/features/lesson/widgets/custom_lesson_or_test_name.dart';
import 'package:edulink_app/students/shared_widgets/custom_course_tabsBar.dart';
import 'package:edulink_app/utils/app_Asset.dart';
import 'package:edulink_app/utils/app_colors.dart';
import 'package:edulink_app/utils/app_styles.dart';
import 'package:flutter/material.dart';

class EmptyTestScreen extends StatelessWidget {
  const EmptyTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body:  SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.02),
                Custom_Lesson_orTest_name(screenWidth: screenWidth, name: 'Math',),
                SizedBox(height: screenHeight * 0.02),
                Center(child: Text('Course name' , style: AppStyles.primary30.copyWith(
                  fontSize: 26
                ),)),
                 SizedBox(height: screenHeight * 0.06),
                 CoursesTabsBar(screenWidth: screenWidth, selectedTab: LessonTab.tests, colorname: AppColors.lightGrayBlue,),
                 SizedBox(height: screenHeight * 0.06),
                 Column(
                   children: [
                     Image.asset(AppImages.empty_image, width: screenWidth,),
                     SizedBox(height: screenHeight * 0.02),
                     Text('Empty'.tr(), style: AppStyles.coalGray.copyWith(
                      fontSize: 28
                     ))
                   ],
                 )
              ],
            ),
          ),
        ),
      ),

    );
  }
}

