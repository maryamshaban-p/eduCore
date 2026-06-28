import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class StatisticCircle extends StatelessWidget {
  final double percentage, radius;
  bool? isHome;

   StatisticCircle({super.key, isHome=true,required this.percentage, required this.radius});

  Color getColor() {
    if (percentage >= 70) return Colors.green;
    if (percentage >= 60) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: radius,
      lineWidth: isHome==true? 10.0:3.0,
      percent: percentage / 100,
      
      center: 
      isHome== true?
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "${percentage.toInt()}%",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,color:getColor() ),
          ),
         Text(
            "Grades Completed".tr(),
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400,color: Color(0xFF7F838B)),
          ),
        ],
      )
      : Text(
            "${percentage.toInt()}%",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color:getColor() ),
          ),
      progressColor: getColor(),
      backgroundColor: Colors.grey.shade300,
      circularStrokeCap: CircularStrokeCap.round,
      animation: true,
    );
  }
}