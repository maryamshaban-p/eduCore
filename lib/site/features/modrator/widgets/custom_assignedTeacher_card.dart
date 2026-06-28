import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:edulink_app/site/features/modrator/widgets/custom_Card.dart';
import 'package:flutter/material.dart';

class CustomAssignedteacherCard extends StatelessWidget {
  final bool isWide;
  final List<TeacherChip> teachers;

  const CustomAssignedteacherCard({
    super.key,
    required this.isWide,
    required this.teachers,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'My Assigned Teachers',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.slate800,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: teachers
                .map((t) => TeacherChip(
                      initials: t.initials,
                      name: t.name,
                      subject: t.subject,
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class TeacherChip extends StatelessWidget {
  final String initials;
  final String name;
  final String subject;

  const TeacherChip({
    super.key,
    required this.initials,
    required this.name,
    required this.subject,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.slate200),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primaryXL,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              initials,
              style: const TextStyle(
                fontFamily: 'Inter',
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.slate800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subject,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: AppColors.slate500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}