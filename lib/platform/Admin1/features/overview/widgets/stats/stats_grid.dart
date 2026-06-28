import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:edulink_app/platform/Admin1/features/overview/data/models/adminOverview_model.dart';
import 'package:edulink_app/platform/Admin1/features/overview/widgets/stat_card.dart';
import 'package:flutter/material.dart';

typedef _StatMeta = ({String label, String key, IconData icon, Color iconColor, Color iconBg});

class StatsGrid extends StatelessWidget {
  final AdminOverviewModel stats;
  const StatsGrid({super.key, required this.stats});

  static const _meta = <_StatMeta>[
    (label: 'Total Teachers',   key: 'teachers',   icon: Icons.people_outline_rounded,  iconColor: AppColors.info,    iconBg: AppColors.infoBg),
    (label: 'Total Moderators', key: 'moderators', icon: Icons.shield_outlined,         iconColor: AppColors.primary, iconBg: AppColors.primaryXL),
    (label: 'Total Students',   key: 'students',   icon: Icons.school_outlined,         iconColor: AppColors.success, iconBg: AppColors.successBg),
    (label: 'Active Courses',   key: 'courses',    icon: Icons.bar_chart_rounded,       iconColor: AppColors.warning, iconBg: AppColors.warningBg),
  ];

  String _value(AdminOverviewModel s, String key) {
    switch (key) {
      case 'teachers':   return '${s.totalTeachers}';
      case 'moderators': return '${s.totalModerators}';
      case 'students':   return '${s.totalStudents}';
      case 'courses':    return '${s.activeCourses}';
      default:           return '0';
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final w = constraints.maxWidth;
      final count = w < 600 ? 1 : w < 900 ? 2 : 4;
      const spacing = 16.0;
      final cardW = (w - spacing * (count - 1)) / count;
      return Wrap(
        spacing: spacing, runSpacing: spacing,
        children: _meta.map((m) => SizedBox(
              width: cardW,
              child: StatCard(title: m.label, value: _value(stats, m.key), icon: m.icon, iconColor: m.iconColor, iconBg: m.iconBg),
            )).toList(),
      );
    });
  }
}
