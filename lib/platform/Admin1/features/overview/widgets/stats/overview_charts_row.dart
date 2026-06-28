import 'package:edulink_app/platform/Admin1/features/overview/data/models/adminOverview_model.dart';
import 'package:edulink_app/platform/Admin1/features/overview/widgets/enrollment_chart.dart';
import 'package:edulink_app/platform/Admin1/features/overview/widgets/recent_activity.dart';
import 'package:flutter/material.dart';
import 'package:edulink_app/platform/Admin1/features/overview/widgets/chart/enrollment_chart_builder.dart';

class OverviewChartsRow extends StatelessWidget {
  final List<ActivityItem> recentActivity;
  final List<EnrollmentEntry> enrollmentData;

  const OverviewChartsRow({
    super.key,
    required this.recentActivity,
    required this.enrollmentData,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 800) {
        return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(flex: 2, child: EnrollmentChart(enrollmentData: enrollmentData)),
          const SizedBox(width: 24),
          Expanded(flex: 2, child: RecentActivity(items: recentActivity)),
        ]);
      }
      return Column(children: [
        EnrollmentChart(enrollmentData: enrollmentData),
        const SizedBox(height: 24),
        RecentActivity(items: recentActivity),
      ]);
    });
  }
}