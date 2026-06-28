import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'chart/enrollment_chart_builder.dart';

class EnrollmentChart extends StatelessWidget {
  final List<EnrollmentEntry> enrollmentData;

  const EnrollmentChart({super.key, required this.enrollmentData});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.slate200),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Enrollment per Subject',
            style: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.slate800)),
        const SizedBox(height: 24),
        enrollmentData.isEmpty
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: Text('No enrollment data yet', style: TextStyle(color: AppColors.slate400)),
                ),
              )
            : SizedBox(
                height: 260,
                child: BarChart(
                  EnrollmentChartBuilder.build(enrollmentData),
                  duration: const Duration(milliseconds: 250),
                ),
              ),
      ]),
    );
  }
}