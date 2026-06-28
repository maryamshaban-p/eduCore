import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:edulink_app/site/features/modrator/widgets/custom_Card.dart';
import 'package:flutter/material.dart';

class CustomRecentlyaddedStudents extends StatelessWidget {
  const CustomRecentlyaddedStudents({super.key, required this.students});
  final List<StudentRow> students;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Recently Added Students',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.slate800,
            ),
          ),
          const SizedBox(height: 8),
          for (int i = 0; i < students.length; i++) ...[
            StudentRow(
              initials: students[i].initials,
              name: students[i].name,
              date: students[i].date,
            ),
            if (i < students.length - 1)
              const Divider(height: 1, color: AppColors.slate100),
          ],
        ],
      ),
    );
  }
}

class StudentRow extends StatelessWidget {
  final String initials;
  final String name;
  final String date;

  const StudentRow({
    super.key,
    required this.initials,
    required this.name,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.slate100,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              initials,
              style: const TextStyle(
                fontFamily: 'Inter',
                color: AppColors.slate600,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.slate800,
              ),
            ),
          ),
          Text(
            date,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              color: AppColors.slate500,
            ),
          ),
        ],
      ),
    );
  }
}
