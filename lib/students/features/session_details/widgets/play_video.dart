import 'package:flutter/material.dart';

class CourseImage extends StatelessWidget {
  const CourseImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset('assets/images/Women_teacher.jpg'),
        Positioned.fill(
          child: Center(
            child: CircleAvatar(
              radius: 24,
              backgroundColor: Colors.white,
              child: Icon(Icons.arrow_right_rounded, size: 48),
            ),
          ),
        )
      ],
    );
  }
}