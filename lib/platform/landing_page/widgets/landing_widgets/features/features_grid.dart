import 'package:flutter/material.dart';
import 'feature_card.dart';

typedef _FeatureData = ({IconData icon, String title, String description});

const kFeatures = <_FeatureData>[
  (icon: Icons.video_call_outlined,     title: 'Educational Videos', description: 'Upload and organize educational videos by subject and topic.'),
  (icon: Icons.mic_none,                title: 'Audio Recordings',   description: 'Easily upload audio lectures for students to access anytime.'),
  (icon: Icons.attachment_outlined,     title: 'Attachments',        description: 'Add one or more attachments to each video lesson.'),
  (icon: Icons.assignment_outlined,     title: 'Exams & Quizzes',    description: 'Self-correcting tests with an integrated question bank.'),
  (icon: Icons.bar_chart_rounded,       title: 'Student Tracking',   description: 'Monitor student progress with detailed statistics and insights.'),
  (icon: Icons.messenger_outline_sharp, title: 'Discussion Forum',   description: 'Discuss subject-related topics and questions with students.'),
];

class FeaturesGrid extends StatelessWidget {
  const FeaturesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, constraints) {
      final w = constraints.maxWidth;
      final cols = w < 600 ? 1 : w < 1000 ? 2 : 3;
      const spacing = 24.0;
      final itemW = (w - spacing * (cols - 1)) / cols;
      return Wrap(
        spacing: spacing, runSpacing: spacing,
        children: kFeatures.map((f) => SizedBox(width: itemW,
              child: FeatureCard(icon: f.icon, title: f.title, description: f.description))).toList(),
      );
    });
  }
}
