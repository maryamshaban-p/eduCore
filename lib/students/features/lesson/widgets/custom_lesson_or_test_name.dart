
import 'package:edulink_app/utils/app_colors.dart';
import 'package:edulink_app/utils/app_styles.dart';
import 'package:flutter/material.dart';

// ignore: camel_case_types
class Custom_Lesson_orTest_name extends StatelessWidget {
  const Custom_Lesson_orTest_name({
    super.key,
    required this.screenWidth, required this.name,
  });

  final double screenWidth;
  final String name;
  @override
  Widget build(BuildContext context) {
    return Row(
      children:[
        IconButton(onPressed: (){}, icon: Icon(Icons.arrow_back_outlined , color: AppColors.lightBlueGray,)),
        SizedBox(width: screenWidth * 0.25),
        Text(name , style: AppStyles.lightBlueGray35.copyWith(
          fontSize: 26
        ),)
      ]
    );
  }
}
