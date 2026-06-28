/*import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:edulink_app/site/features/modrator/widgets/custom_teacher_selection.dart';
import 'package:flutter/material.dart';

class AddStudentStep2 extends StatelessWidget {
  const AddStudentStep2({super.key});

  @override
  Widget build(BuildContext context) {
        var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
   return  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Assign Teachers',
                      style: const TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.slate800),
                    ),
                  ),
                   SizedBox(height: screenHeight * 0.025),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Select at least one teacher.',
                      style: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.slate400),
                    ),
                  ),
                    SizedBox(height: screenHeight * 0.02),
                  Column(
                    children: [
                      custom_teacher_selection_widget(screenWidth: screenWidth, 
                      screenHeight: screenHeight, teacherName: 'Dr. Ahmed Hassan,', subject: 'Mathematics',),
                       SizedBox(height: screenHeight * 0.02),
                       custom_teacher_selection_widget(screenWidth: screenWidth, 
                      screenHeight: screenHeight, teacherName: 'Ms. Sara Khaled', subject: 'Physics',),

                       SizedBox(height: screenHeight * 0.02),
                                              custom_teacher_selection_widget(screenWidth: screenWidth, 
                      screenHeight: screenHeight, teacherName: 'Mr. Omar Youssef', subject: 'Mr. Omar Youssef',),
                    ],
                  ),
                  
               SizedBox(height: screenHeight * 0.025),
                  
                ],
                      );
                    
                 
  }
}*/
