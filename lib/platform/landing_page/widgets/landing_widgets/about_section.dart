import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:flutter/material.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(16, 54, 16, 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Text('About EduCore',
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'Inter', fontSize: 32,
                fontWeight: FontWeight.w700, color: AppColors.slate900)),
        SizedBox(height: 28),
        Text(
          'EduCore is an electronic system that allows teachers to upload educational videos and audio recordings and attach supplementary files, accessible online with regular follow-ups. Students can watch lectures, take quizzes with instant automatic grading, and benefit from 24/7 technical support — all designed to ensure a comprehensive educational experience. EduCore is available on Windows, Android & iOS mobile apps, and a web dashboard accessible from any browser.',
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: 'Inter', fontSize: 16, color: AppColors.slate600),
        ),
        SizedBox(height: 56),
      ]),
    );
  }
}
