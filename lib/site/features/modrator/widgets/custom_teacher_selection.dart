
// ignore: camel_case_types
import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:flutter/material.dart';

// ignore: camel_case_types
class custom_teacher_selection_widget extends StatefulWidget {
  const custom_teacher_selection_widget({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.teacherName,
    required this.subject,
  });

  final double screenWidth;
  final double screenHeight;
  final String teacherName;
  final String subject;

  @override
  State<custom_teacher_selection_widget> createState() => _custom_teacher_selection_widgetState();
}

// ignore: camel_case_types
class _custom_teacher_selection_widgetState extends State<custom_teacher_selection_widget> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: isSelected?Border.all(color: AppColors.primary) :Border.all(color: const Color.fromARGB(255, 213, 217, 220)),
        borderRadius: BorderRadius.circular(8)
      ),
      child: Row(
        children: [
          Checkbox(value: isSelected, onChanged: (value) {
            isSelected = value ?? false;
            setState(() {});
          }),
            SizedBox(width: widget.screenWidth * 0.01),
          Column(
            children: [
              Text(widget.teacherName, style: const TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.slate800)),
               SizedBox(height: widget.screenHeight * 0.01),
               Text(widget.subject, style: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.slate400)),
            ],
          ),
        ],
      ),
    );
  }
}