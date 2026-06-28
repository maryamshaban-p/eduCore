/*import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:flutter/material.dart';

class AddStudentStep3 extends StatelessWidget {

  const AddStudentStep3({super.key});

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
                      'Confirm & Generate Credentials',
                      style: const TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.slate800),
                    ),
                  ),
                   SizedBox(height: screenHeight * 0.025),
                   Container(
                    width: screenWidth * 0.3,
                     padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 237, 234, 234),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Text('Name: mmmmmmmmmmmmm' , style: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.slate400),),
                        SizedBox(height: screenHeight * 0.01),
                       Text('Email: m@gmail.com' , style: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.slate400),),
                       SizedBox(height: screenHeight * 0.01),
                       Text(' Phone: 0103254467' , style: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.slate400),),
                       SizedBox(height: screenHeight * 0.01),
                       Text('Education Level: Secondary – 1st Year' , style: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.slate400),),
                       SizedBox(height: screenHeight * 0.01),
                       Text('Parent Phone: N/A' , style: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.slate400),),
                       SizedBox(height: screenHeight * 0.01),
                       Text('Teachers: Ms. Sara Khaled' , style: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.slate400),),

                    ],),
                    
                  ),
                  SizedBox(height: screenHeight * 0.025),
                   Container(
                    padding: const EdgeInsets.all(8),
                    width: screenWidth * 0.3,
                    decoration: BoxDecoration(
                      
                      color: const Color.fromARGB(255, 240, 250, 252),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      
                      children: [
                      Text('Generated Credentials' , style: const TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.slate800),),
                        SizedBox(height: screenHeight * 0.02),
                       Text('Username' , style: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.slate400),),
                       Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           Text('m.basy.2026' , style: const TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.slate800).copyWith(
                            fontSize: 11
                           ),),
                            IconButton(
                              icon: const Icon(Icons.copy, size: 16,),
                              onPressed: () {},
                            ),
                         ],
                       ),
                       Text('Password ' , style: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.slate400),),
                       SizedBox(height: screenHeight * 0.01),
                          Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           Text('Edu#9344' , style: const TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.slate800).copyWith(
                            fontSize: 11
                           ),),
                            IconButton(
                              icon: const Icon(Icons.copy, size: 16,),
                              onPressed: () {},
                            ),
                         ],
                       ),

                    ],),
                   ),
                          
                           SizedBox(height: screenHeight * 0.095),
                  
                ],
                      );
                    
                  
  }
}*/