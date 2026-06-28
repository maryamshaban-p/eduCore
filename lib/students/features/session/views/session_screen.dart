import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:edulink_app/students/features/session/widgets/custom_course_header..dart';
import 'package:edulink_app/utils/app_Asset.dart';
import 'package:edulink_app/utils/app_styles.dart';
import 'package:flutter/material.dart';

class SessionScreen extends StatelessWidget {
  const SessionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  SizedBox(height: screenHeight * 0.02),
        CourseHeaderWidget(
  screenWidth: screenWidth,
  screenHeight: screenHeight,
  title: "Course Name > Introduction to Geometry",
  image: AppImages.lesson_image,
),

                SizedBox(height: screenHeight * 0.04),
                Text('Introduction ' , style: AppStyles.black25,),
                SizedBox(height: screenHeight * 0.02),
                Text(
  'Geometry is a branch of mathematics that studies\n'
  'shapes, sizes, and spaces.\n'
  'It helps us understand the structure of objects\n'
  'around us, from simple shapes to real-life designs.',
     style: AppStyles.black12.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
    height: 1.5,
  ),
),
                SizedBox(height: screenHeight * 0.03),
                Text('In this lesson,  you will learn about basic\n'
                'geometric elements such as points, lines,\n'
                'angles, and shapes. These concepts form\n'
                'the foundation for understanding geometry\n'
                'and using it in everyday situations.',
                style: AppStyles.black12.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
    height: 1.5,
  ),),
                 SizedBox(height: screenHeight * 0.08),
                 Container(
                   padding: EdgeInsets.all(screenWidth * 0.02),
                  decoration: BoxDecoration(
                     color: Theme.of(context).cardColor,
                    border: Border.all(color: const Color.fromARGB(255, 252, 249, 249)),
                    borderRadius: BorderRadius.circular(screenWidth * 0.04),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                     Icon(Icons.assignment , color: AppColors.backgroundDark,) ,
                     Column(
                      children: [
                        Text('Homework', style: AppStyles.coalGray12.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 14
                        ),),
                        SizedBox(height: screenHeight * 0.01),
                         Text('Introduction to Geometry', style: AppStyles.primary16.copyWith(
                          fontWeight: FontWeight.w600
                         ),),

                      ],
                     ),
                     IconButton(onPressed: (){}, icon: Icon(Icons.arrow_forward_ios_outlined, color: AppColors.backgroundDark,))
                    ],
                  )
    ,
                 )

                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
